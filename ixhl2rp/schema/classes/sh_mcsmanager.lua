CLASS.name = "Civil Services Manager"
CLASS.faction = FACTION_CITIZEN
CLASS.color = Color(150, 125, 100, 255)

function CLASS:CanSwitchTo(client)
	return false
end

CLASS_MM = CLASS.index