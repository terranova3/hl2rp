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
PLUGIN.config.otaTypes = {
	[1] = {
		name = "[PH] Overwatch Type 1",
		description = "[PH] Needs description",
		model = "models/overwatch/terranova/overwatchepsilon.mdl"
	},
	[2] = {
		name = "[PH] Overwatch Type 2",
		description = "[PH] Needs description",
		model = "models/overwatch/terranova/overwatchscalpel.mdl"
	},
	[3] = {
		name = "[PH] Overwatch Type 3",
		description = "[PH] Needs description",
		model = "models/overwatch/terranova/overwatchnomad.mdl"
	},
	[4] = {
		name = "[PH] Overwatch Type 4",
		description = "[PH] Needs description",
		model = "models/overwatch/terranova/overwatchdelta.mdl"
	},
	[5] = {
		name = "[PH] Overwatch Type 5",
		description = "[PH] Needs description",
		model = "models/overwatch/terranova/overwatchalpha.mdl"
	},
	[6] = {
		name = "[PH] Overwatch Type 6",
		description = "[PH] Needs description",
		model = "models/overwatch/terranova/overwatchking.mdl"
	},
	[7] = {
		name = "[PH] Overwatch Type 7",
		description = "[PH] Needs description",
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