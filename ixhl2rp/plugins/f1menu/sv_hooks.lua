--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

function PLUGIN:ShowHelp(client)
    netstream.Start(client, "InfoToggle", true)
end;