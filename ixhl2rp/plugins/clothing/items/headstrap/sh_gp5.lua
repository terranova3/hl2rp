  
--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.base = "base_headstrap";
ITEM.name = "GP-5 Gasmask";
ITEM.model = "models/hardbass/gp5.mdl"
ITEM.description = "A Soviet gas mask, given to both the military and civilian population."
ITEM.price = 25
ITEM.flag = "A"
ITEM.gasImmunity = true

ITEM.pacData = {
    male = {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Skin"] = 0,
						["Invert"] = false,
						["LightBlend"] = 1,
						["CellShade"] = 0,
						["OwnerName"] = "self",
						["AimPartName"] = "",
						["IgnoreZ"] = false,
						["AimPartUID"] = "",
						["Passes"] = 1,
						["Name"] = "",
						["NoTextureFiltering"] = false,
						["DoubleFace"] = false,
						["PositionOffset"] = Vector(0, 0, 0),
						["IsDisturbing"] = false,
						["Fullbright"] = false,
						["EyeAngles"] = false,
						["DrawOrder"] = 0,
						["TintColor"] = Vector(0, 0, 0),
						["UniqueID"] = "1531629312",
						["Translucent"] = false,
						["LodOverride"] = -1,
						["BlurSpacing"] = 0,
						["Alpha"] = 1,
						["Material"] = "",
						["UseWeaponColor"] = false,
						["UsePlayerColor"] = false,
						["UseLegacyScale"] = false,
						["Bone"] = "head",
						["Color"] = Vector(255, 255, 255),
						["Brightness"] = 1,
						["BoneMerge"] = false,
						["BlurLength"] = 0,
						["Position"] = Vector(-0.4951171875, -2.9827880859375, -0.007415771484375),
						["AngleOffset"] = Angle(0, 0, 0),
						["AlternativeScaling"] = false,
						["Hide"] = false,
						["OwnerEntity"] = false,
						["Scale"] = Vector(1, 1, 1),
						["ClassName"] = "model",
						["EditorExpand"] = false,
						["Size"] = 1.1,
						["ModelFallback"] = "",
						["Angles"] = Angle(89.530426025391, -0.0005566927138716, -21.057468414307),
						["TextureFilter"] = 3,
						["Model"] = "models/hardbass/gp5.mdl",
						["BlendMode"] = "",
					},
				},
				[2] = {
					["children"] = {
					},
					["self"] = {
						["Jiggle"] = false,
						["DrawOrder"] = 0,
						["AlternativeBones"] = false,
						["FollowPartName"] = "",
						["Angles"] = Angle(-7.9114761319943e-06, -6.8755688667297, 0.00044692383380607),
						["OwnerName"] = "self",
						["AimPartName"] = "",
						["FollowPartUID"] = "",
						["Bone"] = "head",
						["InvertHideMesh"] = false,
						["ScaleChildren"] = false,
						["ClassName"] = "bone2",
						["FollowAnglesOnly"] = false,
						["Position"] = Vector(0, 0, 0),
						["AimPartUID"] = "",
						["UniqueID"] = "2036997163",
						["Hide"] = false,
						["Name"] = "",
						["Scale"] = Vector(1, 1, 1),
						["MoveChildrenToOrigin"] = false,
						["EditorExpand"] = false,
						["Size"] = 0.725,
						["PositionOffset"] = Vector(0, 0, 0),
						["IsDisturbing"] = false,
						["AngleOffset"] = Angle(0, 0, 0),
						["EyeAngles"] = false,
						["HideMesh"] = false,
					},
				},
				[3] = {
					["children"] = {
					},
					["self"] = {
						["ModelIndex"] = 1,
						["UniqueID"] = "3074030404",
						["AimPartUID"] = "",
						["Hide"] = false,
						["Name"] = "",
						["ClassName"] = "bodygroup",
						["OwnerName"] = "self",
						["IsDisturbing"] = false,
						["EditorExpand"] = false,
						["BodyGroupName"] = "headgear",
					},
				},
			},
			["self"] = {
				["DrawOrder"] = 0,
				["UniqueID"] = "3029211594",
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
    },
    female = {
		[1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Skin"] = 0,
						["Invert"] = false,
						["LightBlend"] = 1,
						["CellShade"] = 0,
						["OwnerName"] = "self",
						["AimPartName"] = "",
						["IgnoreZ"] = false,
						["AimPartUID"] = "",
						["Passes"] = 1,
						["Name"] = "",
						["NoTextureFiltering"] = false,
						["DoubleFace"] = false,
						["PositionOffset"] = Vector(0, 0, 0),
						["IsDisturbing"] = false,
						["Fullbright"] = false,
						["EyeAngles"] = false,
						["DrawOrder"] = 0,
						["TintColor"] = Vector(0, 0, 0),
						["UniqueID"] = "1531629312",
						["Translucent"] = false,
						["LodOverride"] = -1,
						["BlurSpacing"] = 0,
						["Alpha"] = 1,
						["Material"] = "",
						["UseWeaponColor"] = false,
						["UsePlayerColor"] = false,
						["UseLegacyScale"] = false,
						["Bone"] = "head",
						["Color"] = Vector(255, 255, 255),
						["Brightness"] = 1,
						["BoneMerge"] = false,
						["BlurLength"] = 0,
						["Position"] = Vector(-0.4951171875, -2.9827880859375, -0.007415771484375),
						["AngleOffset"] = Angle(0, 0, 0),
						["AlternativeScaling"] = false,
						["Hide"] = false,
						["OwnerEntity"] = false,
						["Scale"] = Vector(1, 1, 1),
						["ClassName"] = "model",
						["EditorExpand"] = false,
						["Size"] = 1,
						["ModelFallback"] = "",
						["Angles"] = Angle(89.530426025391, -0.0005566927138716, -21.057468414307),
						["TextureFilter"] = 3,
						["Model"] = "models/hardbass/gp5.mdl",
						["BlendMode"] = "",
					},
				},
				[2] = {
					["children"] = {
					},
					["self"] = {
						["Jiggle"] = false,
						["DrawOrder"] = 0,
						["AlternativeBones"] = false,
						["FollowPartName"] = "",
						["Angles"] = Angle(-7.9114761319943e-06, -6.8755688667297, 0.00044692383380607),
						["OwnerName"] = "self",
						["AimPartName"] = "",
						["FollowPartUID"] = "",
						["Bone"] = "head",
						["InvertHideMesh"] = false,
						["ScaleChildren"] = false,
						["ClassName"] = "bone2",
						["FollowAnglesOnly"] = false,
						["Position"] = Vector(0, 0, 0),
						["AimPartUID"] = "",
						["UniqueID"] = "2036997163",
						["Hide"] = false,
						["Name"] = "",
						["Scale"] = Vector(1, 1, 1),
						["MoveChildrenToOrigin"] = false,
						["EditorExpand"] = false,
						["Size"] = 0.725,
						["PositionOffset"] = Vector(0, 0, 0),
						["IsDisturbing"] = false,
						["AngleOffset"] = Angle(0, 0, 0),
						["EyeAngles"] = false,
						["HideMesh"] = false,
					},
				},
				[3] = {
					["children"] = {
					},
					["self"] = {
						["ModelIndex"] = 1,
						["UniqueID"] = "3074030404",
						["AimPartUID"] = "",
						["Hide"] = false,
						["Name"] = "",
						["ClassName"] = "bodygroup",
						["OwnerName"] = "self",
						["IsDisturbing"] = false,
						["EditorExpand"] = false,
						["BodyGroupName"] = "headgear",
					},
				},
			},
			["self"] = {
				["DrawOrder"] = 0,
				["UniqueID"] = "3029211594",
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
}

ITEM.iconCam = {
	pos = Vector(0, 200, 0),
	ang = Angle(0, 270, 0),
	fov = 3.3548001980537,
}