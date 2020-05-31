
RECIPE.name = "Crafting: Plank"
RECIPE.description = "Craft a plank using wooden pieces."
RECIPE.model = "models/props_c17/FurnitureTable003a.mdl"
RECIPE.category = "Crafting"
RECIPE.requirements = {
	["wood_piece"] = 4,
	["nails"] = 1
}
RECIPE.results = {
	["plank"] = 1
}
RECIPE.tools = {
	"hammer"
}
RECIPE:PostHook("OnCanCraft", function(client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
