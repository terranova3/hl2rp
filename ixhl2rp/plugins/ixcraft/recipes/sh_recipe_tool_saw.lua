
RECIPE.name = "Saw"
RECIPE.description = "A saw, perfect for cutting wood."
RECIPE.model = "models/mark2580/gtav/garage_stuff/grinder_01a.mdl"
RECIPE.category = "Tools"
RECIPE.requirements = {
	["refined_metal"] = 1,
	["chunk_of_plastic"] = 2,
	["bolts"] = 1
}
RECIPE.results = {
	["hand_saw"] = 1
}
RECIPE.tools = {
	"blow_torch"
}

RECIPE:PostHook("OnCanCraft", function(recipeTable, client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
