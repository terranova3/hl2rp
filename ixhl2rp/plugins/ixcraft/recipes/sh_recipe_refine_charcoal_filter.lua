
RECIPE.name = "Activated Charcoal"
RECIPE.description = "Use chemicals, charcoal and heat to create activated charcoal."
RECIPE.model = "models/props_junk/garbage_metalcan002a.mdl"
RECIPE.category = "Refine"
RECIPE.requirements = {
	["charcoal"] = 2,
	["chemical"] = 1
}
RECIPE.results = {
	["charcoal_filter"] = 2
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_furnace")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 170 * 170) then
			return true
		end
	end

	return false, "You need to be near a furnace."
end)
