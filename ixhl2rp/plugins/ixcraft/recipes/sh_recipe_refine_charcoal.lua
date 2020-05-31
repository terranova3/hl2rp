
RECIPE.name = "Refine: Charcoal"
RECIPE.description = "Burn wood down into carbon charcoal."
RECIPE.model = "models/props_c17/oildrum001.mdl"
RECIPE.category = "Refine"
RECIPE.requirements = {
	["wood_piece"] = 2
}
RECIPE.results = {
	["charcoal"] = 1
}

RECIPE:PostHook("OnCanCraft", function(client)
	for _, v in pairs(ents.FindByClass("ix_station_furnace")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a furnace."
end)
