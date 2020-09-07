--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Bootleg Vodka";
ITEM.model = "models/teebeutel/metro/objects/bottle03.mdl";
ITEM.width = 1;
ITEM.height = 2;
ITEM.description = "A clear alcoholic drink that's supposed to be flavourless and scentless. This is neither.";
ITEM.permit = "consumables";
ITEM.price = 5;
ITEM.capacity = 500
ITEM.restoreStamina = 13;
ITEM.category = "Alcohol"
ITEM.flag = "M"
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