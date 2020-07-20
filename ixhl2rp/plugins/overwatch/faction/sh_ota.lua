
FACTION.name = "Overwatch Transhuman Arm"
FACTION.description = "A transhuman Overwatch soldier produced by the Combine."
FACTION.color = Color(150, 50, 50, 255)
FACTION.pay = 40
FACTION.models = {"models/cultist/hl_a/vannila_combine/npc/combine_soldier.mdl"}
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.runSounds = {[0] = "NPC_CombineS.RunFootstepLeft", [1] = "NPC_CombineS.RunFootstepRight"}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	character:SetData("cpVoiceType", "hla")
	character:SetCustomClass("Overwatch Transhuman Arm")

	inventory:Add("ar2", 1)
	inventory:Add("ar2ammo", 2)
end

function FACTION:GetDefaultName(client)
	return "OTA-ECHO.OWS-" .. Schema:ZeroNumber(math.random(1, 99999), 5), true
end

FACTION_OTA = FACTION.index
