--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

FACTION.name = "Civil Protection"
FACTION.description = "A metropolice unit working as Civil Protection."
FACTION.color = Color(50, 100, 150)
FACTION.description = "Jackboots and a stunbaton serve as todays justice system. Those found in violation of it face a cruel civil servant."
FACTION.selectModelText = "Select an off-duty model"
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.runSounds = {[0] = "NPC_MetroPolice.RunFootstepLeft", [1] = "NPC_MetroPolice.RunFootstepRight"}
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

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()
	local cid = Schema:ZeroNumber(math.random(1, 99999), 5)
	local TimeString = os.date( "%H:%M:%S - %d/%m/%Y", os.time() )

	character:SetCustomClass("Citizen");
	character:SetData("cpCitizenName", character:GetName());
	character:SetData("cpCitizenDesc", character:GetDescription())
	character:SetData("cpDesc", character:GetCpdesc())
	character:SetData("cpCitizenModel", client:GetModel())
	character:SetData("cpTagline", character:GetTagline() or "ERROR");
	character:SetData("cpVoiceType", character:GetVoiceType() or "legacy")
	character:SetData("cpID", character:GetCpid() or 1);
	character:SetData("cid", cid);

	inventory:Add("cp_standard", 1, {
		name = character:GetCPTagline(),
	})
	inventory:Add("cid", 1, {
		citizen_name = character:GetName(),
		cid = cid,
		issue_date = tostring(TimeString),
		occupation = string.format("CP - %s", "Intention 5"),
		salary = 10,
		cca = true
	})
end;

-- [[ Override default functions ]] --
function FACTION:GetDefaultName(client) end;

FACTION_MPF = FACTION.index
