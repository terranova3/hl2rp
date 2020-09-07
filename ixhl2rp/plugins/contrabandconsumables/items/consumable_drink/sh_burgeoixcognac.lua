--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Bourgeoix Cognac";
ITEM.model = "models/mark2580/gtav/barstuff/Bottle_Cognac.mdl";
ITEM.width = 1;
ITEM.height	= 2;
ITEM.description = "Fit for a prince. It says so on the label.";
ITEM.permit = "consumables";
ITEM.price = 35;
ITEM.capacity = 500
ITEM.restoreStamina = 30;
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