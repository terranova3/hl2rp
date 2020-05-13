--[[
	© 2017 Terra Nova do not use, share, re-distribute or modify without 
	permission of its author(zacharyenriquee@gmail.com) (Adolphus). 
--]]
local PLUGIN = PLUGIN;

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

ENT.PopulateEntityInfo = true

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/card/keycard_scanner.mdl");
	
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self:SetUseType(SIMPLE_USE)

	self.nextUseTime = 0
	self.ixKeycardTerminal = {}
end;

-- Called when a player attempts to use a tool.
function ENT:CanTool(player, trace, tool)
	return false;
end;

function ENT:SetDoor(door)
	if (!IsValid(door) or !door:IsDoor()) then
		return
	end

	local doorPartner = door:GetDoorPartner()

	self.door = door
	self.door:DeleteOnRemove(self)

	if(door.ixKeycardTerminal == nil) then
		door.ixKeycardTerminal = {}
	end;

	table.insert(door.ixKeycardTerminal, self);
	self.ixKeycardTerminal = door.ixKeycardTerminal;

	if (IsValid(doorPartner)) then
		self.doorPartner = doorPartner
		self.doorPartner:DeleteOnRemove(self)
	end
end

function ENT:GetLockPosition(door, normal)
	local index = door:LookupBone("handle")
	local position = door:GetPos()
	normal = normal or door:GetForward():Angle()

	if (index and index >= 1) then
		position = door:GetBonePosition(index)
	end

	position = position + normal:Forward() * 7.2 + normal:Up() * 10 + normal:Right() * 2

	normal:RotateAroundAxis(normal:Up(), 90)
	normal:RotateAroundAxis(normal:Forward(), 180)
	normal:RotateAroundAxis(normal:Right(), 180)

	return position, normal
end

function ENT:SpawnFunction(client, trace)
	local door = trace.Entity

	if (!IsValid(door) or !door:IsDoor() or IsValid(door.ixLock)) then
		return client:NotifyLocalized("dNotValid")
	end

	local normal = client:GetEyeTrace().HitNormal:Angle()
	local position, angles = self:GetLockPosition(door, normal)

	local entity = ents.Create("ix_keycard_terminal")
	entity:SetPos(trace.HitPos)
	entity:Spawn()
	entity:Activate()
	entity:SetDoor(door)

	return entity
end


function ENT:OnLockChanged(name, bWasLocked, bLocked)
	if (!IsValid(self.door)) then
		return
	end

	if (bLocked) then
		self:EmitSound("buttons/combine_button2.wav")
		self.door:Fire("lock")
		self.door:Fire("close")

		if (IsValid(self.doorPartner)) then
			self.doorPartner:Fire("lock")
			self.doorPartner:Fire("close")
		end
	else
		self:EmitSound("buttons/combine_button7.wav")
		self.door:Fire("unlock")

		if (IsValid(self.doorPartner)) then
			self.doorPartner:Fire("unlock")
		end
	end
end

function ENT:DisplayError()
	self:EmitSound("buttons/combine_button_locked.wav")
	self:SetDisplayError(true)

	timer.Simple(1.2, function()
		if (IsValid(self)) then
			self:SetDisplayError(false)
		end
	end)
end

function ENT:Toggle(client)
	if (self.nextUseTime > CurTime()) then
		return
	end

	if (!client:IsCombine() and client:Team() != FACTION_ADMIN) then
		self:DisplayError()
		self.nextUseTime = CurTime() + 2

		return
	end

	self:SetLocked(!self:GetLocked())
	self.nextUseTime = CurTime() + 2

	for i = 1, #self.ixKeycardTerminal do
		self.ixKeycardTerminal[i]:SetLocked(self:GetLocked());
	end;
end

function ENT:Use(client)
	self:Toggle(client)
end