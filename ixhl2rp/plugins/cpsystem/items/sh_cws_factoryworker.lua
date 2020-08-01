--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

ITEM.name = "Civil Factory Uniform";
ITEM.base = "base_cp_uniform"
ITEM.category = "Clothing";
ITEM.description = "A complete uniform kit that includes a gas mask, air canister, polyester jacket, steel toed jack boots,hard cut resistant ballistic gloves and more.";
ITEM.maxArmor = 5;

function ITEM:OnGetReplacement()
	local client = self:GetOwner()
	local model = client:GetModel()
	local newModel = "models/hlvr/characters/worker/npc/worker_citizen.mdl"

	return newModel
end 