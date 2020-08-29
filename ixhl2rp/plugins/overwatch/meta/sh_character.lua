--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN
local characterMeta = ix.meta.character

function characterMeta:IsOverwatch()
	local faction = self:GetPlayer():Team();

	if(faction == FACTION_OTA) then
		return true
	end;

	return false;
end

function characterMeta:GetOTAName()
    local template = PLUGIN.config.namingScheme
    
	replacements = {
		["city"] = ix.config.Get("City Name"),
        ["abbreviation"] = PLUGIN.config.abbreviation,
        ["division"] = self:GetData("division"),
		["rank"] = ix.ranks.Get(self:GetData("rank")).name,
		["id"] = self:GetData("id"),
    }

    local name = string.gsub(template, "%a+", 
	function(str)
		return replacements[str];
    end)
    
    return name;
end;