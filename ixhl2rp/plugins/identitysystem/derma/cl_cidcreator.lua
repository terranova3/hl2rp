local PANEL = {}

function PANEL:Init()
	ix.gui.cidcreator = self

	self:SetSize(ScrW() / 4, 200)
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

	self.idtext = self:Add("DLabel")
	self.idtext:SetContentAlignment(5)
	self.idtext:Dock(TOP)
	self.idtext:SetText("Input ID")
	self.idtext:SetExpensiveShadow(2)
	self.idtext:SetFont("ixSmallFont")
	self.idinput = self:Add("DTextEntry")
	self.idinput:Dock(TOP)
	self.idinput:SetUpdateOnType(true)
	self.idinput:SetNumeric(true)

	function self.idinput:SetRealValue(text)
		self:SetValue(text);
		ix.gui.cidcreator.nameinput:RequestFocus()
	end;

	function self.idinput:Think()
		local text = self:GetValue();
		
		if (string.len(text) > 5) then
			self:SetRealValue( string.sub(text, 0, 5) );
			
			surface.PlaySound("common/talk.wav");
		end;
	end;
	
	self.itemswang = self:Add("DComboBox")
	self.itemswang:Dock(BOTTOM)
	self.itemswang:SetValue("Or select a transfer card.")

	self.itemswang.OnSelect = function(self, index, value)
		ix.gui.cidcreator.nameinput:SetDisabled(true)
		ix.gui.cidcreator.nameinput:SetText("")

		ix.gui.cidcreator.idinput:SetDisabled(true)
		ix.gui.cidcreator.idinput:SetText("")
	end

	self.submitbutton = self:Add("DButton")
	self.submitbutton:Dock(BOTTOM)
	self.submitbutton:SetText("Submit")

	self:InvalidateLayout(true)
	self:SizeToChildren(false, true)

	for k, v in pairs(LocalPlayer():GetCharacter():GetInventory():GetItems()) do
		if v.uniqueID == "transfer_papers" then
			self.itemswang:AddChoice(v:GetData("citizen_name", "error"), v:GetData("cid", 99999))
		end
	end

	function self.submitbutton:DoClick()
		if(!string.len(ix.gui.cidcreator.idinput:GetText()) == 5) then
			LocalPlayer():Notify("The CID must contain 5 digits.")
			return
		end

		local data = {}

		if(ix.gui.cidcreator.itemswang:GetSelected() != nil) then
			local name, id = ix.gui.cidcreator.itemswang:GetSelected()

			data = {
				name,
				id
			}
		else
			data = {
				ix.gui.cidcreator.nameinput:GetText(),
				ix.gui.cidcreator.idinput:GetText()
			}
		end

		netstream.Start("SubmitNewCID", data)

		ix.gui.cidcreator:Remove()
	end
end

vgui.Register("ixCIDCreater", PANEL, "DFrame")