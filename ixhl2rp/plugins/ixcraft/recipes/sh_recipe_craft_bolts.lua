
RECIPE.name = "Bolts"
RECIPE.description = "Craft a handful of bolts with metal pieces."
RECIPE.model = "models/props_lab/box01a.mdl"
RECIPE.category = "Crafting"
RECIPE.requirements = {
	["reclaimed_metal"] = 1
}
RECIPE.results = {
	["screws"] = 1
}
RECIPE.tools = {
	"blow_torch"
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
