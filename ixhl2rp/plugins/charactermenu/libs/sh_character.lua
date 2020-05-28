--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

do  
	ix.char.RegisterVar("skin", {
		field = "skin",
		fieldType = ix.type.number,
		default = 0,
		index = 2,
		category = "customization",
		OnValidate = function(self, value, payload)
			return value or 0;
		end,
		OnDisplay = function(self, container, payload)
			local skinSelect = container:Add("ixAttributeBar")
			skinSelect:Dock(TOP)
			skinSelect:SetText(" ");
			skinSelect.value = 0;
			skinSelect.OnChanged = function()
				payload:Set("skin", skinSelect.value);
			end;

			return skinSelect
		end,
		ShouldDisplay = function(self, container, payload)
			local faction = ix.faction.indices[payload.faction]
			
			if(faction.name == "Scanner") then 
				return false;
			end;

			return true;
		end,
		alias = "Skin"
	})
end