
function Schema:LoadData()
	self:LoadRationDispensers()
	self:LoadVendingMachines()
	self:LoadCombineLocks()

	Schema.CombineObjectives = ix.data.Get("combineObjectives", {}, false, true)
end

function Schema:SaveData()
	self:SaveRationDispensers()
	self:SaveVendingMachines()
	self:SaveCombineLocks()
end

function Schema:PlayerSwitchFlashlight(client, enabled)
	if (client:IsCombine()) then
		return true
	end
end

function Schema:PlayerUse(client, entity)
	if (IsValid(client.ixScanner)) then
		return false
	end

	local character = client:GetCharacter()

	if (entity:IsDoor() and IsValid(entity.ixLock) and client:KeyDown(IN_SPEED)) then
		local eClass = entity.ixLock:GetClass()

		if(eClass == "ix_unionlock" and (character:GetInventory():HasItem("access_card") or character:IsCombine())) then
			entity.ixLock:Toggle(client)
		elseif(eClass == "ix_restorationlock" and (character:GetInventory():HasItem("restoration_card") or character:IsCombine())) then
			entity.ixLock:Toggle(client)
		elseif(eClass != "ix_unionlock" and character:IsCombine()) then
			entity.ixLock:Toggle(client)
		end

		return false
	end

	if(entity:GetClass() == "ix_rationdispenser" and client:KeyDown(IN_SPEED) and character:IsMetropolice() and CurTime() > (entity.nextUseTime or 0)) then
		entity:SetEnabled(!entity:GetEnabled())
		entity:EmitSound(entity:GetEnabled() and "buttons/combine_button1.wav" or "buttons/combine_button2.wav")

		Schema:SaveRationDispensers()
		entity.nextUseTime = CurTime() + 2

		return false
	end

	if (!client:IsRestricted() and entity:IsPlayer() and entity:IsRestricted() and !entity:GetNetVar("untying")) then
		entity:SetAction("@beingUntied", 5)
		entity:SetNetVar("untying", true)

		client:SetAction("@unTying", 5)

		client:DoStaredAction(entity, function()
			entity:SetRestricted(false)
			entity:SetNetVar("untying")
		end, 5, function()
			if (IsValid(entity)) then
				entity:SetNetVar("untying")
				entity:SetAction()
			end

			if (IsValid(client)) then
				client:SetAction()
			end
		end)
	end
end

function Schema:PlayerUseDoor(client, door)
	if (client:IsCombine() or client:GetCharacter():GetFaction() == FACTION_ADMIN) then
		if (!door:HasSpawnFlags(256) and !door:HasSpawnFlags(1024)) then
			door:Fire("open")
		end
	end
end

function Schema:PlayerLoadout(client)
	client:SetNetVar("restricted")
end

function Schema:PostPlayerLoadout(client)
	if (client:IsCombine()) then
		if (client:Team() == FACTION_OTA) then
			client:SetMaxHealth(150)
			client:SetHealth(150)
			client:SetArmor(150)
		elseif (client:IsScanner()) then
			if (client.ixScanner:GetClass() == "npc_clawscanner") then
				client:SetHealth(200)
				client:SetMaxHealth(200)
			end

			client.ixScanner:SetHealth(client:Health())
			client.ixScanner:SetMaxHealth(client:GetMaxHealth())
			client:StripWeapons()
		else
			client:SetArmor(self:IsCombineRank(client:Name(), "RCT") and 50 or 100)
		end
	end
end

function Schema:PrePlayerLoadedCharacter(client, character, oldCharacter)
	if (IsValid(client.ixScanner)) then
		client.ixScanner:Remove()
	end
end

function Schema:PlayerLoadedCharacter(client, character, oldCharacter)
	local faction = character:GetFaction()

	if (faction == FACTION_CITIZEN) then
		self:AddCombineDisplayMessage("@cCitizenLoaded", Color(255, 100, 255, 255))
	elseif (client:IsCombine()) then
		client:AddCombineDisplayMessage("@cCombineLoaded")
	end
end

