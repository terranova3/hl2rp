--[[
	© 2017 Terra Nova do not use, share, re-distribute or modify without 
	permission of its author(zacharyenriquee@gmail.com) (Adolphus). 
--]]
include("shared.lua")

local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
local color_green = Color(0, 255, 0, 255)
local color_red = Color(255, 50, 50, 255)

function ENT:Draw()
	self:DrawModel()

	local color = color_green

	if (self:GetDisplayError()) then
		color = color_red
	elseif (self:GetLocked()) then
		color = color_red
	end

	local position = self:GetPos() + self:GetUp() * 2 + self:GetForward() * -2.85 + self:GetRight() * 2.245

	render.SetMaterial(glowMaterial)
	render.DrawSprite(position, 3, 3, color)
end