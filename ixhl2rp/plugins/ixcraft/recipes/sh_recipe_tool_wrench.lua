
RECIPE.name = "Wrench"
RECIPE.description = "A mechanical wrench for vehicles."
RECIPE.model = "models/props_c17/tools_wrench01a.mdl"
RECIPE.category = "Tools"
RECIPE.requirements = {
	["refined_metal"] = 2,
	["screws"] = 2
}
RECIPE.results = {
	["wrench"] = 1
}
RECIPE.tools = {
	"screwdriver",
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
