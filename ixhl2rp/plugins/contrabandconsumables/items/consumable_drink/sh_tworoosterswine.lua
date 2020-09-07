--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Two Roosters Wine";
ITEM.model = "models/mark2580/gtav/barstuff/plonk_rose.mdl";
ITEM.width = 1;
ITEM.height	= 2;
ITEM.description = "Cheap pinot noir for a cheap taste of red wine. It's bitter, sour, and has a low alcohol percentage.";
ITEM.permit = "consumables";
ITEM.price = 18;
ITEM.capacity = 750
ITEM.restoreStamina = 18;
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