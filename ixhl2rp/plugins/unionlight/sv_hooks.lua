--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- A function to load the union light.
function PLUGIN:LoadData()
	for k, v in pairs(self:GetData() or {}) do
        local entity = ents.Create("ix_unionlight");
        
		entity:SetAngles(v.angles);
		entity:SetPos(v.position);
		entity:Spawn();
		
		if (!v.moveable) then
			local physicsObject = entity:GetPhysicsObject();
			
			if ( IsValid(physicsObject) ) then
				physicsObject:EnableMotion(false);
			end;
		end;
	end;
end;

-- A function to save the union light.
function PLUGIN:SaveData()
	local data = {};

	for k, v in pairs( ents.FindByClass("ix_unionlight") ) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if ( IsValid(physicsObject) ) then
			moveable = physicsObject:IsMoveable();
		end;
		
		data[#data + 1] = {
			angles = v:GetAngles(),
			position = v:GetPos(),
			moveable = moveable
		};
	end;
	
	self:SetData(data)
end;