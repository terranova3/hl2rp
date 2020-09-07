--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Rockford Wine";
ITEM.model = "models/mark2580/gtav/barstuff/Wine_Red.mdl";
ITEM.width = 1;
ITEM.height	= 2;
ITEM.description = "High-society red wine that makes you talk special.";
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