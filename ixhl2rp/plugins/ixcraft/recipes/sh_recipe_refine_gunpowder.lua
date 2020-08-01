
RECIPE.name = "Gunpowder"
RECIPE.description = "Mix Nitre and charocal to make gunpowder."
RECIPE.model = "models/props_junk/metal_paintcan001a.mdl"
RECIPE.category = "Refine"
RECIPE.requirements = {
	["niter"] = 2,
	["charcoal"] = 1
}
RECIPE.results = {
	["gunpowder"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_furnace")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 400 * 400) then
			return true
		end
	end

	return false, "You need to be near a furnace."
end)
