--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {}

function PANEL:Init()
	local size = 120
	self:SetSize(size, size * 1.4)
end

function PANEL:SetItem(itemTable)
	self.itemName = L(itemTable.name):lower()

	self.name = self:Add("DLabel")
	self.name:Dock(TOP)
	self.name:SetText(itemTable.GetName and itemTable:GetName() or L(itemTable.name))
	self.name:SetContentAlignment(5)
	self.name:SetTextColor(color_white)
	self.name:SetFont("ixSmallFont")
	self.name:SetExpensiveShadow(1, Color(0, 0, 0, 200))
	self.name.Paint = function(this, w, h)
		surface.SetDrawColor(0, 0, 0, 75)
		surface.DrawRect(0, 0, w, h)
	end

	self.icon = self:Add("SpawnIcon")
	self.icon:SetZPos(1)
	self.icon:SetSize(self:GetWide(), self:GetWide())
	self.icon:Dock(FILL);
	self.icon:DockMargin(5, 5, 5, 10)
	self.icon:InvalidateLayout(true)
	self.icon:SetModel(itemTable:GetModel(), itemTable:GetSkin())
	self.icon:SetHelixTooltip(function(tooltip)
		ix.hud.PopulateItemTooltip(tooltip, itemTable)
	end)
	self.icon.itemTable = itemTable
	self.icon.DoClick = function(this)
		if (!IsValid(ix.gui.checkout) and (this.nextClick or 0) < CurTime()) then
			ix.gui.armory:BuyItem(itemTable.uniqueID)

			surface.PlaySound("buttons/button14.wav")
			this.nextClick = CurTime() + 0.5
		end
	end
	self.icon.PaintOver = function(this)
		if (itemTable and itemTable.PaintOver) then
			local w, h = this:GetSize()

			itemTable.PaintOver(this, itemTable, w, h)
		end
	end

	if ((itemTable.iconCam and !ICON_RENDER_QUEUE[itemTable.uniqueID]) or itemTable.forceRender) then
		local iconCam = itemTable.iconCam
		iconCam = {
			cam_pos = iconCam.pos,
			cam_fov = iconCam.fov,
			cam_ang = iconCam.ang,
		}
		ICON_RENDER_QUEUE[itemTable.uniqueID] = true

		self.icon:RebuildSpawnIconEx(
			iconCam
		)
	end
end

vgui.Register("ixArmoryItem", PANEL, "DPanel")

local PANEL = {}

function PANEL:Init(logs)
	ix.gui.armory = self
	self.stagePanels = {}
	self.cart = {}
	self.armoryLog = {};

    self:SetSize(720, 480)
    self:Center()
    self:MakePopup()
	self:SetTitle("");
	self:ShowCloseButton( false )
end

function PANEL:Paint()
	ix.util.DrawBlur(self, 15, nil, 200)
end;

-- Called each frame.
function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();

	self:SetSize(720, 480);
	self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) );

	if(self.cart[1]) then
		ix.gui.armory.checkoutButton:SetEnabled(true);
	else
		ix.gui.armory.checkoutButton:SetEnabled(false);
	end;

	self.checkout:SetText(L("checkout", self:GetCartCount() or 0))
end;

