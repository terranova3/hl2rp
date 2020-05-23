--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;
PLUGIN.InfoMenuOpen = false;

function PLUGIN:IsInfoMenuOpen()
    return PLUGIN.InfoMenuOpen;
end;

netstream.Hook("InfoToggle", function(data)
	if (IsValid(LocalPlayer()) and LocalPlayer():GetCharacter()) then
		PLUGIN.InfoMenuOpen = !PLUGIN.InfoMenuOpen;
	end;
end);