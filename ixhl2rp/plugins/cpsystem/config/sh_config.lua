--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

-- [[ Civil Protection Name Setup ]] --
cpSystem.config.UniversalUnionAbbreviation = "UU."
cpSystem.config.CityAbbreviation = "C45";

cpSystem.config.CitytoCPAbbreviationConnector = ".";
cpSystem.config.CPAbbreviation = "CPF";
cpSystem.config.CPAbbreviationtoRankConnector = ":";
cpSystem.config.RanktoIDConnector = ".";

-- [[ Miscellaneous Settings ]] --
cpSystem.config.DisableClassMenu = true;
cpSystem.config.IncognitoCPScoreboard = true;

-- [[ Rank Setup ]] --

-- Rank Access <id | class name | abbreviation> --
Schema.ranks.access.Add("2", "Universal Union", "UU");
Schema.ranks.access.Add("1", "Civil Protection", "CPF");
Schema.ranks.access.Add("0", "Civil Protection", "CPF");

-- Rank <faction | rank tag | rank access> --
Schema.ranks.Add("Metropolice Force", "CmD", "2");
Schema.ranks.Add("Metropolice Force", "OfC", "1");
Schema.ranks.Add("Metropolice Force", "i1", "0");
Schema.ranks.Add("Metropolice Force", "i2", "0");
Schema.ranks.Add("Metropolice Force", "i3", "0");
Schema.ranks.Add("Metropolice Force", "i4", "0");
Schema.ranks.Add("Metropolice Force", "i5", "0");

Schema.ranks.AddRankList("Metropolice Force", function(client)
	return client:IsMetropolice();
end)