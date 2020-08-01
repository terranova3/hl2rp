
RECIPE.name = "Charcoal"
RECIPE.description = "Burn wood down into carbon charcoal."
RECIPE.model = "models/props_junk/garbage_glassbottle001a_chunk04.mdl"
RECIPE.category = "Refine"
RECIPE.requirements = {
	["wood_piece"] = 2
}
RECIPE.results = {
	["charcoal"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_furnace")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 170 * 170) then
			return true
		end
	end

	return false, "You need to be near a furnace."
end)
