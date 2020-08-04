RECIPE.name = "Pouch"
RECIPE.description = "Form cardboard together into a small box pouch to hold your things."
RECIPE.model = "models/props_junk/garbage_bag001a.mdl"
RECIPE.category = "Crafting"
RECIPE.requirements = {
	["cardboard_scraps"] = 3
}
RECIPE.results = {
	["pouch"] = 1
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
