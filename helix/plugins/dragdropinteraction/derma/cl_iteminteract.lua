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
    print("Here")

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
    local easing = direction == "up" and "outQuint" or "outElastic"
    
    for k, v in pairs(self.options) do
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
            local interact = ix.gui.itemInteract

            -- Don't want to get any clicks on the actual panel.
            if(!interact:IsHovered() and !interact:IsChildHovered()) then
                interact:Destroy()
            end
        end
    end
end

function PANEL:AddOption(k, v)
    local option = self:Add("DButton")
    option:SetText("")
    option:Dock(TOP)
    option:SetTall(24)
    option.Paint = function() 
        if(option:IsHovered()) then
            surface.SetDrawColor(90, 90, 90, 150)
            surface.DrawRect(0, 0, option:GetWide(), option:GetTall())
        end
    
        ix.util.DrawText(L(v.name or k), 24, 4, color_white, 0, 0, "ixSmallFont")
    end
    option.DoClick = function()
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

    if(#self.options < 1) then
        option:DockMargin(6, 6, 6, 0)
    else
        option:DockMargin(6, 0, 6, 0)
    end

    self.icon = option:Add("Material")
    self.icon:SetSize(12, 12)   
    self.icon:SetPos(4, 6)
    self.icon:SetMaterial(v.icon)
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