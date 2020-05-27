--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Character Menu";
PLUGIN.description = "Changes the character menu and adds skin and facial hair for character customisation.";
PLUGIN.author = "Adolphus";

ix.util.Include("sh_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/derma/steps", true)

if (SERVER) then
	resource.AddFile("resource/fonts/CommonSans.ttf")
end