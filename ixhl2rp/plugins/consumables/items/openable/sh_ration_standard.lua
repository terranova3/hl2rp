--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Standard-Grade Ration Unit"
ITEM.model = Model("models/weapons/w_packatc.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "A vacuum-sealed ration packet that's only slightly better than it's lesser version."
ITEM.category = "Rations"
ITEM.noBusiness = true
ITEM.isRation = true
ITEM.contains = {
    [1] = {
        uniqueID = "standardgradesupppacket",
        amount = 1,
        data = {}
    },
    [2] = {
        uniqueID = "standardgrademealkit",
        amount = 1,
        data = {}
    },
    [3] = {
        uniqueID = "unionwater",
        amount = 1,
        data = {}
    },
    [4] = {
        uniqueID = "money",
        amount = 5,
        data = {}
	}
}
