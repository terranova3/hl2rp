include("shared.lua")

local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
local statusColors={
	Color(0,255,0),
	Color(255,0,0),
	Color(180,100,0)
}

function ENT:Draw()
	self:DrawModel()

	local status = self:GetNWInt("status", 2)
	local color = statusColors[status]

	local position = self:GetPos() + self:GetForward() * 8 + self:GetUp() * 11 + self:GetRight() * 1
	render.SetMaterial(glowMaterial)
	render.DrawSprite(position, 10, 10, color)
end