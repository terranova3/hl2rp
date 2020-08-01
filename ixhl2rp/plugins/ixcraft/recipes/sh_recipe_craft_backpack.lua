RECIPE.name = "Backpack"
RECIPE.description = "Sew cloth together into a rugged backpack capable of holding your things."
RECIPE.model = "models/props_c17/SuitCase001a.mdl"
RECIPE.category = "Crafting"
RECIPE.requirements = {
	["sewn_cloth"] = 5
}
RECIPE.results = {
	["backpack"] = 1
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
