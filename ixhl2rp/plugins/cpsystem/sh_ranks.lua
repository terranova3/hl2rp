--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

Schema.ranks.Add("Metropolice Force", "CmD", "2")
Schema.ranks.Add("Metropolice Force", "OfC", "1")
Schema.ranks.Add("Metropolice Force", "i1", "0")
Schema.ranks.Add("Metropolice Force", "i2", "0")
Schema.ranks.Add("Metropolice Force", "i3", "0")
Schema.ranks.Add("Metropolice Force", "i4", "0")
Schema.ranks.Add("Metropolice Force", "i5", "0")

Schema.ranks.AddRankList("Metropolice Force", function(client)
	return client:IsMetropolice()
end)