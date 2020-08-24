local PLUGIN = PLUGIN

local tickmat = Material("terranova/ui/medical/tickmat.png")
local damagepanel = Material("terranova/ui/medical/damagepanel.png")
local brokenmat = Material("terranova/ui/medical/fracture.png")

function PLUGIN:HUDPaintBackground()
    local character = LocalPlayer():GetCharacter()

    if(!character) then
        return
    end

    local hasFracture, fractures = character:GetFractures()
    local height = ScrH()
    local currentWidth = 4

    if(hasFracture) then
        surface.SetMaterial(brokenmat)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(currentWidth, height - 28, 24, 24)
        
        ix.util.DrawText(#fractures, currentWidth + 13.5, height - 40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, 1)
        
        currentWidth = currentWidth + 27
    end
end

function PLUGIN:HUDPaint()
    local client = LocalPlayer()

    local maxHealth = client:GetMaxHealth()
    local health = client:Health()

    if(health < (maxHealth/2)) then
        local scrW, scrH = ScrW(), ScrH();
        local damageFraction = 1 - ((1 / maxHealth) * health)

        surface.SetDrawColor(255, 255, 255, math.Clamp(255 * damageFraction, 0, 255))
        surface.SetMaterial(Material("terranova/ui/medical/screendamage.png"))
        surface.DrawTexturedRect(0, 0, scrW, scrH)
    end
end

local PANEL = {}
local body = "terranova/ui/medical/body.png"
local limbs = {
    [1] = "terranova/ui/medical/head.png",
    [6] = "terranova/ui/medical/left_leg.png",
    [4] = "terranova/ui/medical/left_arm.png",
    [7] = "terranova/ui/medical/right_leg.png",
    [5] = "terranova/ui/medical/right_arm.png",
    [2] = "terranova/ui/medical/chest.png"
}

function PANEL:Init()
    self.scale = 1

    self:SetSize(405, 699)
    self:SetMaterial(body)
    self.AutoSize = false
end

function PANEL:SetScale(scale)
    self.scale = scale

    self:SetSize(405 * self.scale, 699 * self.scale)
end

function PANEL:PaintOver(intW, intH)
    for id = 1, #limbs do
        if (id == 3) then continue end
        self:DrawDamagedLimb(id)
    end
end

function PANEL:DrawDamagedLimb(intLimbID)
    limbname = intLimbID

    if (ix.limb.GetHealthPercentage(LocalPlayer(), limbname, true)) < 100 then
        local icon = limbs[intLimbID]
        surface.SetMaterial(Material(icon))
        surface.SetDrawColor(hook.Run("GetLimbAlp"))
        surface.DrawTexturedRect(0, 0, 405 * self.scale, 699 * self.scale) -- # 505, 699
    end	
end

hook.Add("GetLimbAlp", "LimbAlpha", function()
    local limbperc = ix.limb.GetHealthPercentage(LocalPlayer(), limbname, true)
    local limbalp = 255
    if (limbperc) then
        limbalp = limbalp - (255 * (limbperc / 100))
    end

    return Color(255,255,255,limbalp)
end)

vgui.Register("ixLimbPicture", PANEL, "Material")

local PANEL = {}

function PANEL:Init()
    self:SetSize(505, 699)
    self.body = vgui.Create( "ixLimbPicture", self )
end

local inst = { -- # I like micro-ops.
    [1] = {300, 56},
    [2] = {204, 148},
    [3] = {0, 0},
    [4] = {374, 288},
    [5] = {34, 233},
    [6] = {334, 429},
    [7] = {56, 426}
}

function PANEL:Paint()
	derma.SkinFunc("PaintCategoryPanel", self, "", ix.config.Get("color") or color_white)
	surface.SetDrawColor(0, 0, 0, 50);	

	surface.SetFont("ixPluginTooltipFont")
	surface.SetTextColor(Color(255,255,255,255))
	surface.SetTextPos(4, 4)
	surface.DrawText("Medical")
end;

function PANEL:PaintOver(intW, intH)
    for k = 1, #inst do
        if (k == 3) then continue end
        self:DrawDamagePanel(k, inst[k][1], inst[k][2])
    end
end

function PANEL:Think()
    self:MoveToFront()
end

local defaultFont = font
local font = "ixSmallFont"
local defColor = Color(255, 255, 255, 255)

function PANEL:DrawDamagePanel(intLimbID, dpW, dpH)
    local character = LocalPlayer():GetCharacter()
    local dlimbname = intLimbID
    local maxHealth = ix.limb.GetHitgroup(dlimbname).maxHealth
    local dlimbname1 = ix.limb.GetName(intLimbID)
    local tick = math.Clamp(ix.limb.GetHealthFlip(character, dlimbname), 1, maxHealth) / maxHealth
    local isFractured = ix.limb.HasFracture(character, intLimbID)

    surface.SetMaterial(tickmat)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(dpW + 2, dpH + 22, 121 * tick, 10)

    surface.SetMaterial(damagepanel)
    surface.SetDrawColor(color_white)
    surface.DrawTexturedRect(dpW, dpH, 126, 33)

    draw.SimpleText(dlimbname1, font, dpW + 10, dpH + 10, defColor, TEXT_ALIGN_CENTER + 2, TEXT_ALIGN_CENTER)
    draw.SimpleText(ix.limb.GetHealthFlip(character, dlimbname).." / "..maxHealth, defaultFont, dpW + 60, dpH + 26, defColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

    if isFractured then
        surface.SetMaterial(brokenmat)
        surface.SetDrawColor(color_white)
        surface.DrawTexturedRect(dpW, dpH + 35, 24, 24)
        
        dpW = dpW + 27
    end
end

vgui.Register("ixLimbPanel", PANEL, "DPanel")
