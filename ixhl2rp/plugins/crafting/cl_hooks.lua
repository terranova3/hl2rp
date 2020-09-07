--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN
local font = "Futura Std Medium"
	
surface.CreateFont("ixRecipeDescription", {
    font = font,
    weight = 200,
    size = 16,
    additive = true
})

function PLUGIN:PopulateStationTooltip(tooltip, station)
	local name = tooltip:AddRow("name")
	name:SetImportant()
	name:SetText(station.GetName and station:GetName() or L(station.name))
	name:SetMaxWidth(math.max(name:GetMaxWidth(), ScrW() * 0.5))
	name:SizeToContents()

	local description = tooltip:AddRow("description")
	description:SetText(station.GetDescription and station:GetDescription() or L(station.description))
	description:SizeToContents()

	if (station.PopulateTooltip) then
		station:PopulateTooltip(tooltip)
	end
end
