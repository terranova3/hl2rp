local PANEL = {}

function PANEL:Build(target, cid, data, cpData)
    self.cpData = cpData

    self.sidePanel = self:Add("DPanel")
    self.sidePanel:Dock(LEFT)
    self.sidePanel:SetSize(300, h)

	self.sidePanelTitleLabel = self.sidePanel:Add(self:AddLabel(true, "Unit Career File"))
	self.sidePanelLabel = self.sidePanel:Add(self:AddLabel(false, "Unit Rank: John Doe\nUnit Tagline: 11111\nSpecialization: N/A"))
    self.sidePanelLabel:DockMargin(0,0,0,8)
    
    self:RebuildSidePanel();
end

function PANEL:RebuildSidePanel()
    local sidePanelText = (
        "Unit Rank: " .. self.cpData.rankObject.displayName ..
        "\nUnit Tagline " .. self.cpData.fullTagline
    )

    if(self.cpData.spec != nil) then
        sidePanelText = sidePanelText .. "\nSpecialization: " .. self.cpData.spec
    end

	self.sidePanelLabel:SetText(sidePanelText)
	self.sidePanelLabel:SizeToContents()
end;

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