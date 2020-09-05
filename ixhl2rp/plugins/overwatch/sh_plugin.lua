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
PLUGIN.config.otaTypes = {
	[1] = {
		name = "SCOT-M",
		description = "Standard Overwatch armor, providing basic ballistic protection.",
		voiceType = "HLA",
		model = "models/overwatch/terranova/overwatchepsilon.mdl"
	},
	[2] = {
		name = "SCOT-O",
		description = "Standard Overwatch armor with an improved ballistic protection system and communications systems.",
		voiceType = "Ordinal",
		model = "models/overwatch/terranova/overwatchalpha.mdl"
	},
	[3] = {
		name = "SUPPRESSOR",
		description = "Experimental light-weight armor used for maneuverability during area control.",
		voiceType = "Suppressor",
		model = "models/overwatch/terranova/overwatchdelta.mdl"
	},
	[4] = {
		name = "SRAT-S",
		description = "Experimental light-weight armor used for maneuverability during area control.",
		voiceType = "Suppressor",
		model = "models/overwatch/terranova/overwatchsuppressorregular.mdl"
	},
	[5] = {
		name = "HAMMER",
		description = "Extremely durable armour protective system, designed for locking down urban and close-quarters environments.",
		voiceType = "Charger",
		model = "models/overwatch/terranova/overwatchgamma.mdl"
	},
	[6] = {
		name = "SRAT-O",
		description = "Stripped down Overwatch kit with lesser ballistic protection, but a dedicated breathing apparatus and gas tank.",
		voiceType = "Ordinal",
		model = "models/overwatch/terranova/overwatchantibodycaptain.mdl"
	},
	[7] = {
		name = "SRAT-M",
		description = "Stripped down Overwatch kit with lesser ballistic protection, but a dedicated breathing apparatus and gas tank.",
		voiceType = "HLA",
		model = "models/overwatch/terranova/overwatchantibodyepsilon.mdl"
	},
	[8] = {
		name = "SCALPEL",
		description = "Standard Overwatch armor with ghillie covering.",
		voiceType = "Suppressor",
		model = "models/overwatch/terranova/overwatchscalpel.mdl"
	},
	[9] = {
		name = "AIRWATCH",
		description = "Standard Overwatch armor, modified for usage by Transhumanized pilots.",
		voiceType = "Suppressor",
		model = "models/overwatch/terranova/overwatchnomad.mdl"
	},
	[10] = {
		name = "SRET",
		description = "The finest the Transhuman Arm has to offer. Advanced ballistics systems, improved optics systems and fierce tactics.",
		voiceType = "Ordinal",
		model = "models/overwatch/terranova/overwatchking.mdl"
	},
	[11] = {
		name = "SDOT",
		description = "Detention processing team, equipped with ballistic protection and additional protection from stabbing and blunt trauma.",
		voiceType = "HLA",
		model = "models/overwatch/terranova/overwatchprospekt.mdl"
	},
	[12] = {
		name = "SRBCT-O",
		description = "A suit rigged for anti-Biotic activities. Less ballistic protection, but more resistance towards Biotic energy attacks.",
		voiceType = "Ordinal",
		model = "models/overwatch/terranova/overwatchvortcaptureunitlead.mdl"
	},
	[13] = {
		name = "SRBCT-M",
		description = "A suit rigged for anti-Biotic activities. Less ballistic protection, but more resistance towards Biotic energy attacks.",
		voiceType = "HLA",
		model = "models/overwatch/terranova/overwatchvortcaptureunitregular.mdl"
	},
	[14] = {
		name = "SRBCT-S",
		description = "Experimental light-weight armor used for maneuverability during area control. Less ballistic protection, but more resistance towards Biotic energy attacks.",
		voiceType = "Suppressor",
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