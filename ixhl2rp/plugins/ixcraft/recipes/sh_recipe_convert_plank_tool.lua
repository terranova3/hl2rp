
RECIPE.name = "Wooden Pieces Advanced"
RECIPE.description = "Break down a plank with a saw for parts."
RECIPE.model = "models/props_debris/wood_chunk04c.mdl"
RECIPE.category = "Convert"
RECIPE.requirements = {
	["plank"] = 1
}
RECIPE.results = {
	["wood_piece"] = 4
}
RECIPE.tools = {
	"hand_saw"
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
