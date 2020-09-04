
local PLUGIN = PLUGIN

local PANEL = {}

AccessorFunc(PANEL, "ix_book_itemID", "ItemID", FORCE_NUMBER)

surface.CreateFont("ix_book_typewriter",{
	font = "Typewriter",
	size = 28,
})

surface.CreateFont("ix_book_typewriter_italic",{
	font = "Typewriter",
	size = 32,
	italic = true
})

-- Character count excluding pages that are curently open.
local function GetChrCntExcludingCurPages(textArray, pageIndexLeft)
	local totalChrCount = 0
	for i=1, #textArray do
		if pageIndexLeft == i or pageIndexLeft + 1 == i then continue end

		local chrCnt = textArray[i] == nil and 0 or textArray[i]:len()
		totalChrCount = totalChrCount + chrCnt
	end
	return totalChrCount
end

local function CreateDTextEntry(parent, xPos, yPos)
	local dtext = parent:Add("DTextEntry")
	dtext:SetMultiline(true)
	dtext:SetEditable(true)
	dtext:SetSize(400,495)
	dtext:SetPos(xPos, yPos)
	dtext:SetDrawBackground(false)
	dtext:SetFont("ix_book_typewriter")
	dtext:SetUpdateOnType(true)
	dtext.OnChange = function(slf, val)
		local text = slf:GetText()
		local cLimit = PLUGIN.characterLimitPerPage
		if text:len() > cLimit then
			local newText = string.sub(text, 1, cLimit)
			slf:SetText(newText)
			slf:SetCaretPos(newText:len() - 1)
		end
	end

	dtext.AllowInput = function(slf, character)
		local otherPagesChrCnt = GetChrCntExcludingCurPages(parent.textArray, parent.pageNumberLeft)
		local totalCharacterCnt = otherPagesChrCnt + parent.pageLeft:GetText():len() + parent.pageRight:GetText():len()
		-- TRUE to don't allow input.
		return totalCharacterCnt >= PLUGIN.characterLimit
	end

	return dtext
end

local function CreatePageNumber(parent, xPos, yPos)
	local label = parent:Add("DLabel")
	label:SetFont("ix_book_typewriter_italic")
	label:SetPos(xPos, yPos)
	label:SetTextColor(Color(0,0,0))
	label:SetText("1")
	label:SetSize(60, 60)
	return label
end

local function CreatePageChangeButton(parent, btnTxt, xPos, yPos)
	local btn = parent:Add("DButton")
	btn:SetSize(40, 25)
	btn:SetPos(xPos, yPos)
	btn:SetText(btnTxt)
	return btn
end

