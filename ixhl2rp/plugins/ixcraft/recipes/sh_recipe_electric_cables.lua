
RECIPE.name = "Cables"
RECIPE.description = "Strip metal into durable electric cables."
RECIPE.model = "models/Items/CrossbowRounds.mdl"
RECIPE.category = "Electrical"
RECIPE.requirements = {
	["reclaimed_metal"] = 1
}
RECIPE.results = {
	["cable"] = 2
}
RECIPE.tools = {
	"pliers"
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
