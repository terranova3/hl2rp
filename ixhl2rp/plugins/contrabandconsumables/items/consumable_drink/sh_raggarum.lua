--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Ragga Rum";
ITEM.model = "models/mark2580/gtav/barstuff/Rum_Bottle.mdl";
ITEM.width = 1;
ITEM.height	= 2;
ITEM.description = "Comically branded but decently tasting, strong rum.";
ITEM.permit = "consumables";
ITEM.price = 20;
ITEM.capacity = 750
ITEM.restoreStamina = 21;
ITEM.category = "Alcohol"
ITEM.flag = "R"
ITEM.tool = "cement_stone"
ITEM.breakdown = {
    [1] = {
        uniqueID = "scrap_glass",
        amount = 1,
        data = {}
    }
}
ITEM.dropSound = {
"terranova/ui/movingalcohol1.wav",
"terranova/ui/movingalcohol2.wav",
"terranova/ui/movingalcohol3.wav",
}