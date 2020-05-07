--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]
local PLUGIN = PLUGIN;

FACTION.name = "Metropolice Force"
FACTION.description = "A metropolice unit working as Civil Protection."
FACTION.color = Color(50, 100, 150)
FACTION.pay = 10
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.runSounds = {[0] = "NPC_MetroPolice.RunFootstepLeft", [1] = "NPC_MetroPolice.RunFootstepRight"}
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
	local count = 0
	local inventory = character:GetInventory()
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)

	for _ in pairs(cpSystem.config.taglines) do count = count + 1 end

	character:SetData("customclass", "Citizen");
	character:SetData("cpCitizenName", character:GetName());
	character:SetData("cpCitizenDesc", cpSystem.config.cpDefaultDescription)
	character:SetData("cpRank", cpSystem.config.cpDefaultRank);
	character:SetData("cpTagline", cpSystem.config.taglines[math.random(1, count)]);
	character:SetData("cpID", Schema:ZeroNumber(math.random(1, 9), 1));
	character:SetData("cid", id);

	inventory:Add("cp_stunstick", 1)
	inventory:Add("cp_standard", 1, {
		name = PLUGIN:GetCPTagline(character),
	})
	inventory:Add("cid", 1, {
		name = character:GetName(),
		id = id
	})
end;

-- [[ Override default functions ]] --
function FACTION:GetDefaultName(client) end;
function FACTION:OnNameChanged(client, oldValue, value) end;

FACTION_MPF = FACTION.index
