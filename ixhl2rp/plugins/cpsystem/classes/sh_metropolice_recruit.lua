CLASS.name = "Metropolice Recruit"
CLASS.faction = FACTION_MPF
CLASS.color = Color(50, 100, 150)

function CLASS:CanSwitchTo(client)
	return Schema:IsCombineRank(client:Name(), "RCT")
end

CLASS_MPR = CLASS.index