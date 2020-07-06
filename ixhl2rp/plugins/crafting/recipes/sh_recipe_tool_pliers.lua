
RECIPE.name = "Pliers"
RECIPE.description = "Pince and Ply."
RECIPE.model = "models/props_c17/tools_pliers01a.mdl"
RECIPE.category = "Tools"
RECIPE.requirements = {
	["reclaimed_metal"] = 2,
	["chunk_of_plastic"] = 2,
	["bolts"] = 1
}
RECIPE.results = {
	["pliers"] = 1
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
