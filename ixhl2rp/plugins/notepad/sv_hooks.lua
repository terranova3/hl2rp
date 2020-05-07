--[[
	� 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

local PLUGIN = PLUGIN;

-- Called when HELIX is loading all the data that has been saved.
function PLUGIN:LoadData()
	for _, v in ipairs(self:GetData() or {}) do
		local entity = ents.Create("ix_notepad")
		entity:SetPos(v.pos)
		entity:SetAngles(v.angles)
		entity:Spawn()

		if (IsValid(entity)) then
			entity:SetText(v.text);
		end;

		if (!v.moveable) then
			local physicsObject = entity:GetPhysicsObject();
			
			if (IsValid(physicsObject)) then
				physicsObject:EnableMotion(false);
			end;
		end;

		entity:SetModel(v.model)
		entity:SetSolid(SOLID_BBOX)
		entity:PhysicsInit(SOLID_BBOX)
	end
end

-- Called just after data should be saved.
function PLUGIN:SaveData()
	local data = {};
	
	for k, v in pairs( ents.FindByClass("ix_notepad") ) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if (IsValid(physicsObject)) then
			moveable = physicsObject:IsMoveable();
		end;
		
		data[#data + 1] = {
			key = v.key,
			text = v.text,
			pos = entity:GetPos(),
			angles = entity:GetAngles(),
			model = entity:GetModel(),
			moveable = moveable,
			uniqueID = v.uniqueID,
		};
	end;

	self:SetData(data)
end;