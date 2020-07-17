--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

ITEM.name = "Civil Protection Uniform";
ITEM.base = "base_cp_uniform"
ITEM.category = "Clothing";
ITEM.description = "A complete uniform kit that includes a vulcanized rubber flak jacket, polyester metropolice slacks, kevlar vest, steel toed jackboots, rubber gloves and more.";
ITEM.maxArmor = 100;

function ITEM:OnGetReplacement()
	local client = self:GetOwner()
	local model = client:GetModel()
	local newModel = "models/ma/hla/terranovapolice.mdl"

	if(string.find(model, "female")) then
		return "models/ma/hla/terranovafemalepolice.mdl"
	end

	return newModel
end 