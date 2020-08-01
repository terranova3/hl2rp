
RECIPE.name = "Reinforced cloth"
RECIPE.description = "Strip all the cloth from reinforced cloth."
RECIPE.model = "models/gibs/scanner_gib02.mdl"
RECIPE.category = "Convert"
RECIPE.requirements = {
	["reinforced_cloth"] = 1
}
RECIPE.results = {
	["refined_metal"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)