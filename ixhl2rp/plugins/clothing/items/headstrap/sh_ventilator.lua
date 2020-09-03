--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.base = "base_headstrap";
ITEM.name = "Adjustable Gasmask";
ITEM.model = "models/fty/items/respirator.mdl"
ITEM.price = 45
ITEM.description = "This mask has two ventilator outlets at its side to allow for air filtering, and straps to allow for adjusting."
ITEM.flag = "A"
ITEM.category = "Clothing - MCS";
ITEM.gasImmunity = true
ITEM.bodyGroups = {
	["headstrap"] = 2
}
ITEM.iconCam = {
	pos = Vector(0, 200, 0),
	ang = Angle(0, 270, 0),
	fov = 1.7647058823529,
}