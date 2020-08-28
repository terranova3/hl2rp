--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Overwatch";
PLUGIN.description = "Replaces the old overwatch and adds ranks and automatic naming.";
PLUGIN.author = "Adolphus";

local PLUGIN = PLUGIN
PLUGIN.config = {}
PLUGIN.config.abbreviation = "OTA"
PLUGIN.config.defaultDivision = "EPISLON"
PLUGIN.config.namingScheme = "abbreviation:rank.division-id"
PLUGIN.config.voiceTypes = {
	"Legacy",
	"HLA",
	"Ordinal",
	"Suppressor",
	"Charger"
}

ix.util.IncludeDir(PLUGIN.folder .. "/commands", true)
ix.util.IncludeDir(PLUGIN.folder .. "/meta", true)

ix.anim.SetModelClass("models/overwatch/terranova/overwatchantibodyepsilon.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchantibodycaptain.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchnomad.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchscalpel.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchepsilon.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchgamma.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchdelta.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchalpha.mdl", "overwatch");
ix.anim.SetModelClass("models/overwatch/terranova/overwatchking.mdl", "overwatch");

ix.anim:AddCombineHands("overwatchepsilon.mdl");
ix.anim:AddCombineHands("overwatchgamma.mdl");
ix.anim:AddCombineHands("overwatchdelta.mdl");
ix.anim:AddCombineHands("overwatchalpha.mdl");
ix.anim:AddCombineHands("overwatchantibodyepsilon.mdl");
ix.anim:AddCombineHands("overwatchantibodycaptain.mdl");
ix.anim:AddCombineHands("overwatchnomad.mdl");
ix.anim:AddCombineHands("overwatchscalpel.mdl");
ix.anim:AddCombineHands("overwatchking.mdl");
