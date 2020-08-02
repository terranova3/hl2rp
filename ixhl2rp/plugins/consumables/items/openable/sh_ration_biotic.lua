--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Biotic-Grade Sustenance Unit"
ITEM.model = Model("models/weapons/w_packatb.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "A vacuum-sealed plastic compartment filled with nutritious necessities for biotics."
ITEM.category = "Rations"
ITEM.noBusiness = true
ITEM.isRation = true
ITEM.contains = {
    [1] = {
        uniqueID = "bioticgradesuppunit",
        amount = 1,
        data = {}
    },
    [2] = {
        uniqueID = "unionwater",
        amount = 1,
        data = {}
    },
    [3] = {
        uniqueID = "money",
        amount = 0,
        data = {}
	},
	[4] = {
		uniqueID = "bioticmealkit",
		amount = 1,
		data = {}
	}
}

