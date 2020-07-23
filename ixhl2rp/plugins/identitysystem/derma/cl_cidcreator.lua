local PANEL = {}

function PANEL:Init()
	ix.gui.cidcreator = self

	self:SetSize(ScrW() / 4, 400)
	self:Center()
	self:MakePopup()
	self:SetBackgroundBlur(true)

	self.toptext = self:AddLabel("Identification Registration Center", true)
	self.sourceText = self:AddLabel("Select a data source")

	self.itemswang = self:Add("DComboBox")
	self.itemswang:Dock(TOP)
	self.itemswang:SetValue("Select a source")

	self.characterTitle = self:AddLabel("Character details", true)
	self.nameText = self:AddLabel("Input Name")
	self.nameinput = self:Add("DTextEntry")
	self.nameinput:Dock(TOP)
	self.nameinput:DockMargin(16, 0, 16, 8)

	self.idtext = self:AddLabel("Input ID")
	self.idinput = self:Add("DTextEntry")
	self.idinput:Dock(TOP)
	self.idinput:DockMargin(16, 0, 16, 8)
	self.idinput:SetUpdateOnType(true)
	self.idinput:SetNumeric(true)

	self.nameText = self:AddLabel("Employment", true)
	self.occupationText = self:AddLabel("Occupation name")
	self.occupationInput = self:Add("DTextEntry")
	self.occupationInput:Dock(TOP)
	self.occupationInput:DockMargin(16, 0, 16, 8)

	self.wageText = self:AddLabel("Input Wage")
	self.wageInput = self:Add("DNumberWang")
	self.wageInput:Dock(TOP)
	self.wageInput:DockMargin(16,0,16,8)
	self.wageInput:SetMin(0)
	self.wageInput:SetMax(100)

	for k, v in pairs(LocalPlayer():GetCharacter():GetInventory():GetItems()) do
		if(v.uniqueID == "transfer_papers" or v.uniqueID == "cid") then
			local name = "ID"

			if(v.uniqueID == "transfer_papers") then
				name = "TRANSFER"
			end

			self.itemswang:AddChoice(string.format("%s - %s", name, v:GetData("citizen_name", "error")), {v})
		end
	end

	function self.idinput:Think()
		local text = self:GetValue();
		
		if (string.len(text) > 5) then
			self:SetValue( string.sub(text, 0, 5) );
			ix.gui.cidcreator.nameinput:RequestFocus()

			surface.PlaySound("common/talk.wav");
		end;
	end;

	self.itemswang.OnSelect = function(self, index, value, data)
		local item = data[1]

		ix.gui.cidcreator.nameinput:SetText(item:GetData("citizen_name", "error"))
		ix.gui.cidcreator.idinput:SetValue(item:GetData("cid", 99999))
		ix.gui.cidcreator.occupationInput:SetText(item:GetData("occupation", ""))
		ix.gui.cidcreator.wageInput:SetValue(item:GetData("salary", 0))
		ix.gui.cidcreator.item = item
	end

	self.submitbutton = self:Add("DButton")
	self.submitbutton:Dock(BOTTOM)
	self.submitbutton:SetText("Submit")

	self:InvalidateLayout(true)
	self:SizeToChildren(false, true)

	function self.submitbutton:DoClick()
		if(!string.len(ix.gui.cidcreator.idinput:GetText()) == 5) then
			LocalPlayer():Notify("The CID must contain 5 digits.")
			return
		end

		local data = {
			ix.gui.cidcreator.nameinput:GetText(),
			ix.gui.cidcreator.idinput:GetText(),
			ix.gui.cidcreator.occupationInput:GetText(),
			ix.gui.cidcreator.wageInput:GetValue()
		}

		if(ix.gui.cidcreator.item) then
			table.insert(data, ix.gui.cidcreator.item.id)
		end

		netstream.Start("SubmitNewCID", data)

		ix.gui.cidcreator:Remove()
	end
end

function PANEL:AddLabel(text, colored)
	local label = self:Add("DLabel")
	label:SetContentAlignment(5)
	label:Dock(TOP)
	label:SetText(text)
	label:SetExpensiveShadow(2)
	label:SetFont("ixSmallFont")

    if(colored) then
        label:SetTextColor(ix.config.Get("color"))
	end
	
	return label
end

vgui.Register("ixCIDCreater", PANEL, "DFrame")