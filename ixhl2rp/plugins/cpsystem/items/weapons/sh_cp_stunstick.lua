--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ITEM.name = "Stunstick"
ITEM.description = "A moderately sized metal rod with rubber grips coated from the base. You can see a small, plastic flick-switch that can be used to change the mode of the stunstick, increasing the voltage of electricity at the tip."
ITEM.model = "models/dpfilms/metropolice/props/hd_stunbaton.mdl"
ITEM.class = "ix_stunstick"
ITEM.weaponCategory = "offhand"
ITEM.flag = "V"
ITEM.factions = {FACTION_MPF, FACTION_OTA}
ITEM.width = 2
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(231.82511901855, 195.48719787598, 140.92288208008),
	ang = Angle(25, 220, 0),
	fov = 4.8935679067357
}
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Angles"] = Angle(0, 95, 0),
					["Position"] = Vector(8.5, -4, 0),
					["UniqueID"] = "4249811628",
					["Size"] = 1,
					["Bone"] = "pelvis",
					["Model"] = "models/dpfilms/metropolice/props/hd_stunbaton.mdl",
					["ClassName"] = "model",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "907159817",
			["EditorExpand"] = true,
		},
	},
}