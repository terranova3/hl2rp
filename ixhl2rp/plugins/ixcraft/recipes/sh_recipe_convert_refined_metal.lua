
RECIPE.name = "Reclaimed Metal"
RECIPE.description = "Break down Refined Metal into Reclaimed Metal."
RECIPE.model = "models/props_lab/pipesystem03a.mdl"
RECIPE.category = "Convert"
RECIPE.requirements = {
	["refined_metal"] = 1
}
RECIPE.results = {
	["reclaimed_metal"] = 2
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)