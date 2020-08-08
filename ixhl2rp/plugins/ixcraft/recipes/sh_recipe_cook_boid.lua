
RECIPE.name = "Boid Meat"
RECIPE.description = "What... Is this?"
RECIPE.model = "models/kek1ch/hide_burer.mdl"
RECIPE.category = "Cooking"
RECIPE.requirements = {
	["boidbirdmeat"] = 1
}
RECIPE.results = {
	["genericmeat"] = 1
}
RECIPE.tools = {
	"pan"
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_stove")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a stove."
end)
