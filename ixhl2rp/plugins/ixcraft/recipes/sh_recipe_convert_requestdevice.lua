
RECIPE.name = "Request Device"
RECIPE.description = "Smash the tamper proof request devices for spare electronics, you may break alot in the process."
RECIPE.model = "models/gibs/shield_scanner_gib1.mdl"
RECIPE.category = "Convert"
RECIPE.requirements = {
	["request_device"] = 3
}
RECIPE.results = {
	["scrap_electronics"] = 1
}
RECIPE.tools = {
	"hammer"
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
