--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]
local PLUGIN = PLUGIN;

FACTION.name = "Civil Protection"
FACTION.description = "A metropolice unit working as Civil Protection."
FACTION.color = Color(50, 100, 150)
FACTION.pay = 10
FACTION.description = "Civil Protection is essentially the Combine's secret police in all urban areas on Earth. They are ordinary human volunteers who have 'willingly' joined the Combine. Many join for more privileges, such as additional food, better living conditions, an increase in authority and status over others, or out of genuine sympathy and identification with the Combine's aims. "
FACTION.selectModelText = "Select an off-duty model"
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.runSounds = {
	[0] = {
		"HLAComVoice/footsteps/metrocop/foley_step_01.wav",
		"HLAComVoice/footsteps/metrocop/foley_step_03.wav",
		"HLAComVoice/footsteps/metrocop/foley_step_05.wav",
		"HLAComVoice/footsteps/metrocop/foley_step_07.wav",
		"HLAComVoice/footsteps/metrocop/foley_step_09.wav"
	},
	[1] = {
		"HLAComVoice/footsteps/metrocop/foley_step_02.wav",
		"HLAComVoice/footsteps/metrocop/foley_step_04.wav",
		"HLAComVoice/footsteps/metrocop/foley_step_06.wav",
		"HLAComVoice/footsteps/metrocop/foley_step_08.wav"
	},
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
		cca = true
	})
end;

-- [[ Override default functions ]] --
function FACTION:GetDefaultName(client) end;
function FACTION:OnNameChanged(client, oldValue, value) end;

FACTION_MPF = FACTION.index
