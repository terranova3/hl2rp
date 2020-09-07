--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Carlsberg Beer";
ITEM.model = "models/griim/foodpack/beercan_carlsberg.mdl";
ITEM.width = 1;
ITEM.height	= 1;
ITEM.description = "A pale lager in a green can. It has a bitter, warm taste and is crisp to the mouth.";
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