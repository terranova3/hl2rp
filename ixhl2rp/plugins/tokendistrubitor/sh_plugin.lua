--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

PLUGIN.name = "Token Distributor";
PLUGIN.description = "Distribute tokens to the CWU members so that they can reward workers.";
PLUGIN.author = "theHandgun";

ix.util.Include("sv_hooks.lua");
ix.util.Include("cl_hooks.lua");


PLUGIN.Paygrades = {}
table.insert(PLUGIN.Paygrades, {"Level 1 (10 Tokens)", 10})
table.insert(PLUGIN.Paygrades, {"Level 2 (15 Tokens)", 15})
table.insert(PLUGIN.Paygrades, {"Level 3 (20 Tokens)", 20})
table.insert(PLUGIN.Paygrades, {"Level 4 (25 Tokens)", 25})
table.insert(PLUGIN.Paygrades, {"Level 5 (30 Tokens)", 30})


PLUGIN.MaxWorkerCount = 10
PLUGIN.UseCooldown = 3600 --in seconds
