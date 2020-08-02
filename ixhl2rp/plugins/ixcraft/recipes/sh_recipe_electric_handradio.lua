
RECIPE.name = "Handheld Radio"
RECIPE.description = "Follow the guide as described to create a functional handheld radio, complete with a frequancy. This would be unsecure."
RECIPE.model = "models/radio/w_radio.mdl"
RECIPE.category = "Electrical"
RECIPE.requirements = {
	["screws"] = 2,
	["chunk_of_plastic"] = 2,
	["refined_electronics"] = 1
}
RECIPE.results = {
	["handheld_radio"] = 1
}
RECIPE.tools = {
	"pliers",
	"screwdriver",
	"book_advelec"
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
