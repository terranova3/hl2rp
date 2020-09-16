local PLUGIN = PLUGIN
local PANEL = {}

AccessorFunc(PANEL, "connected_entity", "Entity")

surface.CreateFont("ix_tokendistr_21", {
	font = "Trebuchet",
	size = 21,

})

function PANEL:Init()

	self:SetSize(460, 220)
	self:Center()
	self:SetDeleteOnClose(true)
	self:SetTitle("Token Distributor Terminal")
	self:MakePopup()

	-- Header --------------------------------------------------------------
	self.headerLbl = self:Add("DLabel")
	self.headerLbl:SetFont("ix_tokendistr_21")
	self.headerLbl:SetText("Token Distributor")
	self.headerLbl:SizeToContents()
	local x = self.headerLbl:GetSize()
	self.headerLbl:SetPos(230-x/2, 40)
	-- END -----------------------------------------------------------------
end


function PANEL:InitCWU()

	-- Paygrade Row --------------------------------------------------------
	self.curPayGradeLabel = self:Add("DLabel")
	self.curPayGradeLabel:SetFont("ix_tokendistr_21")
	self.curPayGradeLabel:SetText("Selected paygrade: ")
	self.curPayGradeLabel:SetTextColor(Color(220,220,220))
	self.curPayGradeLabel:SetPos(50, 90)
	self.curPayGradeLabel:SizeToContents()

	self.payGradeCombo = self:Add("DComboBox")
	self.payGradeCombo:SetPos(250, 88)
	self.payGradeCombo:SetSize(150, 25)
	self.payGradeCombo:SetFont("Trebuchet18")
	for i,v in ipairs(PLUGIN.Paygrades) do
		-- Add choices, select the first option.
		self.payGradeCombo:AddChoice(v[1], v[2], i == 1)
	end

	-- Wiki variables are wrong for OnSelect function!
	self.payGradeCombo.OnSelect = function(panelData, index, data)
		self.SelectedPaygradeIndex = index
	end
	-- END-----------------------------------------------------------------------

	-- Workers to distribute row ------------------------------------------------
	self.workerLbl = self:Add("DLabel")
	self.workerLbl:SetFont("ix_tokendistr_21")
	self.workerLbl:SetText("Workers to distribute: ")
	self.workerLbl:SetTextColor(Color(220,220,220))
	self.workerLbl:SetPos(50, 120)
	self.workerLbl:SizeToContents()

	
	self.workerCount = self:Add("DComboBox")
	self.workerCount:SetPos(250, 120)
	self.workerCount:SetSize(50, 25)
	self.workerCount:SetFont("Trebuchet18")
	self.workerCount:SetSortItems(false)
	for i=1, PLUGIN.MaxWorkerCount do
		-- Add choices, select the first option.
		self.workerCount:AddChoice(i,i, i==1)
	end

	-- Wiki variables are wrong for OnSelect function!
	self.workerCount.OnSelect = function(panelData, index, data)
		self.SelectedWorkerCount = index
		print(index)
	end
	-- END----------------------------------------------------------------------

	self.requestBtn = self:Add("DButton")
	self.requestBtn:SetText("Send Request")
	self.requestBtn:SetSize(120, 25)
	self.requestBtn:SetPos(230-60, 170)
	self.requestBtn.DoClick = function()
		-- If these variables are nil, then the player haven't changed the default choices.
		self.SelectedPaygradeIndex = self.SelectedPaygradeIndex or 1
		self.SelectedWorkerCount = self.SelectedWorkerCount or 1
		netstream.Start("ix_token_distr_request", self.SelectedPaygradeIndex, self.SelectedWorkerCount, self:GetEntity())
		self:Close()
	end

end

function PANEL:InitAdmin()

	local ent = self:GetEntity()

	self:SetTitle("Token Distributor - Management Menu")

	self.statusLbl = self:Add("DLabel")
	self.statusLbl:SetFont("ix_tokendistr_21")

	self.toggleBtn = self:Add("DButton")
	self.toggleBtn:SetSize(85, 25)
	self.toggleBtn:SetPos(230-42.5, 145)
	self.toggleBtn.DoClick = function()
		netstream.Start("ix_token_distr_toggle", ent)
	end
end

function PANEL:Think()
	-- Think only when admin panel is open, not when cwu menu is.
	if self.statusLbl == nil then return end

	local isActive = self:GetEntity():GetNWBool("isActive")

	self.statusLbl:SetText("Token Distributor is currently "..(isActive and "ONLINE" or "OFFLINE"))
	self.statusLbl:SizeToContents()

	local x = self.statusLbl:GetSize()
	self.statusLbl:SetPos(230-x/2, 100)

	self.toggleBtn:SetText("Turn "..(isActive and "OFF" or "ON"))
end



vgui.Register("ixTokenDistrMngPnl", PANEL, "DFrame")
