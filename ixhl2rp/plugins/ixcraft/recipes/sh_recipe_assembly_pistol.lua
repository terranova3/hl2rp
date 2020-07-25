
RECIPE.name = "Assemble 9mm HK Pistol (HL2)"
RECIPE.description = "A 9mm HK USP Match barrel pistol."
RECIPE.model = "models/weapons/w_pistol.mdl"
RECIPE.category = "Assembly"
RECIPE.requirements = {
	["gun_frame_part"] = 1,
	["gun_barrel_part"] = 1,
	["gun_magazine"] = 1,
	["gun_trigger_part"] = 1,
	["gun_chambering_part"] = 1
}
RECIPE.results = {
	["pistol"] = 1
}
RECIPE.tools = {
	"screwdriver",
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
