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
	self:Register("Customization")
end

function PANEL:Display()
	local faction = ix.faction.indices[self:GetPayload("faction")]
	local model = self:GetModelPanel()
	local skins = model.Entity:SkinCount()
	local oldChildren = self.skins:GetChildren()

	if(faction.name == "Overwatch Transhuman Arm") then
		self.face:SetText("Uniform type")
	else
		self.face:SetText("Facial appearence")
	end

	self.skins:InvalidateLayout(true)

	for i = 0, skins-1 do
		local icon = self.skins:Add("SpawnIcon")
		icon:SetSize(64, 128)
		icon:InvalidateLayout(true)
		icon.DoClick = function(icon)
			self:SetPayload("skin", i)
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
	local skins = self:GetModelPanel().Entity:SkinCount()

	if(skins < 2) then
		return true
	end

	return false
end

function PANEL:OnSkip()
	self:SetPayload("skin", 0)
end

vgui.Register("ixCharacterCustomisation", PANEL, "ixCharacterCreateStep")
