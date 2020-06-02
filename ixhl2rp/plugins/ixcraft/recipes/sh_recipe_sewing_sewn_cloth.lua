
RECIPE.name = "Sewn Cloth"
RECIPE.description = "Refine cloth scraps into some useable material."
RECIPE.model = "models/props_pipes/pipe01_straight01_short.mdl"
RECIPE.category = "Sewing"
RECIPE.requirements = {
	["cloth_scrap"] = 3
}
RECIPE.results = {
	["sewn_cloth"] = 1
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
