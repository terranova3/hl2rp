
RECIPE.name = "Package Minimum Ration"
RECIPE.description = "Assemble a minimum ration unit."
RECIPE.model = "models/weapons/w_packati.mdl"
RECIPE.category = "Work Cycle"
RECIPE.requirements = {
	["mingradesupppacket"] = 1,
	["unionwater"] = 1,
	["empty_ration"] = 1
}
RECIPE.results = {
	["ration_minimum"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
