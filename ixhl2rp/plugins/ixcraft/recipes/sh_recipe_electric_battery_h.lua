
RECIPE.name = "Battery_h"
RECIPE.description = "Build an electrical battery."
RECIPE.model = "models/props_lab/reciever01d.mdl"
RECIPE.category = "Electrical"
RECIPE.requirements = {
	["scrap_metal"] = 1,
	["reclaimed_metal"] = 1,
	["scrap_electronics"] = 2
}
RECIPE.results = {
	["battery_h"] = 1
}
RECIPE.tools = {
	"pliers",
	"screwdriver"
}
RECIPE:PostHook("OnCanCraft", function(client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
