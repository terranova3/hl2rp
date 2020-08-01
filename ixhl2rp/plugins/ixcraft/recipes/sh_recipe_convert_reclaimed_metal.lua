
RECIPE.name = "Scrap Metal"
RECIPE.description = "Break down Reclaimed Metal into Scrap Metal."
RECIPE.model = "models/props_c17/oildrumchunk01d.mdl"
RECIPE.category = "Convert"
RECIPE.requirements = {
	["reclaimed_metal"] = 1
}
RECIPE.results = {
	["scrap_metal"] = 2
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)