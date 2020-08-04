
RECIPE.name = "Wrench"
RECIPE.description = "A mechanical wrench for vehicles."
RECIPE.model = "models/props_c17/tools_wrench01a.mdl"
RECIPE.category = "Tools"
RECIPE.requirements = {
	["charcoal_filter"] = 2,
	["scrap_cloth"] = 1,
	["chunk_of_plastic"] = 1
}
RECIPE.results = {
	["water_filter"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
