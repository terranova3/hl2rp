--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ITEM.name = "Civil Protection Commendation";
ITEM.category = "Medals";
ITEM.description = "An achievement weighed down both by the precious metals it was forged from and the unforeseen burden the recipient may carry along with it. A dull gold plated coin with a silver dove in the center. A medal of devout cause. It goes well on your lapel. ";
ITEM.model = "models/pins/devotedserviceawardsilveronbronze.mdl"
ITEM.width = 1
ITEM.outfitCategory = "pin";
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0.40000000596046, 0, 222.22222900391),
	ang = Angle(89.900001525879, 180, 0),
	fov = 0.58823529411765
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