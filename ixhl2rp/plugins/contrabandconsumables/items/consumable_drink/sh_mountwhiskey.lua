--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Mount Whiskey";
ITEM.model = "models/mark2580/gtav/barstuff/Whiskey_Bottle.mdl";
ITEM.width = 1;
ITEM.height	= 2;
ITEM.description = "American-branded malt whiskey with an all-around good taste, given the amount of alcohol content. Better than Breen's piss.";
ITEM.permit = "consumables";
ITEM.price = 23;
ITEM.capacity = 750
ITEM.restoreStamina = 23;
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