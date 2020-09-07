--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of the author.
--]]

ITEM.name = "Legs";
ITEM.model = "models/props_junk/cardboard_box004a.mdl";
ITEM.outfitCategory = "legs";
ITEM.category = "Clothing";
ITEM.description = "Legs Base";
ITEM.width = 1
ITEM.height = 1
ITEM.price = 40
ITEM.dropSound = {
"terranova/ui/clothes1.wav",
"terranova/ui/clothes2.wav",
"terranova/ui/clothes3.wav",
}

ITEM.iconCam = {
	pos = Vector(0, 0, 200),
	ang = Angle(89.083892822266, -89.995094299316, 0),
	fov = 8.8235294117647
}
ITEM.backgroundColor = Color(19, 72, 96, 100)
ITEM.tool = "knife"
ITEM.breakdown = {
    [1] = {
        uniqueID = "cloth_scrap",
        amount = 1,
        data = {
			["stack"] = 2
		}
    }
}