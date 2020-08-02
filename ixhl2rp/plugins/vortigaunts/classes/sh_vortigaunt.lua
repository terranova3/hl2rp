--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

CLASS.name = "Vortigaunt"
CLASS.color = Color(0, 255, 0, 255);
CLASS.faction = FACTION_VORT
CLASS.isDefault = true

function CLASS:CanSwitchTo(client)
	return false
end

CLASS_VORT = CLASS.index