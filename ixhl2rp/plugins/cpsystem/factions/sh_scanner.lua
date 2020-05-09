
--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]
local PLUGIN = PLUGIN;

FACTION.name = "Scanner"
FACTION.description = "A scanner unit belonging to the Civil Protection"
FACTION.color = Color(50, 100, 150)
FACTION.pay = 10
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.runSounds = {[0] = "NPC_MetroPolice.RunFootstepLeft", [1] = "NPC_MetroPolice.RunFootstepRight"}
FACTION.models = {
	"models/combine_scanner.mdl"
}

function FACTION:GetDefaultName(client)
	return self:GetScannerName(), true;
end

function FACTION:GetScannerName()
    local template = ix.config.Get("Scanner Naming Scheme");
    
	replacements = {
		["city"] = ix.config.Get("City Name"),
        ["abbreviation"] = ix.config.Get("Abbreviation"),
		["rank"] = "SCN",
		["id"] = Schema:ZeroNumber(math.random(1, 99999), 5)
    }

    local name = string.gsub(template, "%a+", 
	function(str)
		return replacements[str];
    end)
    
    return name;
end;

FACTION_SCN = FACTION.index
