--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ITEM.name = "Civil Protection Adjutant Uniform";
ITEM.base = "base_cp_uniform"
ITEM.category = "Clothing";
ITEM.description = "A complete uniform kit that includes a vulcanized rubber flak jacket, polyester metropolice slacks, kevlar vest, steel toed jackboots, rubber gloves and more.";
ITEM.maxArmor = 100;

function ITEM:OnGetReplacement()
	local client = self:GetOwner()
	local model = client:GetModel()
	local newModel

	if(string.find(model, "models/ug/new/citizens/")) then
		newModel = string.Replace(model, "models/ug/new/citizens/", "models/cmbofficers/")
		newModel = string.Replace(newModel, ".mdl", "_cmbofficer.mdl")

		return newModel
	end

	return model
end 