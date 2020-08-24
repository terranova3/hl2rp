include("shared.lua");

function ENT:Think()
	local dlight = DynamicLight( self:EntIndex() );
	
	cam.Start3D( EyePos(), EyeAngles() );
		for k, v in ipairs( player.GetAll() ) do
			if (v:Alive()) then
				if ( dlight and v == self.Owner  ) then
					local lightVector = self:GetPos();							
					lightVector:Add(Vector(0,2,0));
					
					dlight.Pos = lightVector;
					dlight.r = 30;
					dlight.g = 255;
					dlight.b = 30;
					dlight.Brightness = 0;
					dlight.Size = 700;
					dlight.Decay = 5;
					dlight.DieTime = CurTime() + 0.1;
				end;
			end;
		end;
	cam.End3D();
end;