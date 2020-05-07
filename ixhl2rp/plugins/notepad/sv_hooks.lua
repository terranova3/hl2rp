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

		entity:SetModel(v.model)
		entity:SetSolid(SOLID_BBOX)
		entity:PhysicsInit(SOLID_BBOX)

		if (IsValid(entity)) then
			entity:SetText(v.text);
			entity:SetCharacter(v.character);
		end;

		local physObj = entity:GetPhysicsObject()

		if (!v.moveable) then
			if (IsValid(physObj)) then
				physObj:EnableMotion(false)
				physObj:Sleep()
			end;
		end;
	end
end

-- Called just after data should be saved.
function PLUGIN:SaveData()
	local data = {};
	
	for _, entity in pairs(ents.FindByClass("ix_notepad")) do
		local physObj = entity:GetPhysicsObject();
		local moveable;
		
		if (IsValid(physObj)) then
			moveable = physObj:IsMoveable();
		end;
		
		data[#data + 1] = {
			pos = entity:GetPos(),
			angles = entity:GetAngles(),
			model = entity:GetModel(),
			text = entity.text,
			character = entity.character,
			moveable = moveable,
		};
	end;

	self:SetData(data)
end;