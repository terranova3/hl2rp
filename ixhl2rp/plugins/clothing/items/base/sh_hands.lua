--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of the author.
--]]

ITEM.name = "Hands";
ITEM.model = "models/props_junk/cardboard_box004a.mdl";
ITEM.outfitCategory = "hands";
ITEM.category = "Clothing";
ITEM.description = "Hands Base";
ITEM.width = 1;
ITEM.height = 1;
ITEM.backgroundColor = Color(19, 72, 96, 100)
ITEM.price = 40
ITEM.dropSound = {
"terranova/ui/clothes1.wav",
"terranova/ui/clothes2.wav",
"terranova/ui/clothes3.wav",
}

ITEM.iconCam = {
	pos = Vector(0, 0, 200),
	ang = Angle(90, 0, 0),
	fov = 2.9411764705882
}
ITEM.tool = "knife"
ITEM.breakdown = {
    [1] = {
        uniqueID = "cloth_scrap",
        amount = 1,
        data = {}
    }
}