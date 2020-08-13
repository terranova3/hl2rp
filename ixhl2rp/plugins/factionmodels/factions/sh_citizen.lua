
FACTION.name = "Citizen"
FACTION.description = "What remains of humanity. These citizens occupy Earth's last remaining cities and live under a harsh, cruel occupation."
FACTION.color = Color(150, 125, 100, 255)
FACTION.isDefault = true
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
    ["npc_citizen"] = D_LI,
    ["npc_vortigaunt"] = D_LI,
    ["npc_metropolice"] = D_HT,
    ["npc_combinedropship"] = D_HT,
    ["npc_combinegunship"] = D_HT,
    ["npc_combine_s"] = D_HT,
    ["npc_strider"] = D_HT,
    ["npc_combine_camera"] = D_HT,
    ["npc_turret_ceiling"] = D_HT,
    ["npc_turret_floor"] = D_HT,
    ["npc_turret_ground"] = D_HT,
    ["npc_cscanner"] = D_HT,
    ["CombineElite"] = D_HT,
    ["npc_rollermine"] = D_HT,
    ["npc_manhack"] = D_HT,
    ["npc_sniper"] = D_HT,
    ["npc_helicopter"] = D_HT,
    ["npc_turret_floor_rebel"] = D_LI,
    ["Rebel"] = D_LI,
    ["combine_mine"] = D_HT
}


function FACTION:OnCharacterCreated(client, character)
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)
	local inventory = character:GetInventory()

	character:SetData("cid", id)
	inventory:Add("cid", 1, {
		citizen_name = character:GetName(),
		cid = character:GetData("cid", id),
		paygrade = "Unemployed",
		salary = 0,
		issue_date = ix.date.GetFormatted("%A, %B %d, %Y. %H:%M:%S"),
	})
end

FACTION_CITIZEN = FACTION.index
