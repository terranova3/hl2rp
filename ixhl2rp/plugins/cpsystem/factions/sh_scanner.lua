--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

FACTION.name = "Scanner"
FACTION.description = "The flying eyes and ears of the Combine occupation."
FACTION.color = Color(50, 100, 150)
FACTION.isDefault = false
FACTION.isGloballyRecognized = true
FACTION.runSounds = {[0] = "NPC_MetroPolice.RunFootstepLeft", [1] = "NPC_MetroPolice.RunFootstepRight"}
FACTION.models = {
	"models/combine_scanner.mdl"
}
FACTION.npcRelations = {
    ["npc_citizen"] = D_HT,
    ["npc_vortigaunt"] = D_HT,
    ["npc_metropolice"] = D_LI,
    ["npc_combinedropship"] = D_LI,
    ["npc_combinegunship"] = D_LI,
    ["npc_combine_s"] = D_LI,
    ["npc_strider"] = D_LI,
    ["npc_combine_camera"] = D_LI,
    ["npc_turret_ceiling"] = D_LI,
    ["npc_turret_floor"] = D_LI,
    ["npc_turret_ground"] = D_LI,
    ["npc_cscanner"] = D_LI,
    ["CombineElite"] = D_LI,
    ["npc_rollermine"] = D_LI,
    ["npc_manhack"] = D_LI,
    ["npc_sniper"] = D_LI,
    ["npc_helicopter"] = D_LI,
    ["npc_turret_floor_rebel"] = D_HT,
    ["Rebel"] = D_HT,
    ["combine_mine"] = D_LI
}

function FACTION:OnCharacterCreated(client, character)
	local inventory = character:GetInventory()

	inventory:Add("handheld_radio", 1)
end;

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
