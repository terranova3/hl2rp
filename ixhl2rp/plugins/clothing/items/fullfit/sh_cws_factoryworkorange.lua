--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

ITEM.base = "base_fullfit";
ITEM.name = "Civil Factory Uniform Orange";
ITEM.category = "Clothing";
ITEM.description = "A complete uniform kit that includes a gas mask, air canister, polyester jacket, steel toed jack boots,hard cut resistant ballistic gloves and more.";
ITEM.maxArmor = 5;
ITEM.gasImmunity = true
ITEM.replacements = "models/hlvr/characters/worker/npc/worker_citizen.mdl"
ITEM.bodyGroups = {
	["skin"] = 1,
	["uniform variant"] = 1
}