function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	local factionTable = ix.faction.Get(client:Team())

	if (factionTable.runSounds and client:IsRunning()) then
		client:EmitSound(factionTable.runSounds[foot])
		return true
	end

	client:EmitSound(soundName)
	return true
end

function Schema:PlayerSpawn(client)
	client:SetCanZoom(client:IsCombine())
end

function Schema:PlayerDeath(client, inflicter, attacker)
	if (client:IsCombine()) then
		local location = client:GetArea() or "unknown location"

		self:AddCombineDisplayMessage("@cLostBiosignal")
		self:AddCombineDisplayMessage("@cLostBiosignalLocation", Color(255, 0, 0, 255), location)

		if (IsValid(client.ixScanner) and client.ixScanner:Health() > 0) then
			client.ixScanner:TakeDamage(999)
		end

		local sounds = {"npc/overwatch/radiovoice/on1.wav", "npc/overwatch/radiovoice/lostbiosignalforunit.wav"}
		local chance = math.random(1, 7)

		if (chance == 2) then
			sounds[#sounds + 1] = "npc/overwatch/radiovoice/remainingunitscontain.wav"
		elseif (chance == 3) then
			sounds[#sounds + 1] = "npc/overwatch/radiovoice/reinforcementteamscode3.wav"
		end

		sounds[#sounds + 1] = "npc/overwatch/radiovoice/off4.wav"

		for k, v in ipairs(player.GetAll()) do
			if (v:IsCombine()) then
				ix.util.EmitQueuedSounds(v, sounds, 2, nil, v == client and 100 or 80)
			end
		end
	end
end

function Schema:PlayerNoClip(client)
	if (IsValid(client.ixScanner)) then
		return false
	end
end

function Schema:EntityTakeDamage(entity, dmgInfo)
	if (IsValid(entity.ixPlayer) and entity.ixPlayer:IsScanner()) then
		entity.ixPlayer:SetHealth( math.max(entity:Health(), 0) )

		hook.Run("PlayerHurt", entity.ixPlayer, dmgInfo:GetAttacker(), entity.ixPlayer:Health(), dmgInfo:GetDamage())
	end
end

function Schema:PlayerHurt(client, attacker, health, damage)
	if (health <= 0) then
		return
	end

	if (client:IsCombine() and (client.ixTraumaCooldown or 0) < CurTime()) then
		local text = "External"

		if (damage > 50) then
			text = "Severe"
		end

		client:AddCombineDisplayMessage("@cTrauma", Color(255, 0, 0, 255), text)

		if (health < 25) then
			client:AddCombineDisplayMessage("@cDroppingVitals", Color(255, 0, 0, 255))
		end

		client.ixTraumaCooldown = CurTime() + 15
	end
end

function Schema:PlayerStaminaLost(client)
	client:AddCombineDisplayMessage("@cStaminaLost", Color(255, 255, 0, 255))
end

function Schema:PlayerStaminaGained(client)
	client:AddCombineDisplayMessage("@cStaminaGained", Color(0, 255, 0, 255))
end

local HLACOMDEAD = {
    "HLAComVoice/die_01.wav",
    "HLAComVoice/die_02.wav",
    "HLAComVoice/die_03.wav",
    "HLAComVoice/die_04.wav",
    "HLAComVoice/die_05.wav",
    "HLAComVoice/die_06.wav",
    "HLAComVoice/die_07.wav",
    "HLAComVoice/die_08.wav",
    "HLAComVoice/die_09.wav",
    "HLAComVoice/die_10.wav"
}
 
local HLACOMPAIN = {
    "HLAComVoice/pain_01.wav",
    "HLAComVoice/pain_02.wav",
    "HLAComVoice/pain_03.wav",
    "HLAComVoice/pain_04.wav",
    "HLAComVoice/pain_05.wav",
    "HLAComVoice/pain_06.wav",
    "HLAComVoice/pain_07.wav",
    "HLAComVoice/pain_08.wav",
    "HLAComVoice/pain_09.wav",
    "HLAComVoice/pain_10.wav"
}
 
function Schema:GetPlayerDeathSound(client)
    if (client:IsCombine()) then
        local sound = HLACOMDEAD[math.random(1, #HLACOMDEAD)]
 
        if (Schema:IsCombineRank(client:Name(), "SCN")) then
            sound = "NPC_CScanner.Die"
        elseif (Schema:IsCombineRank(client:Name(), "SHIELD")) then
            sound = "NPC_SScanner.Die"
        end
 
        for k, v in ipairs(player.GetAll()) do
            if (v:IsCombine()) then
                v:EmitSound(sound)
            end
        end
 
        return sound
    end
end
 
function Schema:GetPlayerPainSound(client)
    if (client:IsCombine()) then
        local sound = HLACOMPAIN[math.random(1, #HLACOMPAIN)]
 
        if (Schema:IsCombineRank(client:Name(), "SCN")) then
            sound = "NPC_CScanner.Pain"
        elseif (Schema:IsCombineRank(client:Name(), "SHIELD")) then
            sound = "NPC_SScanner.Pain"
        end
 
        return sound
    end
end

function Schema:OnNPCKilled(npc, attacker, inflictor)
	if (IsValid(npc.ixPlayer)) then
		hook.Run("PlayerDeath", npc.ixPlayer, inflictor, attacker)
	end
end

function Schema:CanPlayerJoinClass(client, class, info)
	if (client:IsRestricted()) then
		client:Notify("You cannot change classes when you are restrained!")

		return false
	end
end

local SCANNER_SOUNDS = {
	"npc/scanner/scanner_blip1.wav",
	"npc/scanner/scanner_scan1.wav",
	"npc/scanner/scanner_scan2.wav",
	"npc/scanner/scanner_scan4.wav",
	"npc/scanner/scanner_scan5.wav",
	"npc/scanner/combat_scan1.wav",
	"npc/scanner/combat_scan2.wav",
	"npc/scanner/combat_scan3.wav",
	"npc/scanner/combat_scan4.wav",
	"npc/scanner/combat_scan5.wav",
	"npc/scanner/cbot_servoscared.wav",
	"npc/scanner/cbot_servochatter.wav"
}

function Schema:KeyPress(client, key)
	if (IsValid(client.ixScanner) and (client.ixScannerDelay or 0) < CurTime()) then
		local source

		if (key == IN_USE) then
			source = SCANNER_SOUNDS[math.random(1, #SCANNER_SOUNDS)]
			client.ixScannerDelay = CurTime() + 1.75
		elseif (key == IN_RELOAD) then
			source = "npc/scanner/scanner_talk"..math.random(1, 2)..".wav"
			client.ixScannerDelay = CurTime() + 10
		elseif (key == IN_WALK) then
			if (client:GetViewEntity() == client.ixScanner) then
				client:SetViewEntity(NULL)
			else
				client:SetViewEntity(client.ixScanner)
			end
		end

		if (source) then
			client.ixScanner:EmitSound(source)
		end
	end
end

function Schema:PlayerSpawnObject(client)
	if (client:IsRestricted() or IsValid(client.ixScanner)) then
		return false
	end
end

function Schema:PlayerSpray(client)
	return true
end

local VOCODEROFF = {
    "HLAComVoice/combine_radio_off_01.wav",
    "HLAComVoice/combine_radio_off_02.wav",
    "HLAComVoice/combine_radio_off_04.wav",
    "HLAComVoice/combine_radio_off_05.wav",
    "HLAComVoice/combine_radio_off_06.wav",
    "HLAComVoice/combine_radio_off_07.wav",
    "HLAComVoice/combine_radio_off_08.wav",
    "HLAComVoice/combine_radio_off_09.wav",
    "HLAComVoice/combine_radio_off_10.wav",
    "HLAComVoice/combine_radio_off_11.wav",
    "HLAComVoice/combine_radio_off_12.wav"
}
 
local VOCODERON = {
    "HLAComVoice/combine_radio_on_01.wav",
    "HLAComVoice/combine_radio_on_02.wav",
    "HLAComVoice/combine_radio_on_03.wav",
    "HLAComVoice/combine_radio_on_04.wav",
    "HLAComVoice/combine_radio_on_05.wav",
    "HLAComVoice/combine_radio_on_06.wav",
    "HLAComVoice/combine_radio_on_07.wav",
    "HLAComVoice/combine_radio_on_08.wav",
    "HLAComVoice/combine_radio_on_09.wav"
}
 
function Schema:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
	if (chatType == "ic" or chatType == "w" or chatType == "y") then
		local class = self.voices.GetClass(speaker)

		for k, v in ipairs(class) do
			if(v != "dispatch") then
				local info = self.voices.Get(v, rawText)

				if (info) then
					local volume = 80

					if (chatType == "w") then
						volume = 60
					elseif (chatType == "y") then
						volume = 150
					end

					if (info.sound) then
						if (info.global) then
							netstream.Start(nil, "PlaySound", info.sound)
						else
							speaker.bTypingBeep = nil
							local sounds = {info.sound}

							if(speaker:IsCombine()) then
								table.insert(sounds, VOCODEROFF[math.random(1, #VOCODEROFF)])
							end

							ix.util.EmitQueuedSounds(speaker, sounds, nil, nil, volume)
						end
					end

					if (speaker:IsCombine()) then
						return string.format("<:: %s ::>", info.text)
					else
						return info.text
					end
				end
			end
		end

		if (speaker:IsCombine()) then
			return string.format("<:: %s ::>", text)
		end
	elseif(chatType == "dispatch") then
		local class = self.voices.GetClass(speaker)

		for k, v in ipairs(class) do
			if(v == "dispatch") then
				local info = self.voices.Get(v, rawText)

				if (info) then
					local volume = 80

					if (chatType == "w") then
						volume = 60
					elseif (chatType == "y") then
						volume = 150
					end

					if (info.sound) then
						if (info.global) then
							netstream.Start(nil, "PlaySound", info.sound)
						else
							speaker.bTypingBeep = nil
							ix.util.EmitQueuedSounds(speaker, {info.sound, VOCODEROFF[math.random(1, #VOCODEROFF)]}, nil, nil, volume)
						end
					end

					if (speaker:IsCombine()) then
						return string.format("<:: %s ::>", info.text)
					else
						return info.text
					end
				end
			end
		end

		if (speaker:IsCombine()) then
			return string.format("<:: %s ::>", text)
		end
	end
end

netstream.Hook("PlayerChatTextChanged", function(client, key)
    if (client:IsCombine() and !client.bTypingBeep
    and (key == "y" or key == "w" or key == "r" or key == "t")) then
        client:EmitSound(VOCODERON[math.random(1, #VOCODERON)])
        client.bTypingBeep = true
    end
end)
 
netstream.Hook("PlayerFinishChat", function(client)
    if (client:IsCombine() and client.bTypingBeep) then
        client:EmitSound(VOCODEROFF[math.random(1, #VOCODEROFF)])
        client.bTypingBeep = nil
    end
end)

netstream.Hook("ViewDataUpdate", function(client, target, text)
	if (IsValid(target) and hook.Run("CanPlayerEditData", client, target) and client:GetCharacter() and target:GetCharacter()) then
		local data = {
			text = string.Trim(text:sub(1, 1000)),
			editor = client:GetCharacter():GetName()
		}

		target:GetCharacter():SetData("combineData", data)
		Schema:AddCombineDisplayMessage("@cViewDataFiller", nil, client)
	end
end)

netstream.Hook("ViewObjectivesUpdate", function(client, text)
	if (client:GetCharacter() and hook.Run("CanPlayerEditObjectives", client)) then
		local date = ix.date.GetSerialized()
		local data = {
			text = text:sub(1, 1000),
			lastEditPlayer = client:GetCharacter():GetName(),
			lastEditDate = date
		}

		ix.data.Set("combineObjectives", data, false, true)
		Schema.CombineObjectives = data
		Schema:AddCombineDisplayMessage("@cViewObjectivesFiller", nil, client, date:spanseconds())
	end
end)