function PANEL:Populate()
	self.headerText = self:Add("DLabel")
    self.headerText:SetContentAlignment(5)
    self.headerText:Dock(TOP)
    self.headerText:SetText("<:: Civil Protection Armory ::>")
    self.headerText:SetExpensiveShadow(2)
    self.headerText:SetFont("BudgetLabel")
	self.headerText:SetTall(16)

	self.descriptionText = self:Add("DLabel")
	self.descriptionText:SetContentAlignment(5)
	self.descriptionText:Dock(TOP)
	self.descriptionText:SetExpensiveShadow(2)
	self.descriptionText:SetFont("BudgetLabel")
	self.descriptionText:SetTall(32)

	-- Browse Panel --
	self.browsePanel = self:AddStagePanel("browse")
	self.browsePanel.OnSetActive = function() 
		ix.gui.armory.descriptionText:SetText("Select an item you wish to obtain. All transactions are logged.");
	end;
		self.scroll = self.browsePanel:Add("DPanelList")
		self.scroll:Dock(FILL)
		self.scroll:EnableVerticalScrollbar();

		self.itemList = self.scroll:Add("DIconLayout")
		self.itemList:Dock(TOP)
		self.itemList:DockMargin(10, 1, 5, 5)
		self.itemList:SetSpaceX(10)
		self.itemList:SetSpaceY(10)
		self.itemList:SetMinimumSize(128, 400)
		
		for uniqueID, itemTable in SortedPairsByMemberValue(ix.item.list, "name") do
			if (itemTable.cpArmory == true) then
				self.itemList:Add("ixArmoryItem"):SetItem(itemTable)
			end
		end

		self.bottomDock = self.browsePanel:Add("DPanel")
		self.bottomDock:Dock(BOTTOM)
		
		self.viewLogs = self.bottomDock:Add("DButton")
		self.viewLogs:Dock(LEFT)
		self.viewLogs:SetText("View Logs")
		self.viewLogs:SetSize(self:GetWide() / 3, self:GetTall())
		self.viewLogs:SetEnabled(false);

		if(ix.gui.armory.armoryLog[1]) then
			self.viewLogs:SetEnabled(true);
		end;

		self.checkout = self.bottomDock:Add("DButton")
		self.checkout:Dock(FILL)
		self.checkout:SetText("Submit")
		ix.gui.armory.checkoutButton = self.checkout;
		
		self.exitButton = self.bottomDock:Add("DButton")
		self.exitButton:Dock(RIGHT)
		self.exitButton:SetText("Exit")
		self.exitButton:SetSize(self:GetWide() / 3, self:GetTall())
		
		function self.viewLogs:DoClick()
			ix.gui.armory:SetActivePanel("logs");
			--LocalPlayer():Notify("You don't have the appropriate access level to do that!")
		end
		
		function self.checkout:DoClick()
			ix.gui.armory:SetActivePanel("checkout");
		end;

		function self.exitButton:DoClick()
			ix.gui.armory:Close();
		end;

	-- Logs Panel --
	self.logsPanel = self:AddStagePanel("logs")
		self.logs = self.logsPanel:Add("DScrollPanel")
		self.logs:Dock(FILL)
		self.logs.Paint = function(this, w, h)
			surface.SetDrawColor(0, 0, 0, 100)
			surface.DrawRect(0, 0, w, h)
		end
		self.logs:DockMargin(0, 0, 0, 4)

		self.logsPanel.OnSetActive = function() 
			ix.gui.armory.descriptionText:SetText("These are the access logs of units for this terminal, for the past week.");

			self.logs:Clear();

			for k, v in ipairs(self.armoryLog) do
				local slot = self.logs:Add("DPanel")
				slot:SetTall(72)
				slot:Dock(TOP)
				slot:DockMargin(5, 5, 5, 0)

				slot.icon = slot:Add("SpawnIcon")
				slot.icon:SetPos(2, 2)
				slot.icon:SetSize(64, 64)
				slot.icon:SetTooltip()
				slot.icon:SetModel("models/newcca/cca_unit.mdl");
				slot.icon:Dock(LEFT)

				slot.date = slot:Add("DLabel")
				slot.date:SetPos(60, 2)
				slot.date:SetFont("BudgetLabel")
				slot.date:SetExpensiveShadow(1, Color(0, 0, 0, 200))
				slot.date:SetText(self.armoryLog[k].time)
				slot.date:SetTextColor(color_white)
				slot.date:SizeToContents()

				slot.log = slot:Add("DLabel")
				slot.log:SetPos(60, 25)
				slot.log:SetFont("BudgetLabel")
				slot.log:SetExpensiveShadow(1, Color(0, 0, 0, 200))
				slot.log:SetText(self.armoryLog[k].log)
				slot.log:SetTextColor(color_white)
				slot.log:SizeToContents()

				slot.reason = slot:Add("DLabel")
				slot.reason:SetPos(60, 40)
				slot.reason:SetFont("BudgetLabel")
				slot.reason:SetExpensiveShadow(1, Color(0, 0, 0, 200))
				slot.reason:SetText(self.armoryLog[k].reason)
				slot.reason:SetTextColor(color_white)
				slot.reason:SizeToContents()
			end
			
		end;

		self.bottomDock = self.logsPanel:Add("DPanel")
		self.bottomDock:Dock(BOTTOM)
		
		self.backButton = self.bottomDock:Add("DButton")
		self.backButton:Dock(RIGHT)
		self.backButton:SetText("Back")
		self.backButton:SetSize(self:GetWide() / 3, self:GetTall())

		function self.backButton:DoClick()
			ix.gui.armory:SetActivePanel("browse");
		end;

	-- Checkout panel --
	self.checkoutPanel = self:AddStagePanel("checkout")
		self.items = self.checkoutPanel:Add("DScrollPanel")
		self.items:Dock(FILL)
		self.items.Paint = function(this, w, h)
			surface.SetDrawColor(0, 0, 0, 100)
			surface.DrawRect(0, 0, w, h)
		end
		self.items:DockMargin(0, 0, 0, 4)

		self.checkoutPanel.OnSetActive = function() 
			ix.gui.armory.descriptionText:SetText(string.format("This is the list of items you have selected. You have %s items selected.", self:GetCartCount()));

			self.items:Clear();

			-- We know theres atleast 1 object in the array, otherwise we wouldn't be here.
			local i = 1;

			for k, v in SortedPairs(self.cart) do
				local itemTable = ix.item.list[self.cart[k].uniqueID];
				local slot = self.items:Add("DPanel")
				slot:SetTall(72)
				slot:Dock(TOP)
				slot:DockMargin(5, 5, 5, 0)

				slot.icon = slot:Add("SpawnIcon")
				slot.icon:SetPos(2, 2)
				slot.icon:SetSize(64, 64)
				slot.icon:SetModel(itemTable:GetModel())
				slot.icon:SetTooltip()
				slot.icon:Dock(LEFT)
				slot.icon:SetHelixTooltip(function(tooltip)
					ix.hud.PopulateItemTooltip(tooltip, itemTable)
				end)

				slot.name = slot:Add("DLabel")
				slot.name:SetPos(8, 2)
				slot.name:SetFont("ixSmallFont")
				slot.name:SetExpensiveShadow(1, Color(0, 0, 0, 200))
				slot.name:SetText(L(itemTable.GetName and itemTable:GetName() or L(itemTable.name)))
				slot.name:SetTextColor(color_white)
				slot.name:SizeToContents()
				slot.name:Dock(LEFT)

				slot.delete = slot:Add("DButton")
				slot.delete:SetText("X");
				slot.delete:SetSize(64, self:GetTall())
				slot.delete:DockMargin(4, 4, 4, 4)
				slot.delete:Dock(RIGHT)
				slot.delete.id = i;

				function slot.delete:DoClick()
					table.remove(ix.gui.armory.cart, self.id);
					slot:Remove();

					if(!ix.gui.armory.cart[1]) then
						ix.gui.armory:SetActivePanel("browse");
					end;
				end;

				i=i+1;
			end
		end;

		self.bottomDock = self.checkoutPanel:Add("DPanel")
		self.bottomDock:Dock(BOTTOM)

		self.backButton = self.bottomDock:Add("DButton")
		self.backButton:Dock(LEFT)
		self.backButton:SetText("Back")
		self.backButton:SetSize(self:GetWide() / 3, self:GetTall())
		
		self.exitButton = self.bottomDock:Add("DButton")
		self.exitButton:Dock(RIGHT)
		self.exitButton:SetText("Exit")
		self.exitButton:SetSize(self:GetWide() / 3, self:GetTall())

		self.submitDock = self.checkoutPanel:Add("DPanel")
		self.submitDock:Dock(BOTTOM)

		self.reasonText = self.submitDock:Add("DLabel")
		self.reasonText:DockMargin(5, 0, 0, 0)
		self.reasonText:SetSize(45, self:GetTall())
		self.reasonText:SetText("Reason: ")
		self.reasonText:SetTextColor(color_white)
		self.reasonText:Dock(LEFT)

		self.reasonTextEntry = self.submitDock:Add("DTextEntry")
		self.reasonTextEntry:SetText("No reason specified")
		self.reasonTextEntry:Dock(FILL)
		self.reasonTextEntry:DockMargin(4, 4, 4, 4)
		self.reasonTextEntry:SetContentAlignment(5)
		ix.gui.armory.reasonTextEntry = self.reasonTextEntry;

		self.finishButton = self.submitDock:Add("DButton")
		self.finishButton:Dock(RIGHT)
		self.finishButton:SetText("Finish")
		self.finishButton:SetSize(self:GetWide() / 3, self:GetTall())

		function self.backButton:DoClick()
			ix.gui.armory:SetActivePanel("browse");
		end;

		function self.exitButton:DoClick()
			ix.gui.armory:Close();
		end;

		function self.finishButton:DoClick()
			data = {
				reason = ix.gui.armory.reasonTextEntry:GetText(),
				cart = ix.gui.armory.cart
			}

			net.Start("ixArmoryBuy")
				net.WriteTable(data)
			net.SendToServer()

			ix.gui.armory:Close();
		end;
	self:SetActivePanel("browse");
