local PANEL = {}

function PANEL:Init()
	self.title = self:AddLabel("Customise your character")
	self.face = self:SubLabel("Facial appearence")

	self.skins = self:Add("DIconLayout")
	self.skins:Dock(FILL)
	self.skins:SetSpaceX(4)
	self.skins:SetSpaceY(4)
	self.skins:SetDrawBackground(false)
	self.skins:SetStretchWidth(true)
	self.skins:SetStretchHeight(true)
	self.skins:StretchToParent(0, 0, 0, 0)

	--self.facialhair = self:SubLabel("Facial hair")
end

function PANEL:Display()
	local faction = ix.faction.indices[self:GetPayload("faction")]
	local model = self:GetModelPanel()
	local skins = model.Entity:SkinCount()
	local oldChildren = self.skins:GetChildren()

	self.skins:InvalidateLayout(true)

	local function PaintIcon(icon, w, h)
		self:PaintIcon(icon, w, h)
	end

	for i = 0, skins-1 do
		local icon = self.skins:Add("SpawnIcon")
		icon:SetSize(64, 128)
		icon:InvalidateLayout(true)
		icon.DoClick = function(icon)
			self:GetModelPanel().Entity:SetSkin(i)
		end
		icon.PaintOver = paintIcon
		icon:SetModel(faction.models[self:GetPayload("model")], i)
	end

	self.skins:Layout()
	self.skins:InvalidateLayout()

	for _, child in pairs(oldChildren) do
		child:Remove()
	end
end

function PANEL:ShouldSkip()
	local faction = ix.faction.indices[self:GetPayload("faction")]
	local model = faction.models[self:GetPayload("model")]
	local skins = self:GetModelPanel().Entity:SkinCount()

	if(string.find(model, "/female") and skins < 2) then
		-- todo: ix.gui.charCreate:ShowMessage("Skipped customisation. There are no skins for this model.")
		return true
	end

	return false
end

function PANEL:OnSkip()
	self:SetPayload("skin", 0)
	self:SetPayload("facialhair", 0)
end

vgui.Register("ixCharacterCustomisation", PANEL, "ixCharacterCreateStep")
