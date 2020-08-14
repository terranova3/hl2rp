local PANEL = {}
local PLUGIN = PLUGIN

function GetIndex(item)
	local cur = 1
	local text = item:GetData("paygrade", "Unemployed")

	for k, v in pairs(PLUGIN.paygrades) do
		if(k == text) then
			return cur
		end

		cur = cur + 1
	end

	return cur
end

function PANEL:Init()
	ix.gui.cidcreator = self

	self:SetSize(ScrW() / 4, 400)
	self:Center()
	self:SetTitle("")
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

	self.idtext = self:AddLabel("Job Title")
	self.jobTitle = self:Add("DTextEntry")
	self.jobTitle:Dock(TOP)
	self.jobTitle:DockMargin(16, 0, 16, 8)

	self.paygrade = self:Add("DComboBox")
	self.paygrade:Dock(TOP)
	self.paygrade:SetValue("Select a paygrade")
	self.paygrade.Think = function()
		if(IsValid(self.paygrade.Menu)) then
			self.paygrade.Menu:SetMaxHeight(120)
		end
	end
	self.paygrade.Paint = function()
        surface.SetDrawColor(125,125,125,5)
        surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	end
	
	for k, v in pairs(PLUGIN.paygrades) do
		self.paygrade:AddChoice(string.format("%s (%s tokens)", k, v), {paygrade = k, salary = v})
	end

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
		local salary = item:GetData("salary", 0)

		ix.gui.cidcreator.nameinput:SetText(item:GetData("citizen_name", "error"))
		ix.gui.cidcreator.idinput:SetValue(item:GetData("cid", 99999))

		if(item:GetData("employment")) then
			ix.gui.cidcreator.jobTitle:SetValue(item:GetData("employment"))
		end

		ix.gui.cidcreator.salary = salary
		ix.gui.cidcreator.paygrade:ChooseOptionID(GetIndex(item))
		ix.gui.cidcreator.item = item
	end

	self.paygrade.OnSelect = function(self, index, value, data)
		ix.gui.cidcreator.paygradeName = data.paygrade
		ix.gui.cidcreator.salary = data.salary
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
			ix.gui.cidcreator.paygradeName or "Unemployed",
			ix.gui.cidcreator.salary or 0
		}

		if(ix.gui.cidcreator.item) then
			data.item = ix.gui.cidcreator.item.id
		end

		if(string.len(ix.gui.cidcreator.jobTitle:GetText()) >= 1) then
			table.insert(data, ix.gui.cidcreator.jobTitle:GetText())
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