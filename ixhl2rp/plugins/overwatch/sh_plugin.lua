--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Overwatch";
PLUGIN.description = "Replaces the old overwatch and adds ranks and automatic naming.";
PLUGIN.author = "Adolphus";

ix.anim.SetModelClass("models/overwatch/terranova/overwatchantibodyepsilon.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchantibodycaptain.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchnomad.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchscalpel.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchepsilon.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchgamma.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchdelta.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchalpha.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchking.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchprospekt.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchvortcaptureunitlead.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchvortcaptureunitregular.mdl", "overwatch");

ix.anim:AddCombineHands("overwatchepsilon.mdl");
ix.anim:AddCombineHands("overwatchgamma.mdl");
ix.anim:AddCombineHands("overwatchdelta.mdl");
ix.anim:AddCombineHands("overwatchalpha.mdl");
ix.anim:AddCombineHands("overwatchantibodyepsilon.mdl");
ix.anim:AddCombineHands("overwatchantibodycaptain.mdl");
ix.anim:AddCombineHands("overwatchnomad.mdl");
ix.anim:AddCombineHands("overwatchscalpel.mdl");
ix.anim:AddCombineHands("overwatchking.mdl");
ix.anim:AddCombineHands("overwatchprospekt.mdl");
ix.anim:AddCombineHands("overwatchvortcaptureunitlead.mdl");
ix.anim:AddCombineHands("overwatchvortcaptureunitregular.mdl");

local PLUGIN = PLUGIN
PLUGIN.config = {}
PLUGIN.config.abbreviation = "OTA"
PLUGIN.config.defaultDivision = "EPISLON"
PLUGIN.config.namingScheme = "abbreviation:rank.division-id"
PLUGIN.config.otaTypes = {
	[1] = {
		name = "DAGGER",
		description = "Standard armor with basic ballistic protection.",
		model = "models/overwatch/terranova/overwatchepsilon.mdl"
	},
	[2] = {
		name = "ORDINAL",
		description = "Standard armor with an improved ballistic protection system.",
		model = "models/overwatch/terranova/overwatchalpha.mdl"
	},
	[3] = {
		name = "BLADEWALL",
		description = "Experimental light-weight armor used for area control.",
		model = "models/overwatch/terranova/overwatchdelta.mdl"
	},
	[4] = {
		name = "HAMMER",
		description = "Extremely durable armour protective system design for locking down urban environments.",
		model = "models/overwatch/terranova/overwatchgamma.mdl"
	},
	[5] = {
		name = "Antibody - ORDINAL",
		description = "Basic uniform which provides protection from gas, but not ballistics.",
		model = "models/overwatch/terranova/overwatchantibodycaptain.mdl"
	},
	[6] = {
		name = "Antibody - DAGGER",
		description = "Little to no armour, useful exclusively for xen removal.",
		model = "models/overwatch/terranova/overwatchantibodyepsilon.mdl"
	},
	[7] = {
		name = "SCALPEL",
		description = "Standard overwatch ballistic protection covered with a ghillie suit.",
		model = "models/overwatch/terranova/overwatchscalpel.mdl"
	},
	[8] = {
		name = "NOMAD",
		description = "Equipped with standard overwatch ballistic protection with goggles.",
		model = "models/overwatch/terranova/overwatchnomad.mdl"
	},
	[9] = {
		name = "SWORD",
		description = "Elite honor guards donning a white uniform to represent their status.",
		model = "models/overwatch/terranova/overwatchking.mdl"
	},
	[10] = {
		name = "PROSPEKT",
		description = "Prison guards with little external protection aside from a chest-situated kevlar.",
		model = "models/overwatch/terranova/overwatchprospekt.mdl"
	},
}
PLUGIN.config.voiceTypes = {
	"Legacy",
	"HLA",
	"Ordinal",
	"Suppressor",
	"Charger"
}

ix.util.Include("sv_hooks.lua")
ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)
ix.util.IncludeDir(PLUGIN.folder .. "/meta", true)