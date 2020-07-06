
RECIPE.name = "Blowtorch"
RECIPE.description = "Cant be tight if it's a liquid. Comes in various heat settings."
RECIPE.model = "models/props_c17/utilityconnecter006.mdl"
RECIPE.category = "Tools"
RECIPE.requirements = {
	["niter"] = 2,
	["charcoal"] = 2,
	["reclaimed_metal"] = 2,
	["screws"] = 1,
	["bolts"] = 2,
	
}
RECIPE.results = {
	["blow_torch"] = 1
}
RECIPE.tools = {
	"screwdriver",
	"pliers"
}
RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
