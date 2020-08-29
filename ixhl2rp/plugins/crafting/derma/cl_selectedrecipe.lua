--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PANEL = {};

-- Called when this derma is first created.
function PANEL:Init()
    ix.gui.selectedRecipe = self
    
	self:Dock(TOP)
	self:DockMargin(4,4,4,4)
    self:SetTall(128)
    self:SetVisible(false)
end

-- Called when we need to attach a 'recipe' object onto this derma.
function PANEL:SetRecipe(recipe)
    self:Clear()
    self.recipe = recipe

    self.header = self:Add("DPanel")
    self.header:Dock(TOP)
    self.header:DockMargin(2,2,2,2)
    self.header:SetTall(32)

    local item = ix.item.list[recipe:GetFirstResult()]

    self.icon = self.header:Add("SpawnIcon")
    self.icon:InvalidateLayout(true)
    self.icon:Dock(LEFT)
    self.icon:SetSize(32, 32)
	self.icon:DockMargin(2, 2, 2, 2)
	self.icon:SetModel(recipe:GetModel(), recipe:GetSkin())
	self.icon.PaintOver = function(this)
		if (item and item.PaintOver) then
			local w, h = this:GetSize()

			item.PaintOver(this, item, w, h)
		end
	end

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

    self.requirements = self:Add("DLabel")
	self.requirements:Dock(FILL)
    self.requirements:SetContentAlignment(7)
    self.requirements:DockMargin(8, 4, 0, 0)
	self.requirements:SetTextColor(color_white)
    self.requirements:SetFont("ixMenuMiniFont")
    self.requirements:SetText(recipe:GetRequirements() or "Invalid requirements for this recipe.")
end

function PANEL:GetRecipe()
    if(self.recipe) then
        return self.recipe
    end
    
    return nil
end

vgui.Register("ixSelectedRecipe", PANEL, "DPanel")