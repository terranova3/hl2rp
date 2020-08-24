local PANEL = {}

function PANEL:Init()
	self.title = self:AddLabel("Customise your character")
	self.subtitle = self:SubLabel("Select a model")

	self.models = self:Add("DIconLayout")
	self.models:Dock(FILL)
	self.models:SetSpaceX(4)
	self.models:SetSpaceY(4)
	self.models:SetDrawBackground(false)
	self.models:SetStretchWidth(true)
	self.models:SetStretchHeight(true)
	self.models:StretchToParent(0, 0, 0, 0)

	self:Register("Model")
end

function PANEL:Display()
	local oldChildren = self.models:GetChildren()
	self.models:InvalidateLayout(true)

	local faction = ix.faction.indices[self:GetPayload("faction")]
	if (not faction) then return end

	self.subtitle:SetTextColor(faction.color)
	self.subtitle:SetText(faction.selectModelText or "Select a model")

	for k, v in SortedPairs(faction.models) do
		local icon = self.models:Add("SpawnIcon")
		icon:SetSize(64, 128)
		icon:InvalidateLayout(true)
		icon.DoClick = function(icon)
			self:OnModelSelected(icon)
		end
		icon.PaintOver = paintIcon

		if (type(v) == "string") then
			icon:SetModel(v)
			icon.model = v
			icon.skin = 0
			icon.bodyGroups = {}
		else
			icon:SetModel(v[1], v[2] or 0, v[3])
			icon.model = v[1]
			icon.skin = v[2] or 0
			icon.bodyGroups = v[3]
		end
		icon.index = k

		if (self:GetPayload("model") == k) then
			self:OnModelSelected(icon, true)
		end
	end

	self.models:Layout()
	self.models:InvalidateLayout()
	for _, child in pairs(oldChildren) do
		child:Remove()
	end
end

function PANEL:PaintIcon(icon, w, h)
	if (self:GetPayload("model") ~= icon.index) then return end
	local color = ix.config.Get("color", color_white)

	surface.SetDrawColor(color.r, color.g, color.b, 200)

	local i2
	for i = 1, 3 do
		i2 = i * 2
		surface.DrawOutlinedRect(i, i, w - i2, h - i2)
	end
end

function PANEL:OnModelSelected(icon, noSound)
	self:SetPayload("model", icon.index or 1)
	if (not noSound) then
		ix.gui.characterMenu:clickSound()
	end
	self:UpdateModelPanel()

	-- Rebuild with no animation (true)
	if(IsValid(ix.gui.charCreateTracker)) then
		ix.gui.charCreateTracker:Build(true)
	end
end

function PANEL:ShouldSkip()
	local faction = ix.faction.indices[self:GetPayload("faction")]
	return faction and #faction.models == 1 or false
end

function PANEL:OnSkip()
	self:SetPayload("model", 1)
end

vgui.Register("ixCharacterModel", PANEL, "ixCharacterCreateStep")
