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
ix.anim.SetModelClass("models/overwatch/terranova/overwatchkillcapturesuppressor.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchsuppressorregular.mdl", "overwatch");

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
ix.anim:AddCombineHands("overwatchkillcapturesuppressor.mdl");
ix.anim:AddCombineHands("overwatchsuppressorregular.mdl");

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
		name = "BLADEWALL - REGULAR VARIANT",
		description = "Experimental light-weight armor used for area control.",
		model = "models/overwatch/terranova/overwatchsuppressorregular.mdl"
	},
	[5] = {
		name = "HAMMER",
		description = "Extremely durable armour protective system design for locking down urban environments.",
		model = "models/overwatch/terranova/overwatchgamma.mdl"
	},
	[6] = {
		name = "Antibody - ORDINAL",
		description = "Basic uniform which provides protection from gas, but not ballistics.",
		model = "models/overwatch/terranova/overwatchantibodycaptain.mdl"
	},
	[7] = {
		name = "Antibody - DAGGER",
		description = "Little to no armour, useful exclusively for xen removal.",
		model = "models/overwatch/terranova/overwatchantibodyepsilon.mdl"
	},
	[8] = {
		name = "SCALPEL",
		description = "Standard overwatch ballistic protection covered with a ghillie suit.",
		model = "models/overwatch/terranova/overwatchscalpel.mdl"
	},
	[9] = {
		name = "NOMAD",
		description = "Equipped with standard overwatch ballistic protection with goggles.",
		model = "models/overwatch/terranova/overwatchnomad.mdl"
	},
	[10] = {
		name = "SWORD",
		description = "Elite honor guards donning a white uniform to represent their status.",
		model = "models/overwatch/terranova/overwatchking.mdl"
	},
	[11] = {
		name = "PROSPEKT",
		description = "Prison guards with little external protection aside from a chest-situated kevlar.",
		model = "models/overwatch/terranova/overwatchprospekt.mdl"
	},
	[12] = {
		name = "vortkilllead",
		description = "A suit befit for anti-Xenian activities. Its resistance to Vortessence based abilities and shock is astounding, but it sarcifices ballistic protection in exchange. This one comes with compatibility for a standard Ordinal radiopack, and metal pauldrons.",
		model = "models/overwatch/terranova/overwatchvortcaptureunitlead.mdl"
	},
	[13] = {
		name = "vortkillregular",
		description = "A suit befit for anti-Xenian activities. Its resistance to Vortessence based abilities and shock is astounding, but it sarcifices ballistic protection in exchange.",
		model = "models/overwatch/terranova/overwatchvortcaptureunitregular.mdl"
	},
	[14] = {
		name = "vortkillsuppressor",
		description = "Experimental light-weight armor used for area control. Underlay suit made out of a material for resistance to Vortessence based abilities and shock.",
		model = "models/overwatch/terranova/overwatchkillcapturesuppressor.mdl"
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