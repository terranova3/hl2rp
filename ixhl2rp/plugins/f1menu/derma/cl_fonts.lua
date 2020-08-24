--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local font = "Futura Std Medium"

-- Character Background

surface.CreateFont("ixInfoPanelFont", {
    font = font,
    weight = 200,
    size = ScreenScale(8),
    additive = true,
})

surface.CreateFont("ixInfoPanelTitleFont", {
    font = font,
    weight = 200,
    size = 28,
    additive = true
})

surface.CreateFont("ixInfoPanelTimeFont", {
    font = font,
    weight = 200,
    size = 32,
    additive = true
})