end;

function PANEL:AddStagePanel(name)
	local id = #self.stagePanels + 1;

	local panel = self:Add("DPanel");
	panel:Dock(FILL);
	panel:SetVisible(false);
	panel.OnSetActive = function() end
	panel.Paint = function() end

	self.stagePanels[id] = {}
	self.stagePanels[id].panel = panel;
	self.stagePanels[id].subpanelName = name;

	return panel;
end;

function PANEL:SetActivePanel(name)
	for i = 1, #self.stagePanels do
		if(self.stagePanels[i].subpanelName == name) then
			self.stagePanels[i].panel:SetVisible(true);
			self.stagePanels[i].panel:OnSetActive();
		else
			self.stagePanels[i].panel:SetVisible(false);
		end;
	end;
end;

function PANEL:BuyItem(uid)
	local count = self:GetCartCount() + 1;
	self.cart[count] = {
		uniqueID = uid
	}
end

function PANEL:GetCartCount()
	local count = 0

	for _, v in pairs(self.cart) do
		count = count + 1;
	end

	return count;
end

vgui.Register("ixCPArmory", PANEL, "DFrame")

netstream.Hook("OpenCPArmory", function(data)
	local armory = vgui.Create("ixCPArmory");
	armory.armoryLog = data;
	armory:Populate();
end)