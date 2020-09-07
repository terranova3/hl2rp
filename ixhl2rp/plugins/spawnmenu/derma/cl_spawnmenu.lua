--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PANEL = {};
local panelWidth = 1296
local panelHeight = 800
local groups = {
	["All"] = {},
	["Consumables"] = {
		"Bread",
		"Australian",
		"Alcohol",
		"Civil-Approved Drinks",
		"Containers",
		"Civil-Approved Food",
		"Non-Approved Drinks",
		"Non-Approved Food",
		"Rations",
	},
	["Clothing"] = {
		"Clothing",
		"Clothing - Contraband",
		"Clothing - MCS",
		"Storage",
	},
	["Weaponry"] = {
		"Melee",
		"Deployables",
		"Weapons",
		"Ammunition"
	},
	["Materials"] = {
		"Contraband",
		"Crafting",
		"Xen",
		"Liquid"
	},
	["Miscellaneous"] = {
		"Medical",
		"Literature",
		"misc",
		"Other",
		"Tools",
		"Utilities"
	},
	["Gamemaster"] = {
		"Blueprint"
	}
}

local function HasCategory(group, text)
	for k, v in pairs(group) do
		if(v == text) then
			return true
		end
	end

	return false
end

-- Called when the panel is initialized.
function PANEL:Init()
    self:SetTitle("Admin Spawn Menu")
	self:SetBackgroundBlur(true);
	self:SetDeleteOnClose(false);
	self:MakePopup()
    self:SetSize(panelWidth, panelHeight)
	
	-- Called when the button is clicked.
	function self.btnClose.DoClick(button)
		self:Close(); 
		self:Remove();
		
		gui.EnableScreenClicker(false);
	end;

	self.topDock = self:Add("DPanel")
	self.topDock:Dock(TOP)
	self.topDock:DockMargin(4,4,4,4)
	self.topDock:SetTall(32)
	
	function self.topDock:Paint(w, h) end

    -- We can't grab the width of a docked panel without first invalidating it's parent.
	self:InvalidateParent(true)

	-- The width is that of the parent panel, with '56' being a static value that won't change with resolution.
	self.actualWidth = self:GetWide()

	self:BuildButtons()
	self:BuildItems()
end;

function PANEL:BuildButtons()
	local parent = self
	self.buttonList = {}

	for k, v in pairs(groups) do
		local button = self.topDock:Add("ixNewButton")
		button:Dock(LEFT)
		button:SetWide(96)
		button:SetText(k)
		button.group = groups[k]

		if(k == "All") then
			button.highlighted = true
		end

		function button:DoClick()
			if(k == "All") then
				parent:BuildItems()
			else
				parent:BuildItems(self.group)
			end

			for k, v in pairs(parent.buttonList) do
				if(v != self) then
					v.highlighted = false
				else
					self.highlighted = true
				end
			end
		end

		function button:PaintOver()
			if(self.highlighted) then
				surface.SetDrawColor(Color(50,50,50,120))
				surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
			end
		end

		table.insert(self.buttonList, button)
	end
end

-- Adding all the recipes for the selected profession into a scroll list.
function PANEL:BuildItems(array)
	if(self.categoryList) then
		self.categoryList:Remove()
	end

	self.categoryList = self:Add("DScrollPanel")
	self.categoryList:Dock(FILL)
	self.categoryList:DockMargin(4,4,4,4)

    categoryPanels = {}

	for k, v in pairs(ix.item.list) do
		if(array) then
			if(HasCategory(array, v.category)) then
				if (!categoryPanels[L(v.category)]) then
					categoryPanels[L(v.category)] = v.category
				end
			end
		else
			if (!categoryPanels[L(v.category)]) then
				categoryPanels[L(v.category)] = v.category
			end
		end
    end

	-- Iterate through all the categories within this profession
	for _, realName in SortedPairs(categoryPanels) do
		local category = vgui.Create("ixCollapsibleCategory", self);
		category:SetTitle(realName)
		category:DockMargin(0, 0, 0, 8)
		category:SetExpanded(0)

		self.categoryList:Add(category)

		local layout = vgui.Create("DIconLayout")
		layout:Dock(TOP)
		layout:DockMargin(4, 14, 4, 4) -- We need this to offset because the title of the collapsible category is bigger than normal
		layout:DockPadding(2,2,2,2)
		layout:SetSpaceX(4)
		layout:SetSpaceY(4)
		layout:SetDrawBackground(false)

		-- Subtracting because of the hard coded margin
		local width = (self.actualWidth - 50) / 3

        for k, v in SortedPairs(ix.item.list) do
            if (v.category) == realName then
                local item = category:Add("DButton")
                item:SetText(v.name)
                item:SetTextColor( Color(255,255,255, 255) )
                item:SetWide(width)
                item.DoClick = function()
                    net.Start("adminSpawnItem")
                    net.WriteString(v.name)
                    net.SendToServer()
                    surface.PlaySound("buttons/button14.wav")
                end

                layout:Add(item)
            end
        end
		
		category:SetContents(layout)
	end

	self:ResumeScroll()
end

function PANEL:ResumeScroll()
	local scrollValue = ix.gui.adminSpawnMenuScroll or 0 -- Localise this value instead of referencing a value that'll change
	local scrollbar = self.categoryList:GetVBar()

	-- AnimateTo is the only method that'll consistantly reach its destination because of InvalidateLayout
	scrollbar:AnimateTo(scrollValue, 0.01, 0)
end

function PANEL:Think()
	local scrW = ScrW();
	local scrH = ScrH();
	
    self:SetSize(panelWidth, panelHeight)
	self:SetPos( (scrW / 2) - (self:GetWide() / 2), (scrH / 2) - (self:GetTall() / 2) );

	if(IsValid(self.categoryList)) then
		ix.gui.adminSpawnMenuScroll = self.categoryList:GetVBar():GetScroll()
	end
end

vgui.Register("ixAdminSpawnMenu", PANEL, "DFrame")

net.Receive("adminSpawnMenu",function()
    vgui.Create("ixAdminSpawnMenu")
end)