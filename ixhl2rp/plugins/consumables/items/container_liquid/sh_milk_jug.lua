--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Milk Jug";
ITEM.model = "models/props_junk/garbage_milkcarton001a.mdl";
ITEM.width = 2;
ITEM.height = 2;
ITEM.description = "A large milk jug.";
ITEM.capacity = 2000
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