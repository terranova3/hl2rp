
RECIPE.name = "Scrap Glass Bottle"
RECIPE.description = "Prep your broken glass bottle as a weapon"
RECIPE.model = "models/weapons/hl2meleepack/w_brokenbottle.mdl"
RECIPE.category = "Assembly"
RECIPE.requirements = {
	["scrap_cloth"] = 1,
	["scrap_glass"] = 1
}

RECIPE.results = {
	["broken_bottle"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
