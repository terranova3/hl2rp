
RECIPE.name = "Electrical: Refined Eletronics"
RECIPE.description = "Solder scrap eletronics into a refined set."
RECIPE.model = "models/props_lab/reciever01d.mdl"
RECIPE.category = "Electrical"
RECIPE.requirements = {
	["scrap_electronics"] = 2,
	["refined_metal"] = 1
}
RECIPE.results = {
	["refined_electronics"] = 1
}
RECIPE.tools = {
	"blow_torch"
}
RECIPE:PostHook("OnCanCraft", function(client)
	for _, v in pairs(ents.FindByClass("ix_station_workbench")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near a workbench."
end)
