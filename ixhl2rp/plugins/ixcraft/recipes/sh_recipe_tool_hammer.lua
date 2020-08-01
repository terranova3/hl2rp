
RECIPE.name = "Hammer"
RECIPE.description = "A hammer to smash away your problems."
RECIPE.model = "models/mark2580/gtav/garage_stuff/cs_hammer.mdl"
RECIPE.category = "Tools"
RECIPE.requirements = {
	["reclaimed_metal"] = 2,
	["screws"] = 1,
	["wood_piece"] = 2
}

RECIPE.results = {
	["hammer"] = 1
}

RECIPE:PostHook("OnCanCraft", function(client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
