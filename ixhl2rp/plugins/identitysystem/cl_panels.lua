
--[[-------------------------------------------------------------------------
			CID CREATOR
		---------------------------------------------------------------------------]]
local PANEL = {}

function PANEL:Init()
	ix.gui.cidcreator = self
	self:SetSize(ScrW() / 4, ScrH() / 7)
	self:Center()
	self:MakePopup()
	self:SetBackgroundBlur(true)
	self.toptext = self:Add("DLabel")
	self.toptext:SetContentAlignment(5)
	self.toptext:Dock(TOP)
	self.toptext:SetText("Automatic Registration Center")
	self.toptext:SetExpensiveShadow(2)
	self.toptext:SetFont("ixSmallFont")
	self.toptext:SetTall(32)
	self.nametext = self:Add("DLabel")
	self.nametext:SetContentAlignment(5)
	self.nametext:Dock(TOP)
	self.nametext:SetText("Input Name")
	self.nametext:SetExpensiveShadow(2)
	self.nametext:SetFont("ixSmallFont")
	self.nameinput = self:Add("DTextEntry")
	self.nameinput:Dock(TOP)
	self.itemswang = self:Add("DComboBox")
	self.itemswang:Dock(BOTTOM)
	self.itemswang:SetValue("Or select a transfer card.")

	self.itemswang.OnSelect = function()
		self.nameinput:SetDisabled(true)
		self.nameinput:SetText("")
	end

	self.submitbutton = self:Add("DButton")
	self.submitbutton:Dock(BOTTOM)
	self.submitbutton:SetText("Submit")

	for k, v in pairs(LocalPlayer():GetCharacter():GetInventory():GetItems()) do
		if v.uniqueID == "transfer_papers" then
			self.itemswang:AddChoice(v:GetData("citizen_name", "no name?????"))
		end
	end

	function self.submitbutton:DoClick()
		if string.len(ix.gui.cidcreator.nameinput:GetText()) == 0 and not ix.gui.cidcreator.itemswang:GetSelected() then
			return
		end

		if string.len(ix.gui.cidcreator.nameinput:GetText()) > 1 then
			netstream.Start("SubmitNewCID", {ix.gui.cidcreator.nameinput:GetText()})
			ix.gui.cidcreator:Close()
		elseif ix.gui.cidcreator.itemswang:GetSelected() ~= "Or select a transfer card." then
			netstream.Start("SubmitNewCID", {ix.gui.cidcreator.itemswang:GetSelected()})
			ix.gui.cidcreator:Close()
		else
			LocalPlayer():Notify("You need to input a name or select a transfer card!")
		end
	end
end

vgui.Register("ixCIDCreater", PANEL, "DFrame")