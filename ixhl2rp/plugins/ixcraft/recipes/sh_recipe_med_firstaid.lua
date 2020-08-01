
RECIPE.name = "Improvise First aidkit"
RECIPE.description = "Assemble various medical resources into a kit for emergency situations."
RECIPE.model = "models/firstaid/item_firstaid.mdl"
RECIPE.category = "Medicinal"
RECIPE.requirements = {
	["cloth_bandage"] = 2,
	["medigel"] = 1,
	["painkillers"] = 1
}
RECIPE.results = {
	["first_aidkit"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
