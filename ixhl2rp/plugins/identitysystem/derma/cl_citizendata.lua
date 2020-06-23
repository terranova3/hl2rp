local PANEL = {}

function PANEL:Build(target, cid, data, cpData)
    self.target = target;
    self.dataName = cpData.cpCitizenName or self.target:GetName()
	self.dataPoints = data.dataPoints or {};
	self.checked = data.checked or {}
    self.dataCID = cid;

	local checkboxes = {"Wanted for Questioning", "Survey Closely", "Elevated Citizen Status"}
    
    self.sidePanel = self:Add("DPanel")
    self.sidePanel:Dock(LEFT)
    self.sidePanel:SetSize(300, h)

	self.sidePanelTitleLabel = self.sidePanel:Add(self:AddLabel(true, "Identification Record"))
	self.sidePanelLabel = self.sidePanel:Add(self:AddLabel(false, "Citizen Name: John Doe\nCitizen ID: 11111\nIssue Date: 10/28/18\nIssuing Officer: N/A"))
	self.sidePanelLabel:DockMargin(0,0,0,8)
	
	local i = 1

	for k, v in ipairs(checkboxes) do 
		local checkBox = self.sidePanel:Add("DCheckBoxLabel")
		checkBox:SetFont("ixSmallFont")
		checkBox:SetText(v)
		checkBox:Dock(TOP)
		checkBox:DockMargin(16, 4, 0, 0)
		checkBox.arrIndex = i
		checkBox.OnChange = function(checked)
			self.checked[checkBox.arrIndex] = !self.checked[checkBox.arrIndex]
		end

		if(self.checked[checkBox.arrIndex]) then
			checkBox:SetChecked(self.checked[checkBox.arrIndex])
		else
			self.checked[checkBox.arrIndex] = false
		end

		i=i+1
	end
	
	self.sidePanelNoteLabel = self.sidePanel:Add(self:AddLabel(true, "Notes"))
    self.sidePanelNoteLabel:DockMargin(0, 8, 0, 0)

    self.sidePanelNote = self.sidePanel:Add("DTextEntry")
    self.sidePanelNote:SetMultiline(true)
    self.sidePanelNote:DockMargin(8, 0, 8, 8)
	self.sidePanelNote:Dock(FILL)
	self.sidePanelNote:SetText(data.text or "")

    function self.sidePanelNote:PerformLayout()
        self:SetBGColor( Color(50, 50, 50, 50) )
    end
    
	self.addRecordButton = self:Add("DButton")
	self.addRecordButton:SetFont("ixSmallFont")
	self.addRecordButton:SetText("Add Record")
	self.addRecordButton:Dock(BOTTOM)

	function self.addRecordButton:DoClick()
		if (ix.gui.dataDraftPanel and ix.gui.dataDraftPanel:IsValid()) then
			ix.gui.dataDraftPanel:Close();
			ix.gui.dataDraftPanel:Remove();
		end;

		ix.gui.dataDraftPanel = vgui.Create("ixDataDraft");
		ix.gui.dataDraftPanel:Populate();
		ix.gui.dataDraftPanel:MakePopup();
	end

	self.deleteRecordButton = self:Add("DButton");
	self.deleteRecordButton:SetFont("ixSmallFont")
	self.deleteRecordButton:SetText("Delete Selected");
	self.deleteRecordButton:Dock(BOTTOM);
	self.deleteRecordButton.DoClick = function()
		local selectedID = self.listView:GetSelectedLine();

		if selectedID then
			local linePanel = self.listView:GetLine(selectedID);

			if linePanel.dataIndex then
				self.dataPoints[linePanel.dataIndex] = nil;
			end;
		end;

		self:RebuildRecords();
		self:RebuildSidePanel();
	end

	self.listView = self:Add("DListView")
	self.listView:Dock(FILL)
	self.listView:SetMultiSelect(false);
	self.listView:AddColumn("Record Reason");
	self.listView:AddColumn("Issuing Officer");
	self.listView:AddColumn("Point Type");
	self.listView:AddColumn("Amount");

	self:RebuildRecords()
	self:RebuildSidePanel()

	-- A function to set the text entry's real value.
	function self.sidePanelNote:SetRealValue(text)
		self:SetValue(text);
		self:SetCaretPos( string.len(text) );
	end;

	-- Called each frame.
	function self.sidePanelNote:Think()
		local text = self:GetValue();

		if (string.len(text) > 1024) then
			self:SetRealValue( string.sub(text, 0, 1024) );

			surface.PlaySound("common/talk.wav");
		end;
	end;
end

function PANEL:RebuildSidePanel()
	local loyaltyPoints = 0;
	local penaltyPoints = 0;

	for i, v in pairs(self.dataPoints) do
		local isLoyal = v.loy;
		local amount = tonumber(v.num) or 0;

		if isLoyal then
			loyaltyPoints = loyaltyPoints + amount;
		else
			penaltyPoints = penaltyPoints + amount;
		end;
	end;

	local totalPoints = loyaltyPoints - penaltyPoints;

	self.sidePanelLabel:SetText(
		"Citizen Name: " .. self.dataName .. "\n" ..
		"Citizen ID: " .. self.dataCID .. "\n" ..
		"Total Points: " .. totalPoints
	)
	
	self.sidePanelLabel:SizeToContents()
end;

function PANEL:RebuildRecords()
	self.listView:Clear();

	for i, v in pairs(self.dataPoints) do
		local reason = v.rsn or "Unspecified";
		local addedBy = v.usr or "Unknown";
		local isLoyal = v.loy;
		local amount = tonumber(v.num) or 0;

		local pointType = isLoyal and "Loyalty" or "Penalty";

		local linePanel = self.listView:AddLine(reason, addedBy, pointType, amount);
		linePanel.dataIndex = i;
	end;
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

function PANEL:Save()
    local data = {
        target = self.target,
        text = string.sub(self.sidePanelNote:GetValue(), 0, 1024),
        dataPoints = self.dataPoints,
        checked = self.checked
    }

    netstream.Start("ViewDataUpdate", data);
    Schema:AddCombineDisplayMessage("@cViewDataUpdate")
end

vgui.Register("ixCitizenData", PANEL, "DPanel")