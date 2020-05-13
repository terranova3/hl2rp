--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

hook.Add("LoadFonts", "NewNotification", function()
    surface.CreateFont("NotifFont1", {
        font = "Courier New",
        size = 30,
        antialias = true,
        weight = 700
    })
    surface.CreateFont("NotifFont2", {
        font = "Courier New",
        size = 18,
        antialias = true,
        weight = 400
    })
end)