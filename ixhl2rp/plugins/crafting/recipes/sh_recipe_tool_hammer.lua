
RECIPE.name = "Hammer"
RECIPE.description = "A hammer to smash away your problems."
RECIPE.model = "models/props_interiors/pot02a.mdl"
RECIPE.category = "Electrical"
RECIPE.requirements = {
	["reclaimed_metal"] = 2,
	["screws"] = 1,
	["wood_piece"] = 2
}
RECIPE.results = {
	["hammer"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
