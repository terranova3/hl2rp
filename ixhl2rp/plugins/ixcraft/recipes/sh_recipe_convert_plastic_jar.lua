
RECIPE.name = "Plastic Jar"
RECIPE.description = "Break down an empty plastic jar."
RECIPE.model = "models/props_lab/jar01b.mdl"
RECIPE.category = "Convert"
RECIPE.requirements = {
	["empty_jar"] = 1
}
RECIPE.results = {
	["chunk_of_plastic"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)