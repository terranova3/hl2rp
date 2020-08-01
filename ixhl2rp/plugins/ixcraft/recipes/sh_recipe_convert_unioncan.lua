
RECIPE.name = "Union Can"
RECIPE.description = "Break down a metal can."
RECIPE.model = "models/props_lunk/popcan01a.mdl"
RECIPE.category = "Convert"
RECIPE.requirements = {
	["unionwater"] = 3
}
RECIPE.results = {
	["scrap_metal"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_furnace")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 170 * 170) then
			return true
		end
	end

	return false, "You need to be near a furnace."
end)
