--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "CPF-Grade Ration Unit"
ITEM.model = Model("models/weapons/w_packatm.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "A vacuum-sealed plastic flexi-container filled with the unit's salary, MRE, and a supplement packet."
ITEM.category = "Rations"
ITEM.noBusiness = true
ITEM.isRation = true
ITEM.contains = {
    [1] = {
        uniqueID = "cpfgradesupppack",
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
		uniqueID = "cpfgrademealkit",
		amount = 1,
		data = {}
	},
	[5] = {
		uniqueID = "unionchocolate",
		amount = 1,
		data = {}
	}
}

