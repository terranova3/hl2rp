
RECIPE.name = "Reinforced Cloth"
RECIPE.description = "Using metals and harden materials, make a durable fabric material."
RECIPE.model = "models/gibs/scanner_gib02.mdl"
RECIPE.category = "Sewing"
RECIPE.requirements = {
	["sewn_cloth"] = 2,
	["refined_metal"] = 1
}
RECIPE.results = {
	["reinforced_cloth"] = 1
}
RECIPE.tools = {
	"sewing_kit"
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
