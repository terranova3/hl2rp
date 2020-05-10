ITEM.name = ".9mm Pistol"
ITEM.description = "A sidearm utilising 9mm Ammunition."
ITEM.model = "models/weapons/w_pistol.mdl"
ITEM.class = "weapon_pistol"
ITEM.weaponCategory = "sidearm"
ITEM.classes = {CLASS_EMP, CLASS_EOW}
ITEM.flag = "V"
ITEM.cpArmory = true;
ITEM.width = 2
ITEM.height = 1
ITEM.iconCam = {
	ang	= Angle(0.33879372477531, 270.15808105469, 0),
	fov	= 5.0470897275697,
	pos	= Vector(0, 200, -1)
}
ITEM.pacData = {
	[1] = {
		["children"] = {
			[1] = {
				["children"] = {
				},
				["self"] = {
					-- x, y, z
					["Angles"] = Angle(30,90,0),
					["Position"] = Vector(-7, 0,1),
					["UniqueID"] = "4249811628",
					["Size"] = 1,
					["Bone"] = "pelvis",
					["Model"] = "models/weapons/w_pistol.mdl",
					["ClassName"] = "model",
				},
			},
		},
		["self"] = {
			["ClassName"] = "group",
			["UniqueID"] = "907159818",
			["EditorExpand"] = true,
		},
	},
}