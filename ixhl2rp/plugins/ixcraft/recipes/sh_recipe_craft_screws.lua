
RECIPE.name = "Screws"
RECIPE.description = "Craft a handful of screws with metal pieces."
RECIPE.model = "models/props_c17/FurnitureTable003a.mdl"
RECIPE.category = "Crafting"
RECIPE.requirements = {
	["reclaimed_metal"] = 2
}
RECIPE.results = {
	["screws"] = 1
}
RECIPE.tools = {
	"pliers"
}
RECIPE:PostHook("OnCanCraft", function(client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
