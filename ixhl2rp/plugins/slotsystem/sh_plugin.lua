--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

PLUGIN.name = "Slot system";
PLUGIN.description = "Stores data about bodygroups for each character and adds bodygroup support for items.";
PLUGIN.author = "Adolphus";
PLUGIN.maxLength = 512;

ix.util.Include("sv_plugin.lua");

slotSystem = {}
slotSystem.slots = {
    "torso",
    "legs",
    "hands",
    "headgear",
    "bag",
    "glasses",
    "satchel",
    "pouch",
    "badge",
    "headstrap",
    "kevlar",
    "facialhair",
}

function PLUGIN:GiveBodygroup(character, slot, value)
    local index = character:GetPlayer():FindBodygroupByName(slot)

    if (index > -1) then
        if (value and value < 1) then
            value = nil
        end

        local groups = target:GetData("groups", {})

        groups[index] = value
        character:SetData("groups", groups)
        character:GetPlayer():SetBodygroup(index, value or 0)
    end;
end;
