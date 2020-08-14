--[[
	ix.container.Register(model, {
		name = "Crate",
		description = "A simple wooden create.",
		width = 4,
		height = 4,
		locksound = "",
		opensound = ""
	})
]]--

ix.container.Register("models/props_junk/wood_crate001a.mdl", {
	name = "Crate",
	description = "A simple wooden crate.",
	width = 4,
	height = 4,
})

ix.container.Register("models/props_c17/lockers001a.mdl", {
	name = "Locker",
	description = "A white locker.",
	width = 3,
	height = 5,
})

ix.container.Register("models/props_wasteland/controlroom_storagecloset001a.mdl", {
	name = "Metal Cabinet",
	description = "A green metal cabinet.",
	width = 4,
	height = 5,
})

ix.container.Register("models/hlvr/combine_hazardprops/combinehazardprops_container.mdl", {
	name = "CRU Footlocker",
	description = "A large, durable footlocker designed for keeping CRU decontamination equipment and hazardous wares.",
	width = 6,
	height = 4,
})

ix.container.Register("models/props_wasteland/controlroom_storagecloset001b.mdl", {
	name = "Metal Cabinet",
	description = "A green metal cabinet.",
	width = 4,
	height = 5,
})

ix.container.Register("models/props_wasteland/controlroom_filecabinet001a.mdl", {
	name = "File Cabinet",
	description = "A metal filing cabinet.",
	width = 5,
	height = 3
})

ix.container.Register("models/props_wasteland/controlroom_filecabinet002a.mdl", {
	name = "File Cabinet",
	description = "A metal filing cabinet.",
	width = 3,
	height = 6,
})

ix.container.Register("models/props_lab/filecabinet02.mdl", {
	name = "File Cabinet",
	description = "A metal filing cabinet.",
	width = 5,
	height = 3
})

ix.container.Register("models/props_c17/furniturefridge001a.mdl", {
	name = "Refrigerator",
	description = "A metal box for keeping food in.",
	width = 2,
	height = 3,
})

ix.container.Register("models/props_wasteland/kitchen_fridge001a.mdl", {
	name = "Large Refrigerator",
	description = "A large metal box for storing even more food in.",
	width = 4,
	height = 5,
})

ix.container.Register("models/props_junk/trashbin01a.mdl", {
	name = "Trash Bin",
	description = "What do you expect to find in here?",
	width = 2,
	height = 4,
})

ix.container.Register("models/props_junk/trashdumpster01a.mdl", {
	name = "Dumpster",
	description = "A dumpster meant to stow away trash. It emanates an unpleasant smell.",
	width = 6,
	height = 3
})

ix.container.Register("models/items/ammocrate_smg1.mdl", {
	name = "Ammo Crate",
	description = "A heavy crate that stores ammo.",
	width = 5,
	height = 3,
	OnOpen = function(entity, activator)
		local closeSeq = entity:LookupSequence("Close")
		entity:ResetSequence(closeSeq)

		timer.Simple(2, function()
			if (entity and IsValid(entity)) then
				local openSeq = entity:LookupSequence("Open")
				entity:ResetSequence(openSeq)
			end
		end)
	end
})

ix.container.Register("models/props_forest/footlocker01_closed.mdl", {
	name = "Footlocker",
	description = "A small chest to store belongings in.",
	width = 5,
	height = 3
})

ix.container.Register("models/Items/item_item_crate.mdl", {
	name = "Item Crate",
	description = "A crate to store some belongings in.",
	width = 5,
	height = 3
})

ix.container.Register("models/props_c17/cashregister01a.mdl", {
	name = "Cash Register",
	description = "A register with some buttons and a drawer.",
	width = 2,
	height = 1
})

ix.container.Register("models/props_c17/oildrum001.mdl", {
	name = "Oil Drum",
	description = "An old rusted hollow drum.",
	width = 3,
	height = 5
})

ix.container.Register("models/props/de_nuke/crate_small.mdl", {
	name = "Shipment Crate",
	description = "A wooden shipment crate.",
	width = 5,
	height = 5
})

ix.container.Register("models/kali/props/cases/hard case c.mdl", {
	name = "Footlocker",
	description = "An extremely durable armoured footlocker.",
	width = 6,
	height = 3
})

ix.container.Register("models/kali/props/cases/hard case a.mdl", {
	name = "Footlocker",
	description = "A large and extremely durable armoured footlocker.",
	width = 6,
	height = 5
})

ix.container.Register("models/props_c17/streetsign001c.mdl", {
	name = "Hidden Compartment 2x2",
	description = "",
	width = 2,
	height = 2
})

ix.container.Register("models/props_c17/streetsign002b.mdl", {
	name = "Hidden Compartment 3x3",
	description = "",
	width = 3,
	height = 3
})