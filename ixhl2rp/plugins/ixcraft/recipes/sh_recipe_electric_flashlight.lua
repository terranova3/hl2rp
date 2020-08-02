
RECIPE.name = "Flashlight"
RECIPE.description = "Solder wires from a battery to an LED light then cover it with plastic and magnify it with glass to create a makeshift flashlight."
RECIPE.model = "models/Items/battery.mdl"
RECIPE.category = "Electrical"
RECIPE.requirements = {
	["scrap_metal"] = 1,
	["scrap_glass"] = 1,
	["chunk_of_plastic"] = 2,
	["battery_h"] = 1
}
RECIPE.results = {
	["flashlight"] = 1
}
RECIPE.tools = {
	"pliers"
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
