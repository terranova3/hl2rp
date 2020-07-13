RECIPE.name = "Xen Solution"
RECIPE.description = "A Xen plant based healing solution stored in a syringe.."
RECIPE.model = "models/ccr/props/syringe.mdl"
RECIPE.category = "Medical"
RECIPE.requirements = {
	["brainfungus"] = 2,
	["lureweed"] = 1,
	["empty_syringe"] = 1
}
RECIPE.results = {
	["xensolution"] = 1
}
RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
