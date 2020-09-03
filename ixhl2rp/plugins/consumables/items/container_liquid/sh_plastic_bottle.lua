--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Plastic Bottle";
ITEM.model = "models/props_junk/garbage_plasticbottle003a.mdl";
ITEM.width = 1;
ITEM.height = 2;
ITEM.description = "A large plastic bottle designed for holding liquid. This particular one was used for Cola.";
ITEM.capacity = 1250
ITEM.tool = "knife"
ITEM.breakdown = {
    [1] = {
        uniqueID = "chunk_of_plastic",
        amount = 1,
        data = {
			["stack"] = 2
		}
    }
}