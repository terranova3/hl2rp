
RECIPE.name = "Purify Dirty Water"
RECIPE.description = "Use the rapid purification tablets on the water."
RECIPE.model = "models/props_lunk/popcan01a.mdl"
RECIPE.category = "Work Cycle"
RECIPE.requirements = {
	["water_dirty"] = 1,
	["water_purifytab"] = 1
}
RECIPE.results = {
	["unionwater"] = 2
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
