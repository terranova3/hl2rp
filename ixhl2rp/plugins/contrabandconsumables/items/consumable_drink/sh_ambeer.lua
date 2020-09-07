--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "A.M Beer";
ITEM.model = "models/mark2580/gtav/barstuff/Beer_AM.mdl";
ITEM.width = 1;
ITEM.height	= 2;
ITEM.description = "A pale ale comically branded for those who drink in the morning.";
ITEM.permit = "consumables";
ITEM.category = "Alcohol"
ITEM.flag = "R"
ITEM.price = 10;
ITEM.capacity = 355
ITEM.restoreStamina = 20;
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