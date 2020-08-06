--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of the author.
    
    Example item
--]]

local PLUGIN = PLUGIN;

ITEM.name = "SSh-68";
ITEM.model = "models/sovietarmy/props/helmet.mdl";
ITEM.price = 50;
ITEM.description = "An old relic of the Soviet military bloc, it offers ample protection.";
ITEM.flag = "G";

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
						["UniqueID"] = "1291465892",
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
						["Position"] = Vector(5.32421875, -0.9583740234375, 0.0094451904296875),
						["AngleOffset"] = Angle(0, 0, 0),
						["AlternativeScaling"] = false,
						["Hide"] = false,
						["OwnerEntity"] = false,
						["Scale"] = Vector(1, 1, 1),
						["ClassName"] = "model",
						["EditorExpand"] = false,
						["Size"] = 1.05,
						["ModelFallback"] = "",
						["Angles"] = Angle(89.999992370605, 13.787664413452, 0),
						["TextureFilter"] = 3,
						["Model"] = "models/sovietarmy/props/helmet.mdl",
						["BlendMode"] = "",
					},
				},
			},
			["self"] = {
				["DrawOrder"] = 0,
				["UniqueID"] = "3627640526",
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
						["UniqueID"] = "1291465892",
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
						["Position"] = Vector(4.251953125, -1.13525390625, 0.00012779235839844),
						["AngleOffset"] = Angle(0, 0, 0),
						["AlternativeScaling"] = false,
						["Hide"] = false,
						["OwnerEntity"] = false,
						["Scale"] = Vector(1, 1, 1),
						["ClassName"] = "model",
						["EditorExpand"] = false,
						["Size"] = 1,
						["ModelFallback"] = "",
						["Angles"] = Angle(89.999992370605, 13.787664413452, 0),
						["TextureFilter"] = 3,
						["Model"] = "models/sovietarmy/props/helmet.mdl",
						["BlendMode"] = "",
					},
				},
				[2] = {
					["children"] = {
					},
					["self"] = {
						["ModelIndex"] = 2,
						["UniqueID"] = "3206813289",
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
				["UniqueID"] = "3627640526",
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
	pos = Vector(-684.966064 -665.432312 300.491028),
	ang = Angle(17.467 44.171 0.000),
	fov = 1.9673997408365,
}