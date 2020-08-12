--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of the author.
    
    Example item
--]]

local PLUGIN = PLUGIN;

ITEM.name = "CRU Cap";
ITEM.model = "models/fty/items/bluecap.mdl"
ITEM.price = 12
ITEM.description = "A slick, blue brimmed hat for members of the Civil Restoration Union.";
ITEM.flag = "a"
ITEM.bodyGroups = {
	["headgear"] = 5,
}
ITEM.iconCam = {
	pos = Vector(183.0735168457, 153.18095397949, 111.76369476318),
	ang = Angle(25, 220, 0),
	fov = 3.1911840599468,
}