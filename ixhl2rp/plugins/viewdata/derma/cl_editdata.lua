--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}

-- Called when the panel is first initialized.
function PANEL:Init()
	self:Dock(FILL)
	self.backHeader = self:Add(ix.gui.record:AddBackHeader())
end

vgui.Register("ixCombineViewDataEditData", PANEL, "DPanel")