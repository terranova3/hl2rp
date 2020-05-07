include("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
end

-- Called when the entity should draw.
function ENT:Draw()
	self.Entity:DrawModel()
end

-- Called when the entity should think.
function ENT:Think()
    local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		local r, g, b, a = self:GetColor()
		dlight.Pos = self:GetPos()
		dlight.r = 125
		dlight.g = 200
		dlight.b = 255
		dlight.Brightness = 0
		dlight.Size = 800
		dlight.Decay = 5
		dlight.DieTime = CurTime() + 0.1
	end   
end