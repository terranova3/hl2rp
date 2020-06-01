
if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )

	
end

if (CLIENT) then
	SWEP.Slot = 0;
	SWEP.SlotPos = 7;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Broom";
	SWEP.DrawCrosshair = true;
end

SWEP.Author			= "NightAngel"
SWEP.Instructions = "Primary Fire: Sweep";
SWEP.Purpose = "To sweep up dirt and trash.";
SWEP.Contact = ""
SWEP.AdminSpawnable = false;
SWEP.ViewModel      = ""
SWEP.WorldModel   = ""
SWEP.HoldType = "melee"

SWEP.Primary.Delay			= 0.2 	--In seconds
SWEP.Primary.Recoil			= 0		--Gun Kick
SWEP.Primary.Damage			= 0	--Damage per Bullet
SWEP.Primary.NumShots		= 1		--Number of shots per one fire
SWEP.Primary.Cone			= 0 	--Bullet Spread
SWEP.Primary.ClipSize		= -1	--Use "-1 if there are no clips"
SWEP.Primary.DefaultClip	= -1	--Number of shots in next clip
SWEP.Primary.Automatic   	= false	--Pistol fire (false) or SMG fire (true)
SWEP.Primary.Ammo         	= "none"	--Ammo Type

SWEP.Secondary.IsAlwaysRaised = true;
SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.Delay = 1;
SWEP.Secondary.Ammo	= "";

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType);
end

function SWEP:Deploy()
	self.Owner.broomProp = ents.Create("prop_dynamic")
	self.Owner.broomProp:SetModel("models/props_c17/pushbroom.mdl")
	self.Owner.broomProp:DrawShadow(true)
	self.Owner.broomProp:SetMoveType(MOVETYPE_NONE)
	self.Owner.broomProp:SetParent(self.Owner)
	self.Owner.broomProp:SetSolid(SOLID_NONE)
	self.Owner.broomProp:Spawn()
	self.Owner.broomProp:Fire("setparentattachment", "cleaver_attachment", 0.01)
end;

function SWEP:Holster()
	if (self.Owner.broomProp) then
		if (self.Owner.broomProp:IsValid()) then
			self.Owner.broomProp:Remove()
			self.Owner:SetForcedAnimation(false)
		end;
	end;
	return true
end;

function SWEP:Think()
	if (SERVER) then
		if (Clockwork.player:GetWeaponRaised(self.Owner)) then
			if (self.Owner:GetVelocity() == Vector(0,0,0)) then
				local curTime = CurTime()						
				if (self.isSweep) then
					if (!self.nextSweep) then
					self.nextSweep = curTime + 2;
					end;
					--local sequence = self.Owner:LookupSequence("sweep")
					--if sequence then
					--	self.Owner:ResetSequence(sequence)
					--end;
					self.Owner:SetForcedAnimation("sweep", 0, nil)			
					if (self.nextSweep) then
						if ( (curTime >= self.nextSweep) ) then
							self.isSweep = nil;
							self.nextSweep = nil
						end;
					end;
				else
				--	local sequence = self.Owner:LookupSequence("sweep_idle")
				--	self.Owner:ResetSequence(sequence)
					self.Owner:SetForcedAnimation("sweep_idle", 0, nil)
				end;
			else
			--	local sequence = self.Owner:LookupSequence("Walk_all_HoldBroom")
			--	self.Owner:ResetSequence(sequence)
				self.Owner:SetForcedAnimation("Walk_all_HoldBroom", 0, nil)
			end;
		end;
	end;
end;

function SWEP:OnRemove()
	if (self.Owner.broomProp) then
		if (self.Owner.broomProp:IsValid()) then
			self.Owner.broomProp:Remove()
			self.Owner:SetForcedAnimation(false)
		end;
	end;
	return true
end;

function SWEP:PrimaryAttack()
	if (!self.nextSweep) then
		if (!self.isSweep) then
			self.isSweep = true
		end;
	end;
end;

local counter = 0

function SWEP:SecondaryAttack()
	return false
end