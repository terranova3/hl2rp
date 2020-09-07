--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PANEL = {};

-- Called when this derma is first created.
function PANEL:Init()
    self:SetText("")
    self:SetTall(150)

    self.drawColor = Color(25, 25, 25, 180)
end

-- Called when we need to attach a 'recipe' object onto this derma.
function PANEL:SetRecipe(recipe)
    local parent = self
    self.recipe = recipe

    self.header = self:Add("DButton")
    self.header:SetText("")
    self.header.DoClick = function() parent:DoClick() end
    self.header.OnCursorEntered = function() parent:OnCursorEntered() end
    self.header.OnCursorExited = function() parent:OnCursorExited() end
    self.header:Dock(TOP)
    self.header:DockMargin(2,2,2,2)
    self.header:SetTall(32)
    self.header:SetDrawBackground(false)

    if(recipe:GetMastery()) then
        self.masteryIcon = self.header:Add("Material")
        self.masteryIcon:Dock(RIGHT)
        self.masteryIcon:DockMargin(4, 4, 4, 4)
        self.masteryIcon:SetWide(28)
        self.masteryIcon:SetMaterial("terranova/ui/crafting/icons/" .. recipe:GetProfession() ..".png")
        self.masteryIcon.AutoSize = false
        self.masteryIcon:SetHelixTooltip(function(tooltip)
            local name = tooltip:AddRow("description")
            name:SetText("Mastery")
            name:SetImportant()
            name:SetFont("ixMediumFont")
            name:SizeToContents()

            local description = tooltip:AddRow("description")
            description:SetText("This recipe requires that you have it's profession mastered.")
            description:SetFont("ixPluginTooltipDescFont")
            description:SizeToContents()
        end)
    end
    
    if(recipe:GetBlueprint()) then
        self.blueprintIcon = self.header:Add("Material")
        self.blueprintIcon:Dock(RIGHT)
        self.blueprintIcon:DockMargin(4, 4, 4, 4)
        self.blueprintIcon:SetWide(28)
        self.blueprintIcon:SetMaterial("terranova/ui/crafting/blueprint.png")
        self.blueprintIcon.AutoSize = false
        self.blueprintIcon:SetHelixTooltip(function(tooltip)
            local name = tooltip:AddRow("description")
            name:SetText("Blueprint")
            name:SetImportant()
            name:SetFont("ixMediumFont")
            name:SizeToContents()

            local description = tooltip:AddRow("description")
            description:SetText("This recipe requires that you have a blueprint unlocked.")
            description:SetFont("ixPluginTooltipDescFont")
            description:SizeToContents()
        end)
    end
    
    local item = ix.item.list[recipe:GetFirstResult()]

    if(!item) then
        self:Remove()
        return
    end

    self.icon = self.header:Add("SpawnIcon")
    self.icon:InvalidateLayout(true)
    self.icon:Dock(LEFT)
    self.icon:SetSize(32, 32)
	self.icon:DockMargin(2, 2, 2, 2)
	self.icon:SetModel(recipe:GetModel() or item:GetModel(), recipe:GetSkin() or item:GetSkin())

	if ((item.iconCam and !ICON_RENDER_QUEUE[item.uniqueID]) or item.forceRender) then
		local iconCam = item.iconCam
		iconCam = {
			cam_pos = iconCam.pos,
			cam_fov = iconCam.fov,
			cam_ang = iconCam.ang,
		}
		ICON_RENDER_QUEUE[item.uniqueID] = true

		self.icon:RebuildSpawnIconEx(
			iconCam
		)
    end

	self.name = self.header:Add("DLabel")
	self.name:Dock(FILL)
    self.name:SetContentAlignment(4)
	self.name:SetTextColor(color_white)
	self.name:SetFont("ixMenuButtonFontSmall")
	self.name:SetExpensiveShadow(1, Color(0, 0, 0, 200))
    self.name:SetText(recipe:GetName())

    self.requirementsPanel = self:Add("DButton")
    self.requirementsPanel:SetText("")
    self.requirementsPanel.DoClick = function() parent:DoClick() end
    self.requirementsPanel.OnCursorEntered = function() parent:OnCursorEntered() end
    self.requirementsPanel.OnCursorExited = function() parent:OnCursorExited() end
    self.requirementsPanel:Dock(FILL)
    self.requirementsPanel:SetPaintBackground(false)

    self.requirements = self.requirementsPanel:Add("DLabel")
    self.requirements:Dock(LEFT)
    self.requirements:SetWide(self.actualWidth / 2)
    self.requirements:SetContentAlignment(7)
    self.requirements:DockMargin(8, 4, 0, 0)
	self.requirements:SetTextColor(color_white)
    self.requirements:SetFont("ixRecipeDescription")
    self.requirements:SetText(recipe:GetRequirements() or "Invalid requirements for this recipe.")

    self.tools = self.requirementsPanel:Add("DLabel")
	self.tools:Dock(FILL)
    self.tools:SetContentAlignment(7)
    self.tools:DockMargin(8, 4, 0, 0)
	self.tools:SetTextColor(color_white)
    self.tools:SetFont("ixRecipeDescription")
    self.tools:SetText(recipe:GetTools() or "No tools required.")
end

-- Returns the recipe tied to this panel.
function PANEL:GetRecipe()
    if(self.recipe) then
        return self.recipe
    end
    
    return nil
end

-- Called when the panel has been clicked.
function PANEL:DoClick()
    local client = LocalPlayer()

    if(self:GetRecipe()) then
        local canCraft, error = self.recipe:CanCraft(client)

        if(canCraft) then
            client:NotifyLocalized("Craft success!")

            net.Start("ixRecipeCraft")
                net.WriteString(self.recipe:GetUniqueID())
            net.SendToServer()
        else
            client:NotifyLocalized(error)
        end
    end
end

-- old: using selector
--ix.gui.selectedRecipe:SetVisible(true)
--ix.gui.selectedRecipe:SetRecipe(self:GetRecipe())
            
-- Called when a player's cursor has entered the button.
function PANEL:OnCursorEntered()
    if(self:IsEnabled()) then
        LocalPlayer():EmitSound(unpack({"buttons/button15.wav", 35, 250}))
        self.drawColor = Color(40, 40, 40, 180)
    end
end

-- Called when a player's cursor has exited the button.
function PANEL:OnCursorExited()
    if(self:IsEnabled()) then
        self.drawColor = Color(25, 25, 25, 180)
    end
end

-- Called every frame
function PANEL:Paint()
    if(self:IsEnabled()) then
        surface.SetDrawColor(90, 90, 90, 120)
        surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
        
        surface.SetDrawColor(self.drawColor)
    else
        surface.SetDrawColor(Color(25,25,25,80))
    end

    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register("ixRecipePanel", PANEL, "DButton")