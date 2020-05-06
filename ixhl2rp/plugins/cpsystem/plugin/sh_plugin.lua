--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

PLUGIN.biosignalLocations = {};
PLUGIN.requestLocations = {};
PLUGIN.cameraData = PLUGIN.cameraData or {};
PLUGIN.hudObjectives = PLUGIN.hudObjectives or {};
PLUGIN.socioStatus = PLUGIN.socioStatus or "GREEN";
PLUGIN.debug_paintBenchmark = PLUGIN.debug_paintBenchmark or 0;
PLUGIN.font = "HUDFont";
PLUGIN.maximumDistance = 300;
PLUGIN.sociostatusColors = {
	GREEN = Color(0, 255, 0),
	BLUE = Color(0, 128, 255),
	YELLOW = Color(255, 255, 0),
	RED = Color(255, 0, 0),
	BLACK = Color(128, 128, 128)
};

-- Includes all the metropolice pack files.
do
    local directory = "models/dpfilms/metropolice/";
	local files, folders = file.Find(directory .. "*.mdl", "GAME");

	for _, obj in pairs(files) do
        ix.anim.SetModelClass(directory .. obj, "metrocop");
	end;

	-- TODO Don't hardcode this
	ix.anim.SetModelClass("models/newcca/cca_unit.mdl", "metrocop");
end;

function PLUGIN:IncludeDirectory(name)
	local directory = PLUGIN.folder .. "/" .. name .. "/";
	for _, v in ipairs(file.Find(directory.."*.lua", "LUA")) do
		ix.util.Include(directory..v)
	end
end;

-- Returns if a character is a part of the MPF faction.
function PLUGIN:IsMetropolice(character)
    if(character:GetFaction() == FACTION_MPF) then
        return true;
    else
        return false;
    end;
end;