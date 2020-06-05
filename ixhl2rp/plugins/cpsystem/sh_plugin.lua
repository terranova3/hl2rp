--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

PLUGIN.name = "Civil Protection System";
PLUGIN.description = "Full overhaul to Civil Protection, adding commands to handle naming and ranks. Implements off-duty units, bodygroups and derma changes to various menus.";
PLUGIN.author = "Adolphus";
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
cpSystem = cpSystem or {}
cpSystem.config = cpSystem.config or {}
cpSystem.cache = cpSystem.cache or nil

ix.util.Include("sv_plugin.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("cl_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/config", true);
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)
ix.util.IncludeDir(PLUGIN.folder .. "/meta", true)
ix.anim.SetModelClass("models/newcca/cca_unit.mdl", "metrocop");

-- Called when the plugin is initialized.
-- In a large database this can be expensive, don't reload cache on lua autorefresh.
function PLUGIN:PluginLoaded()
	if(cpSystem.cache == nil) then
		cpSystem.cache = {}
		cpSystem.cache.taglines = {}

		local query = mysql:Select("ix_characters")
		query:Select("faction")
		query:Select("data")
		query:WhereLike("faction", "metropolice")
		query:Callback(function(result)
			if (istable(result) and #result > 0) then
				for k, v in pairs(result) do 
					local data = util.JSONToTable(v.data or "[]")

					if(data.cpTagline and data.cpID) then
						table.insert(cpSystem.cache.taglines, {
							tagline = data.cpTagline, 
							id = data.cpID		
						})
					end
				end 
			end
		end)
		query:Execute()
	end
end
