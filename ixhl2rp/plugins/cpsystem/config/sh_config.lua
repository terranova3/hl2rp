--[[
	© 2020 TERRANOVA Civil Protection System
	Configuration file
--]]

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

-- [[ Config settings ]] --
cpSystem.config.cpDefaultDescription = "This is the default description for CPs, set it in the config file.";
cpSystem.config.cpDefaultRank = "D";
cpSystem.config.commandsAccess = {
	["set_cp_id"] = 2,
	["set_cp_rank"] = 2,
	["set_cp_tagline"] = 2,
	["get_cp_access_level"] = 0,
	["view_data"] = 0,
	["edit_viewobjectives"] = 2,
	["set_sociostatus"] = 0
}
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
cpSystem.config.displayMessages = {
	"Transmitting physical transition vector...",
	"Modulating external temperature levels...",
	"Parsing view ports and data arrays...",
	"Translating Union practicalities...",
	"Sending suit diagnostic data...",
	"Checking protection levels...",
	"Monitoring biosignal and reporting...",
	"Receiving standard directives...",
	"Getting patrol teams list...",
	"Syncing suit database to cloud...",
	"Maintaining ambient temperature in suit...",
	"Monitoring encrypted frequency channel...",
	"Updating biosignal co-ordinates...",
	"Parsing nexus protocol messages...",
	"Downloading recent dictionaries...",
	"Pinging connection to network...",
	"Updating mainframe connection...",
	"Synchronizing locational data...",
	"Translating radio messages...",
	"Emptying outgoing pipes...",
	"Sensoring proximity...",
	"Pinging loopback...",
	"Updating data connections...",
	"Looking up main protocols...",
	"Updating Translation Matrix...",
	"Establishing connection with overwatch...",
	"Opening up aura scanners...",
	"Establishing Clockwork protocols...",
	"Looking up active fireteam control centers...",
	"Command uplink established...",
	"Inititaing self-maintenance scan...",
	"Scanning for active biosignals...",
	"Updating cid registry link...",
	"Establishing variables for connection hooks...",
	"Creating socket for incoming connection...",
	"Initializing squad uplink interface...",
	"Updating squad statuses...",
	"Looking up front end codebase changes...",
	"Software status nominal...",
	"Querying database for new recruits... RESPONSE: OK",
	"Establishing connection to long term maintenance procedures...",
	"Looking up CP-5 Main...",
	"Updating railroad activity monitors...",
	"Caching new response protocols..."
}

-- [[ Ingame config ]] --
-- [[ You can access these ingame, and is recommended you change their data ingame instead. ]] --
ix.config.Add("City Name", "C17", "The abbreviation used for the 'city' value in Civil Protection System.", nil, {
	category = "[TN] Civil Protection System"
})

ix.config.Add("Abbreviation", "CPF", "The text abbreviation used for the 'abbreviation' value in the Civil Protection System.", nil, {
	category = "[TN] Civil Protection System"
})

ix.config.Add("Naming Scheme", "city.abbreviation:rank.tagline-id", "Naming scheme for civil protection units. values: city, abbreviation, rank, tagline, id, division", nil, {
	category = "[TN] Civil Protection System"
})

ix.config.Add("Dispatch Access Level", 1, "The access level that can access dispatch commands. Access level is tied to ranks in the server file config.", nil, {
	data = {min = 0, max = Schema.ranks.access.GetSize()},
	category = "[TN] Civil Protection System"
})
