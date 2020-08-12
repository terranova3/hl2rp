
FACTION.name = "Overwatch Transhuman Arm"
FACTION.description = "A serving member of the Overwatch Transhuman Arm. The Arm is made up of drafted military personel from just after the war, and in recent years, post-war volunteer. These individuals serve the Combine collective ruthlessly."
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
	return "OTA:SR5.EPSILON-" .. Schema:ZeroNumber(math.random(1, 99999), 5), true
end

FACTION_OTA = FACTION.index
