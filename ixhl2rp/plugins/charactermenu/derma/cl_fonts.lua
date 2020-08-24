--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local font = "Futura Std Medium"
local fontTight = "Futura Std Condensed"

-- Character Background

surface.CreateFont("ixPluginCharBackgroundTitleFont", {
    font = fontTight,
    weight = 200,
    size = ScreenScale(16),
    additive = true,
})

surface.CreateFont("ixPluginCharBackgroundFont", {
    font = fontTight,
    weight = 200,
    size = ScreenScale(8),
    additive = true
})

-- Other

surface.CreateFont("ixPluginIntroTitleFont", {
    font = font,
    size = math.min(ScreenScale(128), 128),
    extended = true,
    weight = 100
})

surface.CreateFont("ixPluginIntroSubtitleFont", {
    font = font,
    size = ScreenScale(24),
    extended = true,
    weight = 100
})

surface.CreateFont("ixPluginIntroSmallFont", {
    font = font,
    size = ScreenScale(14),
    extended = true,
    weight = 100
})

surface.CreateFont("ixPluginCharTitleFont", {
    font = font,
    weight = 200,
    size = ScreenScale(25),
    additive = true
})
surface.CreateFont("ixPluginCharDescFont", {
    font = font,
    weight = 200,
    size = ScreenScale(12),
    additive = true
})
surface.CreateFont("ixPluginCharDescMiniFont", {
    font = font,
    weight = 200,
    size = ScreenScale(6),
    additive = true
})
surface.CreateFont("ixPluginCharSubTitleFont", {
    font = font,
    weight = 200,
    size = ScreenScale(6),
    additive = true
})
surface.CreateFont("ixPluginCharTraitFont", {
    font = font,
    weight = 200,
    size = ScreenScale(5),
    additive = true
})
surface.CreateFont("ixPluginCharButtonFont", {
    font = font,
    weight = 200,
    size = ScreenScale(12),
    additive = true
})
surface.CreateFont("ixPluginCharButtonSubFont", {
    font = font,
    weight = 200,
    size = ScreenScale(8),
    additive = true
})
surface.CreateFont("ixPluginCharSmallButtonFont", {
    font = font,
    weight = 200,
    size = ScreenScale(11),
    additive = true
})
surface.CreateFont("ixPluginCharPanelTitleFont", {
    font = font,
    weight = 200,
    size = ScreenScale(9),
    additive = true
})
surface.CreateFont("ixPluginCharPanelSubTitleFont", {
    font = font,
    weight = 200,
    size = ScreenScale(5),
    additive = true
})
surface.CreateFont("ixPluginCharComboBoxFont", {
    font = font,
    weight = 200,
    size = ScreenScale(7),
    additive = true
})

surface.CreateFont("ixPluginTooltipFont", {
    font = font,
    size = ScreenScale(8),
    extended = true,
    weight = 500
})

surface.CreateFont("ixPluginTooltipDescFont", {
    font = font,
    size = ScreenScale(6),
    extended = true,
    weight = 500
})

surface.CreateFont("ixPluginTooltipSmallFont", {
    font = font,
    size = ScreenScale(5),
    italic = true,
    extended = true,
    weight = 500
})


font = "Futura Std Light"

surface.CreateFont("ixPluginMenuButtonFont", {
    font = font,
    size = ScreenScale(14),
    extended = true,
    weight = 25
})

surface.CreateFont("ixPluginMenuButtonFontSmall", {
    font = font,
    size = ScreenScale(10),
    extended = true,
    weight = 100
})

surface.CreateFont("ixPluginMenuButtonFontThick", {
    font = font,
    size = ScreenScale(14),
    extended = true,
    weight = 300
})
