
RECIPE.name = "Screwdriver"
RECIPE.description = "Screw your problems."
RECIPE.model = "models/props_c17/TrapPropeller_Lever.mdl"
RECIPE.category = "Tools"
RECIPE.requirements = {
	["refined_metal"] = 1,
	["chunk_of_plastic"] = 2,
	["nails"] = 2
}
RECIPE.results = {
	["screwdriver"] = 1
}
RECIPE.tools = {
	"pliers",
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
