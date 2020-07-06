
RECIPE.name = "Sewing Kit"
RECIPE.description = "Create a Sewing Kit to further improve your skills."
RECIPE.model = "models/props_lab/partsbin01.mdl"
RECIPE.category = "Tools"
RECIPE.requirements = {
	["scrap_metal"] = 2,
	["sewn_cloth"] = 3,
	["nails"] = 2
}
RECIPE.results = {
	["sewing_kit"] = 1
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
