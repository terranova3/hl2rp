if SERVER then
	AddCSLuaFile("shared.lua")
end

if (CLIENT) then
	SWEP.Slot = 5;
	SWEP.SlotPos = 3;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Vortiheal";
	SWEP.DrawCrosshair = false;
end

SWEP.Author			        = "Ekt0"
SWEP.Instructions           = "Left click to heal";
SWEP.AdminSpawnable         = false;
SWEP.Spawnable		        = true;
SWEP.ViewModel              = ""
SWEP.WorldModel             = ""
SWEP.HoldType 				= "fist"

SWEP.UseHands				= true;
SWEP.Primary.ClipSize		= 35;
SWEP.Primary.DefaultClip	= 20;
SWEP.Primary.Automatic		= true;
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false;
SWEP.Secondary.Ammo			= "none"

SWEP.IsAlwaysRaised = true;

SWEP.inUse = false;

local HealSound = Sound( "npc/vort/health_charge.wav" )

function SWEP:Initialize()
	self.inUse = false;
	self.nextThink = CurTime();
end

function SWEP:PrimaryAttack()
	if (CLIENT) then return end
	if (self:Clip1() <= 5) then return end;
	
	local curTime = CurTime();
	
	local eyeTrace = self.Owner:GetEyeTrace();
	local ent = eyeTrace.Entity;

	if (IsValid(ent) and (ent:IsPlayer() or ent:IsNPC())) then
		
		
		if(!self.inUse) then
			ent:EmitSound(HealSound)
			self:PlayWeaponAnims()
			self.inUse = true;
		end;
		
		if(ent:GetMaxHealth() > ent:Health()) then
			self:SetClip1(self:Clip1() - 1);
			ent:SetHealth( math.min(ent:GetMaxHealth(), ent:Health() + 1) )
			self:SetNextPrimaryFire(curTime + 0.3)

		else
			self.inUse = false;
			self:SetNextPrimaryFire(curTime + 3)
		end;
	else
		self.inUse = false;
		self:SetNextPrimaryFire(curTime + 3)
	end;
end

function SWEP:SecondaryAttack()
end

function SWEP:PlayWeaponAnims()

	if (SERVER) then
		self.Weapon:CallOnClient("PlayWeaponAnims", "");
	end;
	
	self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK);
	self.Owner:SetAnimation(PLAYER_ATTACK1);
end;

function SWEP:Think()
	local curTime = CurTime();
	if (self.nextThink > curTime) then return end;
	
	if(!self.Owner:KeyDown(IN_ATTACK)) then
		self.inUse = false;
		if (self:Clip1() < self.Primary.ClipSize) then
			self.Weapon:SetClip1( self:Clip1() + 1)
		else
			-- If no ammo needs refilling, only check every 4 secs
			self.nextThink = curTime + 4;
			return true;
		end;
		
		-- Refill ammo every second
		self.nextThink = curTime + 1;
		return;
	end;

	self.nextThink = curTime + 4;
end;

function SWEP:OnRemove()
	self.inUse = false;
end

function SWEP:Holster()	
	self.inUse = false;
	return true
end