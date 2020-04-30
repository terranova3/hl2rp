--[[
	© 2020 TERRANOVA Civil Protection System
	Configuration file
--]]

-- [[ Config settings ]] --
cpSystem.config.cpDefaultDescription = "This is the default description for CPs, set it in the config file.";

-- [[ Rank Setup ]] --

-- Rank Access < id | class name | abbreviation > --
Schema.ranks.access.Add(2, "Universal Union", "UU");
Schema.ranks.access.Add(1, "Civil Protection", "CPF");
Schema.ranks.access.Add(0, "Civil Protection", "CPF");

-- Rank <rank tag | rank access level> --
Schema.ranks.Add("A", 2);
Schema.ranks.Add("E", 1);
Schema.ranks.Add("Z", 0);
Schema.ranks.Add("G", 0);
Schema.ranks.Add("D", 0);

-- [[ CP Taglines ]] --

cpSystem.config.taglines = {
	"APEX",
	"BLADE",
	"DAGGER",
	"DASH",
	"DEFENDER",
	"ECHO",
	"FIST",
	"GHOST",
	"GRID",
	"HAMMER",
	"HELIX",
	"HERO",
	"HUNTER",
	"HURRICANE",
	"ICE",
	"ION",
	"JET",
	"JUDGE",
	"JURY",
	"KILO",
	"KING",
	"LINE",
	"LOCK",
	"MACE",
	"NOMAD",
	"NOVA",
	"PHANTOM",
	"QUICKSAND",
	"RANGER",
	"RAZOR",
	"REAPER",
	"SAVAGE",
	"SCAR",
	"SHADOW",
	"SLASH",
	"SPEAR",
	"STAB",
	"STAR",
	"STINGER",
	"STORM",
	"STRIKE",
	"SUNDOWN",
	"SWIFT",
	"SWORD",
	"UNIFORM",
	"UNION",
	"VAMP",
	"VICE",
	"VICTOR",
	"WINDER",
	"XRAY",
	"YELLOW",
	"ZONE"
}
