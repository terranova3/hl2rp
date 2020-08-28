CLASS.name = "Administration"
CLASS.faction = FACTION_ADMIN
CLASS.color = Color(255, 200, 100, 255)
CLASS.isDefault = true
CLASS.order = 1

function CLASS:CanSwitchTo(client)
	return false
end

CLASS_ADM = CLASS.index