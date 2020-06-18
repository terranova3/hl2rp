CLASS.name = "Administrator"
CLASS.faction = FACTION_ADMIN
CLASS.color = Color(255, 200, 100, 255)
CLASS.isDefault = true

function CLASS:CanSwitchTo(client)
	return false
end

CLASS_ADM = CLASS.index