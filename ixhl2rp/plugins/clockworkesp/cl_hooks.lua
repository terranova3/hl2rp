--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

timer.Destroy("HintSystem_OpeningMenu");
timer.Destroy("HintSystem_Annoy1");
timer.Destroy("HintSystem_Annoy2");

ix.option.Add("observerESP", ix.type.bool, true, {
    category = "Admin Settings",
    hidden = function()
        return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Observer", nil)
    end
})

ix.option.Add("observerShowItemESP", ix.type.bool, true, {
    category = "Admin Settings",
    hidden = function()
        return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Observer", nil)
    end
})

ix.option.Add("observerShowVendor", ix.type.bool, true, {
    category = "Admin Settings",
    hidden = function()
        return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Observer", nil)
    end
})

ix.option.Add("observerHideLiterature", ix.type.bool, true, {
    category = "Admin Settings",
    hidden = function()
        return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Observer", nil)
    end
})

function PLUGIN:HUDPaint()
    local client = LocalPlayer()

    if (ix.option.Get("observerESP", true) and client:GetMoveType() == MOVETYPE_NOCLIP and
        !client:InVehicle() and CAMI.PlayerHasAccess(client, "Helix - Observer", nil)) then

        PLUGIN.esp:DrawAdminESP()
    end
end