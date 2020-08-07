
RECIPE.name = "Antlion Meat"
RECIPE.description = "You wonder what this will taste like.."
RECIPE.model = "models/gibs/antlion_gib_small_2.mdl"
RECIPE.category = "Cooking"
RECIPE.requirements = {
	["antlionmeat"] = 1
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
