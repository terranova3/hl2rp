
RECIPE.name = "Refined Metal"
RECIPE.description = "Process Reclaimed metal into Refined metal."
RECIPE.model = "models/props_vents/vent_small_straight002.mdl"
RECIPE.category = "Refine"
RECIPE.requirements = {
	["reclaimed_metal"] = 2
}
RECIPE.results = {
	["refined_metal"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_furnace")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a furnace."
end)
