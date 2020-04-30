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

function FACTION:OnCharacterCreated(client, character)
	local count = 0
	for _ in pairs(cpSystem.config.taglines) do count = count + 1 end

	character:SetData("cpCitizenName", character:GetName());
	character:SetData("cpCitizenDesc", cpSystem.config.cpDefaultDescription)
	character:SetData("cpRank", "D");
	character:SetData("cpTagline", cpSystem.config.taglines[math.random(1, count)]);
	character:SetData("cpID", Schema:ZeroNumber(math.random(1, 9), 1));
end;

-- [[ Override default functions ]] --
function FACTION:GetDefaultName(client) end;
function FACTION:OnNameChanged(client, oldValue, value) end;

FACTION_MPF = FACTION.index