function PANEL:Init()
	if (IsValid(PLUGIN.panel)) then
		PLUGIN.panel:Remove()
	end

	if(IsValid(ix.gui.menu)) then
        ix.gui.menu:Remove()
    end

	self.pageNumberLeft = 1

	self:SetSize(950, 650)
	self:Center()
	self:ShowCloseButton(false)
	self:SetTitle("")
	self:SetDraggable(false)
	self.Paint = function() end


	self.image = self:Add("DImage")
	self.image:SetImage("materials/terranova/ui/books/blankbook.png")
	self.image:Dock(FILL)
	self.image:DockMargin(0, 0, 0, 30)

	self.markerLine = self:Add("DPanel")
	self.markerLine:Dock(FILL)
	self.markerLine.Paint = function(slf, pw, ph)
		if self.marker == self.pageNumberLeft then
			surface.SetDrawColor(220, 30, 30)
			surface.DrawRect(pw/2, 10, 5, ph - 55)
		end
	end


	self.close = self:Add("DButton")
	self.close:SetPos(475-100, 620)
	self.close:SetSize(200, 30)
	self.close:SetText("Close")
	self.close.DoClick = function()
		self:Remove()
		PLUGIN.panel = nil
	end

	-- Click functions are set on update pages function.
	self.setMarker = self:Add("DButton")
	self.setMarker:SetPos(50, 620)
	self.setMarker:SetSize(100, 30)
	self.setMarker:SetText("Place Marker")

	self.gotoPage = self:Add("DButton")
	self.gotoPage:SetPos(825, 620)
	self.gotoPage:SetSize(100, 30)
	self.gotoPage:SetText("Go to Page")
	self.gotoPage.DoClick = function()
		if IsValid(self.gotoPage.pnl) then return end
		
		self.gotoPage.pnl = vgui.Create("DFrame", self)
		self.gotoPage.pnl:SetSize(200, 100)
		self.gotoPage.pnl:Center()
		self.gotoPage.pnl:SetTitle("")

		local label = self.gotoPage.pnl:Add("DLabel")
		label:Dock(TOP)
		label:DockMargin(40, 0, 0, 0)
		label:SetText("Enter the Page Number")
		label:SizeToContents()

		local inputField = self.gotoPage.pnl:Add("DTextEntry")
		inputField:SetNumeric(true)
		inputField:Dock(TOP)
		inputField:DockMargin(20, 5, 20, 0)

		local gotoButton = self.gotoPage.pnl:Add("DButton")
		gotoButton:Dock(TOP)
		gotoButton:SetSize(0, 20)
		gotoButton:SetText("Go")
		gotoButton:DockMargin(80, 5, 80, 0)
		gotoButton.DoClick = function()
			local targetPage = tonumber(inputField:GetText())
			if targetPage != nil then
				if targetPage > 300 then
					targetPage = 300
				end

				if targetPage < 1 then
					targetPage = 1
				end

				targetPage = targetPage % 2 == 1 and targetPage or targetPage-1
				self.pageNumberLeft = targetPage
				self:UpdatePages()
				self.gotoPage.pnl:Close()
			end

		end
	 end

	self.pageLeft = CreateDTextEntry(self, 55, 55)
	self.pageRight = CreateDTextEntry(self, 510, 55)

	self.pageLabelLeft = CreatePageNumber(self, 230, 540)
	self.pageLabelLeft:SetText(self.pageNumberLeft)

	self.pageLabelRight = CreatePageNumber(self, 680, 540)
	self.pageLabelRight:SetText(self.pageNumberLeft + 1)

	self.nextPageBtn = CreatePageChangeButton(self, "->", 850, 560)
	self.nextPageBtn.DoClick = function()
		self:SaveCurrentPages()
		self.pageNumberLeft = self.pageNumberLeft + 2
		self:UpdatePages()
	end

	self.previousPageBtn = CreatePageChangeButton(self, "<-", 70, 560)
	self.previousPageBtn.DoClick = function()
		self:SaveCurrentPages()
		self.pageNumberLeft = self.pageNumberLeft - 2
		self:UpdatePages()
	end

	self:MakePopup()
	PLUGIN.panel = self
end

function PANEL:UpdatePages()

	local text = self.textArray
	self.previousPageBtn:SetDisabled(self.pageNumberLeft == 1)
	self.nextPageBtn:SetDisabled(#text < self.pageNumberLeft + 2 and (#text >= self.pageNumberLeft + 2 or !self.Editing))

	self.pageLabelLeft:SetText(self.pageNumberLeft)
	self.pageLabelRight:SetText(self.pageNumberLeft + 1)

	self.pageLeft:SetText(text[self.pageNumberLeft] or "")
	self.pageRight:SetText(text[self.pageNumberLeft + 1] or "")

	self:UpdateMarkerButton()

end

function PANEL:UpdateMarkerButton()

	if self.pageNumberLeft == self.marker then
		self.setMarker:SetText("Remove Marker")
		self.setMarker.DoClick = function()
			self.marker = -1
			netstream.Start("ixSaveBookChanges", self:GetItemID(), nil, true, -1)
			self:UpdateMarkerButton()
		end
	else
		self.setMarker:SetText("Place Marker")
		self.setMarker.DoClick = function()
			self.marker = self.pageNumberLeft
			netstream.Start("ixSaveBookChanges", self:GetItemID(), nil, true, self.marker)
			self:UpdateMarkerButton()
		end
	end
end

function PANEL:SetEditMode(isEditing)
	self.Editing = isEditing
	self.pageLeft:SetEditable(isEditing)
	self.pageRight:SetEditable(isEditing)

	if isEditing then
		self.close.DoClick = function()
			self.textArray[self.pageNumberLeft] = self.pageLeft:GetText()
			self.textArray[self.pageNumberLeft + 1] = self.pageRight:GetText()
			netstream.Start("ixSaveBookChanges", self:GetItemID(), self.textArray)
			
			self:Remove()
			PLUGIN.panel = nil
		end
	end

	self.close:SetText(isEditing and "Save&Close" or "Close")
end

function PANEL:SaveCurrentPages()
	self.textArray[self.pageNumberLeft] = self.pageLeft:GetText() == "" and "" or self.pageLeft:GetText()
	self.textArray[self.pageNumberLeft + 1] = self.pageRight:GetText() == "" and "" or self.pageRight:GetText()
end

function PANEL:OnRemove()
	PLUGIN.panel = nil
end

vgui.Register("ixBook", PANEL, "DFrame")
