--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ITEM.name = "Civil Protection Uniform";
ITEM.base = "base_cp_uniform"
ITEM.category = "Clothing";
ITEM.description = "A complete uniform kit that includes a vulcanized rubber flak jacket, polyester metropolice slacks, kevlar vest, steel toed jackboots, rubber gloves and more.";
ITEM.maxArmor = 100;

function ITEM:OnGetReplacement()
	local newModel = "models/ma/hla/terranovapolice.mdl"

	return newModel
end 