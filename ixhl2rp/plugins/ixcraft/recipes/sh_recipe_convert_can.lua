
RECIPE.name = "Metal Can"
RECIPE.description = "Break down a metal can."
RECIPE.model = "models/props_junk/garbage_metalcan001a.mdl"
RECIPE.category = "Convert"
RECIPE.requirements = {
	["empty_can"] = 2
}
RECIPE.results = {
	["scrap_metal"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)