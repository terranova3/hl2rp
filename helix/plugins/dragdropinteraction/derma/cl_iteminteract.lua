--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

local function InventoryAction(action, itemID, invID, data)
	net.Start("ixInventoryAction")
		net.WriteString(action)
		net.WriteUInt(itemID, 32)
		net.WriteUInt(invID, 32)
		net.WriteTable(data or {})
	net.SendToServer()
end

function PLUGIN:CreateItemInteractionMenu(icon, menu, itemTable, inventory)
    local interact = vgui.Create("ixItemInteract")
    interact:Build(itemTable, inventory)

    return true
end

local PANEL = {}

function PANEL:Init()
    self:MakePopup()

    if(IsValid(ix.gui.itemInteract)) then
        ix.gui.itemInteract:Destroy()
    end

    ix.gui.itemInteract = self

    self.options = {}
end

function PANEL:Build(itemTable, inventory)
    self.inventory = inventory
    self.itemTable = itemTable
    self.itemTable.player = LocalPlayer()

    local w = 128
    local x, y = input.GetCursorPos()

    self:SetWide(w)
    self:SetTall(12)

    for k, v in SortedPairs(self.itemTable.functions) do
        if (k == "drop" or (v.OnCanRun and v.OnCanRun(self.itemTable) == false)) then
            continue
        end

        self:AddOption(k, v)
    end

     -- we want drop to show up as the last option
    local info = itemTable.functions.drop

    if (info and info.OnCanRun and info.OnCanRun(self.itemTable) != false) then
        self:AddOption("drop", info)
    end

    local newHeight = self:GetTall()
    local easing = "outElastic"

    for _, _ in pairs(self.options) do
       newHeight = newHeight+24
    end

    self:SetPos(x-(w/2), y-(newHeight/2))

    self.currentHeight = self:GetTall()

	self:CreateAnimation(0.5, {
		target = {currentHeight = newHeight},
		easing = easing,
		Think = function(animation, panel)
			panel:SetTall(panel.currentHeight)
		end
    })
end

function PLUGIN:Move()
    if(input.WasMousePressed(MOUSE_RIGHT) or input.WasMousePressed(MOUSE_LEFT)) then
        if(IsValid(ix.gui.itemInteract)) then
            if(!ix.gui.itemInteract:IsHovered() and !ix.gui.itemInteract:IsChildHovered()) then
                ix.gui.itemInteract:Destroy()
            end
        end
    end
end

function PANEL:AddOption(k, v)
    local textColor = color_white
    local tooltip = nil

    surface.SetFont("ixSmallFont")
    local textWidth, _ = surface.GetTextSize((v.name or k))

    if(self:GetWide() < (textWidth + 48)) then
        self:SetWide(self:GetWide() + ((textWidth + 48) - self:GetWide()))
    end

    if(self.itemTable.suppressed) then
        local isSuppressed, func, tip = self.itemTable.suppressed(self.itemTable, (v.name or k))

        if(isSuppressed and (v.name or k) == func) then
            textColor = Color(120, 120, 120, 180)
            tooltip = tip
        end
    end
    local option = self:Add("DButton")
    option:SetText("")
    option:Dock(TOP)
    option:SetTall(24)
    option.Paint = function()
        if(option:IsHovered()) then
            surface.SetDrawColor(90, 90, 90, 150)
            surface.DrawRect(0, 0, option:GetWide(), option:GetTall())
        end

        ix.util.DrawText(L(v.name or k), 24, 4, textColor, 0, 0, "ixSmallFont")
    end
    option.DoClick = function()
        local send = true

        if (v.OnClick) then
            send = v.OnClick(self.itemTable)
        end

        if (v.sound) then
            surface.PlaySound(v.sound)
        end

        if (send != false) then
            InventoryAction(k, self.itemTable.id, self.inventory)
        end

        self:Destroy()
    end

    if(tooltip != nil) then
        option:SetHelixTooltip(function(panel)
            local title = panel:AddRow("name")
            title:SetText(v.name or k)
            title:SizeToContents()
            title:SetFont("ixPluginTooltipFont")
            title:SetMaxWidth(math.max(title:GetMaxWidth(), ScrW() * 0.5))

            local description = panel:AddRow("description")
            description:SetText(tooltip)
            description:SetFont("ixPluginTooltipDescFont")
            description:SizeToContents()
        end)
    end

    if(#self.options < 1) then
        option:DockMargin(6, 6, 6, 0)
    else
        option:DockMargin(6, 0, 6, 0)
    end

    self.icon = option:Add("Material")
    self.icon:SetSize(12, 12)
    self.icon:SetPos(4, 6)
    self.icon:SetMaterial(v.icon or "icon16/brick.png")
    self.icon.AutoSize = false

    table.insert(self.options, option)
end

function PANEL:Think()
    if(!IsValid(ix.gui.inv1) or (ix.gui.menu and ix.gui.menu.bClosing)) then
        self:Destroy()
    end
end

function PANEL:Destroy()
    self:Remove()
    ix.gui.itemInteract = nil
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(25, 25, 25, 225)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(90, 90, 90, 255)
    surface.DrawOutlinedRect(0, 0, w, h)
end

vgui.Register("ixItemInteract", PANEL, "DPanel")