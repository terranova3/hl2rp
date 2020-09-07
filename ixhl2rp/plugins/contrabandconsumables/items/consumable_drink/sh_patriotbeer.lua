--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Patriot Beer";
ITEM.model = "models/mark2580/gtav/barstuff/Beer_Patriot.mdl";
ITEM.width = 1;
ITEM.height	= 2;
ITEM.description = "A drink for only a 'real' patriot. It tastes bitter, fruity, and strong. A typical lager.";
ITEM.permit = "consumables";
ITEM.price = 10;
ITEM.capacity = 355
ITEM.restoreStamina = 20;
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