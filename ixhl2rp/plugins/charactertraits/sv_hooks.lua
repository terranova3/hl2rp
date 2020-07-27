--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- Calls the OnCharacterCreated hook of any traits the player has.
function PLUGIN:OnCharacterCreated(client, character) 
	for _, v in pairs(character:GetData("traits", {})) do
		v = ix.traits.Get(v);
		
		if(v.OnCharacterCreated) then
			v:OnCharacterCreated(character)
		end
	end
end;

-- Calls the CharacterLoaded hook of any traits the player has.
function PLUGIN:CharacterLoaded(character)
	for _, v in pairs(character:GetData("traits", {})) do
		v = ix.traits.Get(v);

		if(v.CharacterLoaded) then
			v:CharacterLoaded(character)
		end
	end
end