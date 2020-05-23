--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

function PLUGIN:LoadFonts(font, genericFont)
    surface.CreateFont("ixMenuMediumFont", {
		font = "Roboto",
		size = math.max(ScreenScale(12)),
		weight = 300,
	})

	surface.CreateFont("ixMenuBigFont", {
		font = "Roboto",
		size = math.max(ScreenScale(30)),
		weight = 300,
	})

	surface.CreateFont("nutTitleFont", {
		font = "Segoe UI",
		size = ScreenScale(30),
		extended = true,
		weight = 300
	})

	surface.CreateFont("nutTitleSmall", {
		font = "Segoe UI",
		size = ScreenScale(12),
		extended = true,
		weight = 100
    })
    
    surface.CreateFont("ixFactionFont", {
		font = font,
		size = math.max(ScreenScale(8), 32),
		extended = true,
		weight = 1000
    })
    
    surface.CreateFont("ixMediumLightFontSmaller", {
		font = font,
		size = 18,
		extended = true,
		weight = 200
	})
end;