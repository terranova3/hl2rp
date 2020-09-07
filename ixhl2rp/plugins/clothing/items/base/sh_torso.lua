--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of the author.
--]]

ITEM.name = "Torso";
ITEM.model = "models/props_junk/cardboard_box004a.mdl";
ITEM.outfitCategory = "torso";
ITEM.category = "Clothing";
ITEM.description = "Torso Base";
ITEM.width = 1;
ITEM.height = 1;
ITEM.price = 40
ITEM.iconCam = {
	pos = Vector(0, -3, 241.83006286621),
	ang = Angle(90, -90, 0),
	fov = 7.6470588235294
}

ITEM.dropSound = {
"terranova/ui/clothes1.wav",
"terranova/ui/clothes2.wav",
"terranova/ui/clothes3.wav",
}

ITEM.backgroundColor = Color(19, 72, 96, 100)
ITEM.tool = "knife"
ITEM.breakdown = {
    [1] = {
        uniqueID = "cloth_scrap",
        amount = 1,
        data = {
			["stack"] = 3
		}
    }
}