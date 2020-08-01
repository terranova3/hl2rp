--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

ITEM.name = "Civil Restoration Uniform";
ITEM.base = "base_cp_uniform"
ITEM.category = "Clothing";
ITEM.description = "A complete uniform kit that includes a vulcanized rubber jacket, contamination suit, air canister,gas mask, steel toed jackboots, rubber gloves and more.";
ITEM.maxArmor = 25;

function ITEM:OnGetReplacement()
	local client = self:GetOwner()
	local model = client:GetModel()
	local newModel = "models/hlvr/characters/hazmat_worker/npc/hazmat_worker_citizen.mdl"
	return newModel
end 