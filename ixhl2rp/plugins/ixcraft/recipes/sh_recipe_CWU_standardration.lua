
RECIPE.name = "Package Standard Ration"
RECIPE.description = "Assemble a standard ration unit."
RECIPE.model = "models/weapons/w_packatc.mdl"
RECIPE.category = "Work Cycle"
RECIPE.requirements = {
	["standardgradesupppacket"] = 1,
	["standardgrademealkit"] = 1,
	["empty_ration"] = 1
}
RECIPE.results = {
	["ration_standard"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
