--[[
	© 2020 TERRANOVA Civil Protection System
	Configuration file
--]]

-- [[ Config settings ]] --
cpSystem.config.cpDefaultDescription = "This is the default description for CPs, set it in the config file.";
cpSystem.config.notification = {
	faction = "MPF", 
	title = "UNIT!", 
	sound = "sound/terranova/ui/notification_mpf.mp3",
	titleColor = Color(50, 100, 150)
}
cpSystem.config.voiceTypes = {
	"Legacy",
	"HLA"
}
cpSystem.config.taglines = {
	"APEX",
	"BLADE",
	"DASH",
	"DEFENDER",
	"GHOST",
	"GRID",
	"HELIX",
	"HUNTER",
	"HURRICANE",
	"ION",
	"JET",
	"JUDGE",
	"JURY",
	"MACE",
	"NOVA",
	"QUICKSAND",
	"RANGER",
	"RAZOR",
	"SAVAGE",
	"SPEAR",
	"SWIFT",
	"STINGER",
	"STORM",
	"SUNDOWN",
	"SWORD",
	"UNIFORM",
	"VAMP",
	"VICE",
	"VICTOR",
	"WINDER",
	"XRAY",
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

ix.config.Add("Scanner Naming Scheme", "city.abbreviation:rank-id", "Naming scheme for scanners. values: city, abbreviation, rank, tagline, id, division", nil, {
	category = "[TN] Civil Protection System"
})
