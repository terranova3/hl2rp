--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

function PLUGIN:BuildGamemasterMenu()
    if (CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Gamemaster", nil)) then
        return true
    end
end
