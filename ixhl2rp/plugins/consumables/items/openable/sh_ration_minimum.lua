--[[
© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Minimal-Grade Ration Unit"
ITEM.model = Model("models/weapons/w_packati.mdl")
ITEM.width = 1
ITEM.height = 2
ITEM.description = "This is a minimum grade ration. It's nothing special. A bottle of water, and some weird grey goop in a jar."
ITEM.category = "Rations"
ITEM.noBusiness = true
ITEM.isRation = true
ITEM.contains = {
	[1] = {
		uniqueID = "money",
		amount = 0,
		data = {}
	},
	[2] = {
		uniqueID = "mingradesupppacket",
		amount = 1,
		data = {}
	},
	[3] = {
		uniqueID = "unionwater",
		amount = 1,
		data = {}
	}
}
	
