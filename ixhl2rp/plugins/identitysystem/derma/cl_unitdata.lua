local PANEL = {}

function PANEL:Build(target, cid, data, cpData)
    self.target = target;
    self.dataName = cpData.cpCitizenName or self.target:GetName()
	self.dataPoints = data.dataPoints or {};
	self.checked = data.checked or {}
    self.dataCID = cid;
    
    self.sidePanel = self:Add("DPanel")
    self.sidePanel:Dock(LEFT)
    self.sidePanel:SetSize(300, h)

	self.sidePanelTitleLabel = self.sidePanel:Add(self:AddLabel(true, "Identification Record"))
	self.sidePanelLabel = self.sidePanel:Add(self:AddLabel(false, "Citizen Name: John Doe\nCitizen ID: 11111\nIssue Date: 10/28/18\nIssuing Officer: N/A"))
	self.sidePanelLabel:DockMargin(0,0,0,8)
end

function PANEL:AddLabel(title, text)
    local label = self:Add("DLabel")
    local font = "ixSmallFont"

    if(title) then
        font = "ixBigFont"
    end

	label:SetContentAlignment(5)
	label:SetFont(font)
	label:SetText(text)
	label:Dock(TOP)
	label:SizeToContents()
    label:SetExpensiveShadow(3)

	return label
end


vgui.Register("ixUnitData", PANEL, "DPanel")