--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.base = "base_headstrap";
ITEM.name = "Surgical Mask";
ITEM.model = "models/rebs/maske/maske.mdl"
ITEM.price = 5
ITEM.description = "Protects you from potentially dangerous particles, ensuring you stay safe of disease... or so they say."
ITEM.flag = "a"
ITEM.gasImmunity = false
ITEM.skin = 1

ITEM.pacData = {
    male = {
        [1] = {
			["children"] = {
				[1] = {
					["children"] = {
					},
					["self"] = {
						["Skin"] = 1,
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
						["UniqueID"] = "3629707872",
						["Translucent"] = false,
						["LodOverride"] = -1,
						["BlurSpacing"] = 0,
						["Alpha"] = 1,
						["Material"] = "",
						["UseWeaponColor"] = false,
						["UsePlayerColor"] = false,
						["UseLegacyScale"] = false,
						["Bone"] = "mouth",
						["Color"] = Vector(255, 255, 255),
						["Brightness"] = 1,
						["BoneMerge"] = false,
						["BlurLength"] = 0,
						["Position"] = Vector(-0.5341796875, 0.0076751708984375, -0.0009765625),
						["AngleOffset"] = Angle(0, 0, 0),
						["AlternativeScaling"] = false,
						["Hide"] = false,
						["OwnerEntity"] = false,
						["Scale"] = Vector(1.1000000238419, 1, 1),
						["ClassName"] = "model",
						["EditorExpand"] = false,
						["Size"] = 1,
						["ModelFallback"] = "",
						["Angles"] = Angle(0, 0, 0),
						["TextureFilter"] = 3,
						["Model"] = "models/rebs/maske/maske.mdl",
						["BlendMode"] = "",
					},
				},
			},
			["self"] = {
				["DrawOrder"] = 0,
				["UniqueID"] = "1590370554",
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
						["Skin"] = 1,
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
						["UniqueID"] = "3629707872",
						["Translucent"] = false,
						["LodOverride"] = -1,
						["BlurSpacing"] = 0,
						["Alpha"] = 1,
						["Material"] = "",
						["UseWeaponColor"] = false,
						["UsePlayerColor"] = false,
						["UseLegacyScale"] = false,
						["Bone"] = "mouth",
						["Color"] = Vector(255, 255, 255),
						["Brightness"] = 1,
						["BoneMerge"] = false,
						["BlurLength"] = 0,
						["Position"] = Vector(-0.73818928003311, 0.0076295137405396, 0.015545964241028),
						["AngleOffset"] = Angle(0, 0, 0),
						["AlternativeScaling"] = false,
						["Hide"] = false,
						["OwnerEntity"] = false,
						["Scale"] = Vector(1.1000000238419, 1, 1),
						["ClassName"] = "model",
						["EditorExpand"] = false,
						["Size"] = 0.9,
						["ModelFallback"] = "",
						["Angles"] = Angle(0, 0, 0),
						["TextureFilter"] = 3,
						["Model"] = "models/rebs/maske/maske.mdl",
						["BlendMode"] = "",
					},
				},
			},
			["self"] = {
				["DrawOrder"] = 0,
				["UniqueID"] = "1590370554",
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
	pos = Vector(98.616066 1.792942 -0.307430),
	ang = Angle(-0.333 181.065 0.000),
	fov = 0.90251118195476,
}