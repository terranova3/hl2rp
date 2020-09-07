--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Cardiaque Brandy";
ITEM.model = "models/mark2580/gtav/barstuff/Bottle_Brandy.mdl";
ITEM.width = 1;
ITEM.height = 2;
ITEM.description = "An extremely tasty, fancy brandy that recalls a forgotten time.";
ITEM.permit = "consumables";
ITEM.price = 25;
ITEM.capacity = 750
ITEM.restoreStamina = 25;
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