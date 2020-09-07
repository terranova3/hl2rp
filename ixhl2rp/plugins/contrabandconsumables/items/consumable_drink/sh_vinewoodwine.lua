--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Vinewood Wine";
ITEM.model = "models/mark2580/gtav/barstuff/wine_white.mdl";
ITEM.width = 1;
ITEM.height	= 2;
ITEM.description = "A bottle of delicious, sweet Moscato. This wine is very weak, and is considered by wine drinkers to be 'sugar juice'.";
ITEM.permit = "consumables";
ITEM.price = 15;
ITEM.capacity = 750
ITEM.restoreStamina = 15;
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