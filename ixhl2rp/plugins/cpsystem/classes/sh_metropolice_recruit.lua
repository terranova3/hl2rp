CLASS.name = "Metropolice Recruit"
CLASS.faction = FACTION_MPF

function CLASS:CanSwitchTo(client)
	return Schema:IsCombineRank(client:Name(), "RCT")
end

CLASS_MPR = CLASS.index