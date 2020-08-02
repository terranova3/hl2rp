--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

CLASS.name = "Enslaved Vortigaunt"
CLASS.color = Color(0, 255, 200, 255)
CLASS.faction = FACTION_BIOTIC
CLASS.isDefault = true

function CLASS:CanSwitchTo(client)
	return false
end

CLASS_BIOTICSLAVE = CLASS.index