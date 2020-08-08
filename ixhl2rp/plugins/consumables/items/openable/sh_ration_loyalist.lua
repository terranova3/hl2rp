--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Priority-Grade Ration Unit"
ITEM.model = Model("models/weapons/w_packatp.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "This is a loyalty-grade ration reserved for MCS workers or for those given loyalist status."
ITEM.category = "Rations"
ITEM.noBusiness = true
ITEM.isRation = true
ITEM.contains = {
    [1] = {
        uniqueID = "loyalgradesupppackage",
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
        amount = 5,
        data = {}
	},
	[4] = {
		uniqueID = "loyalgrademealkit",
		amount = 1,
        data = {}
	},
	[5] = {
		uniqueID = "unionchocolate",
		amount = 1,
		data = {}
	}
}
