--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

-- [[ Civil Protection Name Setup ]] --
cpSystem.config.CityAbbreviation = "C45";

-- < values: city, abbreviation, rank, id, division > --
cpSystem.config.cpName = "city.abbreviation:rank-id";

-- [[ Miscellaneous Settings ]] --
cpSystem.config.DisableClassMenu = true;
cpSystem.config.IncognitoCPScoreboard = true;

-- [[ Rank Setup ]] --

-- Rank Access < id | class name | abbreviation > --
Schema.ranks.access.Add(2, "Universal Union", "UU");
Schema.ranks.access.Add(1, "Civil Protection", "CPF");
Schema.ranks.access.Add(0, "Civil Protection", "CPF");

-- Rank <faction | rank tag | rank access> --
Schema.ranks.Add("CmD", 2);
Schema.ranks.Add("OfC", 1);
Schema.ranks.Add("i1", 0);
Schema.ranks.Add("i2", 0);
Schema.ranks.Add("i3", 0);
Schema.ranks.Add("i4", 0);
Schema.ranks.Add("i5", 0);
