
RECIPE.name = "Nails"
RECIPE.description = "Craft a handful of nails with metal pieces."
RECIPE.model = "models/props_lab/box01a.mdl"
RECIPE.category = "Crafting"
RECIPE.requirements = {
	["scrap_metal"] = 1
}
RECIPE.results = {
	["nails"] = 1
}
RECIPE.tools = {
	"hammer"
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
