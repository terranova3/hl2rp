
RECIPE.name = "Paint Can"
RECIPE.description = "Break down a paint can."
RECIPE.model = "models/props_junk/metal_paintcan001b.mdl"
RECIPE.category = "Convert"
RECIPE.requirements = {
	["empty_paint_can"] = 1
}
RECIPE.results = {
	["scrap_metal"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)