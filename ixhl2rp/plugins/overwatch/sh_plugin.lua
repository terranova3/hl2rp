--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Overwatch";
PLUGIN.description = "Replaces the old overwatch and adds ranks and automatic naming.";
PLUGIN.author = "Adolphus";

ix.anim.SetModelClass("models/cultist/hl_a/vannila_combine/npc/combine_soldier.mdl", "overwatch");
ix.anim.SetModelClass("models/hlvr/characters/worker/npc/worker_combine.mdl", "overwatch");
ix.anim.SetModelClass("models/hlvr/characters/hazmat_worker/npc/hazmat_worker_combine.mdl", "overwatch");
ix.anim.SetModelClass("models/characters/combine_soldier/jqblk/combine_s_super.mdl", "overwatch");
ix.anim.SetModelClass("models/cultist/hl_a/combine_pilot.mdl", "overwatch");
ix.anim.SetModelClass("models/cultist/hl_a/combine_commander/npc/combine_commander.mdl", "overwatch");
ix.anim.SetModelClass("models/cultist/hl_a/combine_grunt/combine_grunthazmatlead.mdl", "overwatch");
ix.anim.SetModelClass("models/cultist/hl_a/combine_grunt/combine_grunthazmatregular.mdl", "overwatch");
ix.anim.SetModelClass("models/cultist/hl_a/combine_heavy/combine_heavy_trooper.mdl", "overwatch");
ix.anim.SetModelClass("models/cultist/hl_a/combine_suppresor/combine_suppresorterranova.mdl", "overwatch");
ix.anim.SetModelClass("models/cultist/hl_a/combine_grunt/combine_grunthazmatlead.mdl", "overwatch");
ix.anim.SetModelClass("models/cultist/hl_a/combine_grunt/combine_grunthazmatregular.mdl", "overwatch");
ix.anim.SetModelClass("models/combine_sniper.mdl", "overwatch");
ix.anim.SetModelClass("models/combine_sniper_2.mdl", "overwatch");

ix.anim:AddCombineHands("combine_soldier.mdl");
ix.anim:AddCombineHands("worker_combine.mdl");
ix.anim:AddCombineHands("hazmat_worker_combine.mdl");
ix.anim:AddCombineHands("combine_s_super.mdl");
ix.anim:AddCombineHands("combine_pilot.mdl");
ix.anim:AddCombineHands("combine_commander.mdl");
ix.anim:AddCombineHands("combine_grunthazmatlead.mdl");
ix.anim:AddCombineHands("combine_grunthazmatregular.mdl");
ix.anim:AddCombineHands("combine_heavy_trooper.mdl");
ix.anim:AddCombineHands("combine_suppresorterranova.mdl");
ix.anim:AddCombineHands("combine_grunthazmatlead.mdl");
ix.anim:AddCombineHands("combine_grunthazmatregular.mdl");
ix.anim:AddCombineHands("combine_sniper.mdl");
ix.anim:AddCombineHands("combine_sniper_2.mdl");