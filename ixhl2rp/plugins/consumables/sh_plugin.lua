--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Consumables";
PLUGIN.description = "Stores all the consumable items that are used in TERRANOVA.";
PLUGIN.author = "Specky";

ix.util.Include("sv_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/meta", true);

if(SERVER) then
	local PLUGIN = PLUGIN

	function PLUGIN:InventoryItemAdded(oldInv, inventory, item)
		if(item.isRation and item:GetData("salary", 0) == 0) then
			local character = inventory:GetOwner():GetCharacter()

			for k, v in pairs(inventory:GetItems()) do
				if(v.uniqueID == "cid" and v:GetData("cid", 00000) == character:GetData("cid", 00000)) then
					item:SetData("salary", v:GetData("salary", 0))
	
					break
				end
			end
		end
	end
end

