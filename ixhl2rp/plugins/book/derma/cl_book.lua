
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

// Character count excluding pages that are curently open.
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
		// TRUE to don't allow value.
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
	label:SetSize(40, 60)
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

	self:SetSize(950, 650)
	self:Center()
	self:ShowCloseButton(false)
	self:SetTitle("")
	self:SetDraggable(false)
	self.Paint = function() end
	self.pageNumberLeft = 1

	self.image = self:Add("DImage")
	self.image:SetImage("vgui/blankbook.png")
	self.image:Dock(FILL)


	self.close = self:Add("DButton")
	self.close:Dock(BOTTOM)
	self.close:DockMargin(0, 4, 0, 0)
	self.close:SetText("Close")
	self.close.DoClick = function()
		self:Remove()
		PLUGIN.panel = nil
	end

	self.pageLeft = CreateDTextEntry(self, 55, 55)
	self.pageRight = CreateDTextEntry(self, 510, 55)

	self.pageLabelLeft = CreatePageNumber(self, 250, 540)
	self.pageLabelLeft:SetText(self.pageNumberLeft)

	self.pageLabelRight = CreatePageNumber(self, 700, 540)
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
	self.textArray[self.pageNumberLeft] = self.pageLeft:GetText() == "" and nil or self.pageLeft:GetText()
	self.textArray[self.pageNumberLeft + 1] = self.pageRight:GetText() == "" and nil or self.pageRight:GetText()
end

function PANEL:OnRemove()
	PLUGIN.panel = nil
end

vgui.Register("ixBook", PANEL, "DFrame")
