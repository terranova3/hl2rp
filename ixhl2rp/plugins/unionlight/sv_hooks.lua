--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- A function to load the union light.
function PLUGIN:LoadData()
	for _, v in ipairs(self:GetData() or {}) do
        local entity = ents.Create("ix_unionlight");
		entity:SetPos(v.pos)
		entity:SetAngles(v.angles)
		entity:Spawn()
		
		entity:SetModel(v.model)
		entity:SetSolid(SOLID_BBOX)
		entity:PhysicsInit(SOLID_BBOX)

		local physObj = entity:GetPhysicsObject();

		if (!v.moveable) then	
			if ( IsValid(physObj) ) then
				physObj:EnableMotion(false)
				physObj:Sleep()
			end;
		end;
	end;
end;

-- A function to save the union light.
function PLUGIN:SaveData()
	local data = {};

	for _, entity in ipairs(ents.FindByClass("ix_unionlight")) do
		local physObj = entity:GetPhysicsObject();
		local moveable;
		
		if (IsValid(physObj)) then
			moveable = physObj:IsMoveable();
		end;
		
		data[#data + 1] = {
			pos = entity:GetPos(),
			angles = entity:GetAngles(),
			model = entity:GetModel(),
			moveable = moveable,
		};
	end;
	
	self:SetData(data)
end;