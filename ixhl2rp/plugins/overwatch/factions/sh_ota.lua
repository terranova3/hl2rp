--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author.
--]]

FACTION.name = "Overwatch Transhuman Arm"
FACTION.description = "Either drafted or volunteered, members of the Overwatch Transhuman Arm today serve the Combine as eager suppressors of humanity, and their new lords ruthless exterminators."
FACTION.color = Color(150, 50, 50, 255)
FACTION.models = {"models/overwatch/terranova/overwatchepsilon.mdl"}
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.HideOnScoreboard = true
FACTION.runSounds = {[0] = "NPC_CombineS.RunFootstepLeft", [1] = "NPC_CombineS.RunFootstepRight"}
FACTION.npcRelations = {
    ["npc_citizen"] = D_HT,
    ["npc_vortigaunt"] = D_HT,
    ["npc_metropolice"] = D_LI,
    ["npc_combinedropship"] = D_LI,
    ["npc_combinegunship"] = D_LI,
    ["npc_combine_s"] = D_LI,
    ["npc_strider"] = D_LI,
    ["npc_combine_camera"] = D_LI,
    ["npc_turret_ceiling"] = D_LI,
    ["npc_turret_floor"] = D_LI,
    ["npc_turret_ground"] = D_LI,
    ["npc_cscanner"] = D_LI,
    ["CombineElite"] = D_LI,
    ["npc_rollermine"] = D_LI,
    ["npc_manhack"] = D_LI,
    ["npc_sniper"] = D_LI,
    ["npc_helicopter"] = D_LI,
    ["npc_turret_floor_rebel"] = D_HT,
    ["Rebel"] = D_HT,
    ["combine_mine"] = D_LI
}

function FACTION:OnCharacterCreated(client, character)
    local inventory = character:GetInventory()

	character:SetData("cpVoiceType", "HLA")
    character:SetCustomClass("Overwatch Transhuman Arm")

    inventory:Add("handheld_radio", 1)
end

function FACTION:GetDefaultName(client)
    -- Store this on the client object so we can access it later
    client.storedOtaName = Schema:ZeroNumber(math.random(1, 99999), 5)

	return "OTA:SR5.EPSILON-" .. client.storedOtaName, true
end

FACTION_OTA = FACTION.index
