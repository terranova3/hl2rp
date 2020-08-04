
RECIPE.name = "Houndeye Meat"
RECIPE.description = "This seems edible, barely."
RECIPE.model = "models/gibs/houndeye/back_leg.mdl"
RECIPE.category = "Coooking"
RECIPE.requirements = {
	["houndeyemeat"] = 1
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
