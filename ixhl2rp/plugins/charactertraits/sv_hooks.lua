--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- Calls the OnCharacterCreated hook of any traits the player has.
function PLUGIN:OnCharacterCreated(client, character) 
	ix.traits.CallHook("OnCharacterCreated", client); 
end;