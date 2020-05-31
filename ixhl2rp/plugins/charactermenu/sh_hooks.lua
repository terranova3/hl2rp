--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

function PLUGIN:OnCharacterCreated(client, character)
    if(character:GetSkin()) then
        character:SetData("skin", character:GetSkin())
    end

    character:SetData("traits", character:GetTraits())
end
