--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Marlowe Wine";
ITEM.model = "models/mark2580/gtav/barstuff/plonk_white.mdl";
ITEM.width = 1;
ITEM.height = 2;
ITEM.description = "A crisp, rather weak merlot wine. It's probably a typical cabernet sauvignon. This probably didn't come from Bordeaux though.";
ITEM.permit = "consumables";
ITEM.price = 20;
ITEM.capacity = 750
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