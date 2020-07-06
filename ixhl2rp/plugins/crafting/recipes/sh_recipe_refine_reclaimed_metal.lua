
RECIPE.name = "Reclaimed Metal"
RECIPE.description = "Process Scrap metal into Reclaimed metal."
RECIPE.model = "models/props_lab/pipesystem03a.mdl"
RECIPE.category = "Refine"
RECIPE.requirements = {
	["scrap_metal"] = 2
}
RECIPE.results = {
	["reclaimed_metal"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_furnace")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a furnace."
end)

