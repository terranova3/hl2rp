--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local Schema = Schema;
local PLUGIN = PLUGIN;

util.AddNetworkString("ixCpSystemRequestTaglines")
util.AddNetworkString("ixCpSystemReceiveTaglines")

function PLUGIN:LoadData()
	for _, v in ipairs(self:GetData() or {}) do
		local entity = ents.Create("ix_uniformgen")
		entity:SetPos(v.pos)
		entity:SetAngles(v.angles)
		entity:Spawn()

		entity:SetModel(v.model)
		entity:SetSkin(v.skin or 0)
		entity:SetSolid(SOLID_BBOX)
		entity:PhysicsInit(SOLID_BBOX)

		local physObj = entity:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end

	local query = mysql:Select("ix_characters")
	query:Select("faction")
	query:Select("data")
	query:WhereLike("faction", "metropolice")
	query:Callback(function(result)
		if (istable(result) and #result > 0) then
			for k, v in pairs(result) do 
				local data = util.JSONToTable(v.data or "[]")

				if(data.cpTagline != nil and data.cpID != nil and cpSystem.cache.taglines) then
					table.insert(cpSystem.cache.taglines, {
						tagline = data.cpTagline, 
						id = tonumber(data.cpID)
					})
				end
			end 
		end
	end)
	query:Execute()
end

-- Add to the cache that was built on server launch since it doesn't auto refresh the server query for performance reasons.
function PLUGIN:OnCharacterCreated(client, character)
	if(character:IsMetropolice()) then
		self:AddToCache(character)
		self:SendCache()
	end
end

-- Remove from the cache when a character is deleted.
function PLUGIN:PreCharacterDeleted(client, character)
	self:RemoveFromCache(character)
	self:SendCache()
end

function PLUGIN:RemoveFromCache(character)
	if(character:IsMetropolice()) then
		local tagline = character:GetData("cpTagline")
		local id = character:GetData("cpID")

		if(id and tagline) then
			for k, v in pairs(cpSystem.cache.taglines) do
				if(v.tagline == tagline and v.id == id) then
					cpSystem.cache.taglines[k] = nil
				end
			end
		end
	end
end

function PLUGIN:AddToCache(character)
	if(character:IsMetropolice()) then
		table.insert(cpSystem.cache.taglines, {
			tagline = character:GetTagline() or character:GetData("cpTagline"),
			id = character:GetCpid() or tonumber(character:GetData("cpID"))
		})
	end
end

-- Rebuild for all clients
function PLUGIN:SendCache()
	for _, v in ipairs(player.GetAll()) do
		netstream.Start(v, "ReceiveTaglineCache", cpSystem.cache.taglines)
	end
end

function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	local factionTable = ix.faction.Get(client:Team());
	local character = client:GetCharacter();

	if(character:IsUndercover()) then
		client:EmitSound(soundName);
		return true;
	end;

	if (factionTable.runSounds and client:IsRunning()) then
		if(istable(factionTable.runSounds[foot])) then
			local rand = math.random(1, #factionTable.runSounds[foot])

			client:EmitSound(factionTable.runSounds[foot][rand])
		else
			client:EmitSound(factionTable.runSounds[foot]);
		end

		return true;
	end

	client:EmitSound(soundName);
	return true;
end

function PLUGIN:PlayerLoadedCharacter(client, character)
	local faction = character:GetFaction()
	
	if(faction == FACTION_SCN) then
		character:SetClass(CLASS_SCN);
	end;

	if(faction == FACTION_MPF) then
		self:CheckForErrors(client, character)

		if(character:GetName() == character:GetCPName()) then
			if(!string.find(character:GetName(), ix.config.Get("City Name"))) then
				character:SetName(character:GetCPName());
			end;
		end;
	end;

	-- Adds player to the correct class --
	if(faction == FACTION_MPF) then
		if (!string.find(character:GetName(), ix.config.Get("City Name"))) then
			character:SetClass(CLASS_MPUH); 
			character:SetCustomClass("Citizen");
		else
			character:SetClass(CLASS_MPU); 	
			character:SetCustomClass("Civil Protection");	
		end;
	end;
end;

-- Sometimes data might disappear. Make sure we always have data.
function PLUGIN:CheckForErrors(client, character)
	local faction = character:GetFaction()

	if(!character:GetData("cpID")) then
		character:SetData("cpID", 1);
	end

	if(!character:GetData("cpTagline")) then
		character:SetData("cpTagline", "ERROR");
	end

	if(!character:GetData("rank")) then
		character:SetData("rank", ix.ranks.GetDefaultRank(faction))
	end

	if(!character:GetData("cpCitizenName")) then
		character:SetData("cpCitizenName", "Fatal error")
	end

	if(!character:GetData("cpCitizenDesc")) then
		character:SetData("cpCitizenDesc", "Fatal error")
	end

	if(!character:GetData("cpDesc")) then
		character:SetData("cpDesc", "Fatal error")
	end
end

-- Called just after a player spawns.
function PLUGIN:PlayerSpawn(client)
	if (client:IsCombine()) then
		netstream.Start(client, "RecalculateHUDObjectives", PLUGIN.socioStatus)
	end;
end;

function PLUGIN:OnCharacterRankChanged(character, target, rank)
	if(target:IsMetropolice()) then
		local notification = cpSystem.config.notification;
		notification.text = "Your rank has been changed to:";
		notification.additional = string.format("'Rank - %s'", rank.displayName)

		ix.notify.SendMessage(target:GetPlayer(), notification);
		target:UpdateCPStatus()
	end;
end

-- Called when we need to setup bodygroups for a rank
function PLUGIN:SetupRankBodygroups(character)
	if(character:IsMetropolice()) then
		if(!character:IsUndercover()) then
			local spec = character:GetSpec()
			local rank = character:GetRank()

			for k, v in pairs(character:GetRankBodygroups()) do
				if((spec and k == 2) and rank.overrideBodygroup != true) then
					character:GetPlayer():SetBodygroup(k, v+spec.offset)	
				else	
					character:GetPlayer():SetBodygroup(k, v)
				end
			end
		end

		return false
	else
		return true
	end
end


net.Receive("ixCpSystemRequestTaglines", function(length, client)
	net.Start("ixCpSystemReceiveTaglines")
		net.WriteTable(cpSystem.cache.taglines or {})
	net.Send(client)
end)