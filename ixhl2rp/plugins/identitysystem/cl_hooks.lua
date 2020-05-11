
local PLUGIN = PLUGIN;

netstream.Hook("OpenCIDMenu", function(data)
    vgui.Create("ixCIDCreater")
end)

netstream.Hook("LoyaltyOpen", function(data)
    local ui = vgui.Create("ixLoyalty")
    ui.ent = data[1]
end)