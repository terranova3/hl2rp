
FACTION.name = "Administration"
FACTION.description = "Members of the Combine Civil Authority serving mankind through an authoritarian corruption of government."
FACTION.color = Color(255, 200, 100, 255)
FACTION.models = {
	"models/ug/new/citizens/female_01.mdl",
	"models/ug/new/citizens/female_02.mdl",
	"models/ug/new/citizens/female_03.mdl",
	"models/ug/new/citizens/female_04.mdl",
	"models/ug/new/citizens/female_05.mdl",
	"models/ug/new/citizens/female_06.mdl",
	"models/ug/new/citizens/female_07.mdl",
	"models/ug/new/citizens/female_08.mdl",
	"models/ug/new/citizens/female_10.mdl",
	"models/ug/new/citizens/female_11.mdl",
	"models/ug/new/citizens/female_17.mdl",
	"models/ug/new/citizens/female_19.mdl",
	"models/ug/new/citizens/female_21.mdl",
	"models/ug/new/citizens/female_22.mdl",
	"models/ug/new/citizens/female_23.mdl",
	"models/ug/new/citizens/female_24.mdl",
	"models/ug/new/citizens/male_01.mdl",
	"models/ug/new/citizens/male_02.mdl",
	"models/ug/new/citizens/male_03.mdl",
	"models/ug/new/citizens/male_04.mdl",
	"models/ug/new/citizens/male_05.mdl",
	"models/ug/new/citizens/male_06.mdl",
	"models/ug/new/citizens/male_07.mdl",
	"models/ug/new/citizens/male_08.mdl",
	"models/ug/new/citizens/male_09.mdl",
	"models/ug/new/citizens/male_10.mdl",
	"models/ug/new/citizens/male_11.mdl",
	"models/ug/new/citizens/male_12.mdl",
	"models/ug/new/citizens/male_13.mdl"
}
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

	inventory:Add("torso_brown_suit", 1)
	inventory:Add("dress_pants", 1)
end

FACTION.isDefault = false
FACTION.isGloballyRecognized = true

FACTION_ADMIN = FACTION.index
