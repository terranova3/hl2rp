--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Mezcal";
ITEM.model = "models/mark2580/gtav/barstuff/tequila_bottle.mdl";
ITEM.width = 1;
ITEM.height	= 2;
ITEM.description = "This bottle of mezcal 'tequila' has a maguey larva in it. It's very strong and has an earthy aftertaste. It goes down clean and leaves a light sting at the back of the throat.";
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