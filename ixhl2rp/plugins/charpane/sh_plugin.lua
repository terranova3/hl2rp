--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Character Panel";
PLUGIN.description = "Adds dynamic bodygroup support with an inventory character pane.";
PLUGIN.author = "Adolphus";

ix.util.Include("sv_database.lua");
ix.util.Include("sv_hooks.lua");
ix.util.IncludeDir(PLUGIN.folder .. "/meta", true);

-- Called when the client is checking if it has access to see the character panel
function PLUGIN:CharPanelCanUse(client)
	local character = client:GetCharacter()

	for k, v in pairs(character:GetInventory():GetItems()) do
		if(v.outfitCategory and v:GetData("equip") == true) then
			return false
		end
	end
end;