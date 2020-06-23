local PANEL = {}

function PANEL:Init()
    ix.gui.viewdata = self

    self:SetBackgroundBlur(true);
	self:Center()
    self:MakePopup()
    self:SetAlpha(0)
end

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();

	self:SetSize(scrW * 0.5, scrH * 0.5)
	self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) );
end;

function PANEL:Build(target, cid, data, cpData)
	self.headerLabel:SetText("Viewing " .. target:GetName() .. "'s record")
	self:AlphaTo(255, 0.5)

	self.topDock = self:Add("DPanel")
	self.topDock:Dock(TOP)
	self.topDock:DockMargin(0,0,0,4)
	self.topDock.Paint = function() end

	self.citizenPanel = self:AddStagePanel("citizenPanel", "ixCitizenData")
	self.citizenPanel:Build(target, cid, data, cpData)

	self.unitPanel = self:AddStagePanel("unitPanel", "ixUnitData")
	self.gmPanel = self:AddStagePanel("gmPanel")

	-- Populating the top dock with the buttons for moving between stages.
	self.citizenButton = self.topDock:Add(self:AddStageButton("Citizen Record", "citizenPanel"))
	self.citizenButton:SetSize(150, self:GetTall())

	self.unitButton = self.topDock:Add(self:AddStageButton("Unit Record", "unitPanel"))
	self.unitButton:SetSize(150, self:GetTall())

	self.gmButton = self.topDock:Add(self:AddStageButton("GM", "gmPanel"))
	self.gmButton:Dock(RIGHT)
	self.gmButton:SetSize(64, self:GetTall())

	self:SetActivePanel("citizenPanel");
end

function PANEL:OnRemove()
	if (IsValid(self.citizenPanel)) then
		self.citizenPanel:Save()
	end;

	ix.gui.viewdata = nil
end

vgui.Register("ixRecordPanel", PANEL, "ixStagePanel")