
RECIPE.name = "Zipties"
RECIPE.description = "Some cable zipties"
RECIPE.model = "models/items/crossbowrounds.mdl"
RECIPE.category = "Assembly"
RECIPE.requirements = {
	["chunk_of_plastic"] = 1,
	["cable"] = 1
}

RECIPE.results = {
	["zip_tie"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
