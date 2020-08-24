--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

do  
	ix.char.RegisterVar("skin", {
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

	ix.char.RegisterVar("traits", {
		fieldType = ix.type.text,
		bNoDisplay = true,
		OnValidate = function(self, value, payload)
			local traits = payload.traits
			local philosophy = false

			if(!traits) then 
				return false, "You must select at least one trait."
			end

			for k, v in pairs(traits) do
				local trait = ix.traits.Get(v)

				if(trait.category == "Philosophy") then 
					philosophy = true
					break
				end
			end

			if(!philosophy) then 
				return false, "You must select at least one philosophy trait!"
			end

			return value or {}
		end,
		alias = "Traits"
	})

	ix.char.RegisterVar("cpid", {
		OnValidate = function(self, value, payload)
			local id = payload.cpid
			local faction = ix.faction.indices[payload.faction]

			if(faction == "Civil Protection") then
				if(!id) then
					return false, "You don't have a valid cp id!"
				end
			end

			return value or 0
		end,
		alias = "Cpid"
	})

	ix.char.RegisterVar("voicetype", {
		OnValidate = function(self, value, payload)
			local id = payload.voicetype
			local faction = ix.faction.indices[payload.faction]

			if(faction == "Civil Protection") then
				if(!id) then
					return false, "You don't have a valid voice type!"
				end
			end

			return value or "Legacy"
		end,
		alias = "VoiceType"
	})

	ix.char.RegisterVar("tagline", {
		OnValidate = function(self, value, payload)
			local tagline = payload.tagline
			local faction = ix.faction.indices[payload.faction]
			local valid = false
			
			if(faction == "Civil Protection") then
				for k, v in pairs(cpSystem.config.taglines) do
					if(tagline == v) then
						valid = true
						break
					end
				end

				if(!valid) then 
					return false, "You don't have a valid cp tagline!"
				end
			end

			return value or ""
		end,
		alias = "Tagline"
	})

	ix.char.RegisterVar("cpdesc", {
		default = "",
		OnValidate = function(self, value, payload)
			local faction = ix.faction.indices[payload.faction]
			
			if(faction == "Civil Protection") then
				value = string.Trim((tostring(value):gsub("\r\n", ""):gsub("\n", "")))
				local minLength = ix.config.Get("minDescriptionLength", 16)

				if (value:len() < minLength) then
					return false, "descMinLen", minLength
				elseif (!value:find("%s+") or !value:find("%S")) then
					return false, "invalid", "description"
				end
			end

			return value
		end,
		alias = "Cpdesc"
	})

end