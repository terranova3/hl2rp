--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of the author.
--]]

local PLUGIN = PLUGIN;

ITEM.base = "base_outfit"
ITEM.name = "Legs";
ITEM.model = "models/props_junk/cardboard_box004a.mdl";
ITEM.outfitCategory = "legs";
ITEM.category = "Clothing";
ITEM.description = "Legs Base";
ITEM.width = 1
ITEM.height = 1
ITEM.iconCam = {
	pos = Vector(0, 0, 200),
	ang = Angle(89.083892822266, 89.995094299316, 0),
	fov = 8.8235294117647
}

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		local panel = tooltip:AddRowAfter("name", "slot")
		panel:SetBackgroundColor(derma.GetColor("Info", tooltip))
		panel:SetText("Slot: " .. self.outfitCategory or "")
		panel:SizeToContents()
	end
end