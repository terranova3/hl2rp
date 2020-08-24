ITEM.name = "Makarov"
ITEM.description = "Classic, reliable Soviet handgun chambered in 9x18mm."
ITEM.model = "models/weapons/arccw_ins2/w_makarov.mdl"
ITEM.class = "arccw_ins2_makarov_tn"
ITEM.weaponCategory = "sidearm"
ITEM.flag = "V"
ITEM.width = 2
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(2, 0.5, 200),
	ang = Angle(90, 108, 0),
	fov = 4.1,
}
ITEM.cpArmory = true
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					["Invert"] = false,
					["EyeTargetName"] = "",
					["NoLighting"] = false,
					["OwnerName"] = "self",
					["AimPartName"] = "",
					["IgnoreZ"] = false,
					["AimPartUID"] = "",
					["Materials"] = "",
					["Name"] = "",
					["LevelOfDetail"] = 0,
					["NoTextureFiltering"] = false,
					["PositionOffset"] = Vector(0, 0, 0),
					["NoCulling"] = false,
					["Translucent"] = false,
					["DrawOrder"] = 0,
					["Alpha"] = 1,
					["Material"] = "",
					["Bone"] = "pelvis",
					["UniqueID"] = "4251342202",
					["BoneMerge"] = false,
					["EyeTargetUID"] = "",
					["Position"] = Vector(-7.162353515625, -1.9388008117676, -4.5009765625),
					["BlendMode"] = "",
					["Angles"] = Angle(6.790819644928, -88.49681854248, 3.8541214466095),
					["Hide"] = false,
					["EyeAngles"] = false,
					["Scale"] = Vector(1, 1, 1),
					["AngleOffset"] = Angle(0, 0, 0),
					["EditorExpand"] = false,
					["Size"] = 1,
					["Color"] = Vector(1, 1, 1),
					["ClassName"] = "model2",
					["IsDisturbing"] = false,
					["ModelModifiers"] = "",
					["Model"] = "models/weapons/arccw_ins2/w_makarov.mdl",
				},
			},
		},
		["self"] = {
			["DrawOrder"] = 0,
			["UniqueID"] = "3557420388",
			["AimPartUID"] = "",
			["Hide"] = false,
			["Duplicate"] = false,
			["ClassName"] = "group",
			["OwnerName"] = "self",
			["IsDisturbing"] = false,
			["Name"] = "my outfit",
			["EditorExpand"] = true,
		},
	},
}

ITEM.bDropOnDeath = true
