local PLUGIN = PLUGIN;

PLUGIN.name = "Forcefields";
PLUGIN.description = "Adds forcefields from Clockwork that don't crash the server.";
PLUGIN.author = "Adolphus";

PLUGIN.blocked = {
};
PLUGIN.modes = {};
PLUGIN.modes[1] = {
	function(client)
		if (IsValid(client)) then
			if (PLUGIN.blocked[client:GetCharacter():GetFaction()]) then
				return true;
			else
				return false;
			end;
		end;
	end,
	"Allow all citizens."
};
PLUGIN.modes[2] = {
	function(player) 
		return true; 
	end, "Never allow citizens."
};
PLUGIN.modes[3] = {
	function(player) 
		return false; 
	end, "Off.";
}

ix.util.Include("cl_init.lua");
ix.util.Include("sh_hooks.lua");
ix.util.Include("sv_hooks.lua");