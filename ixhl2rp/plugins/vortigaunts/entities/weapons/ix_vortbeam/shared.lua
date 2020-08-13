if (SERVER) then
	AddCSLuaFile("shared.lua");
end;

if (CLIENT) then
	SWEP.Slot = 0;
	SWEP.SlotPos = 5;
	SWEP.DrawAmmo = false;
	SWEP.PrintName = "Vortibeam";
	SWEP.DrawCrosshair = true;
	
	game.AddParticles("particles/Vortigaunt_FX.pcf");
end

PrecacheParticleSystem("vortigaunt_beam");
PrecacheParticleSystem("vortigaunt_beam_b");
PrecacheParticleSystem("vortigaunt_charge_token");

SWEP.Instructions = "Primary Fire: Fire your beam.";
SWEP.Purpose = "Immediately kills the target that you fire it at.";
SWEP.Contact = "";
SWEP.Author	= "RJ";

SWEP.ViewModel = "";
SWEP.WorldModel 			= ""
SWEP.HoldType = "normal";

SWEP.AdminSpawnable = false;
SWEP.Spawnable = false;
  
SWEP.Primary.IsAlwaysRaised = true;
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = false;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Damage = 55;
SWEP.Primary.Delay = 3;
SWEP.Primary.Ammo = "";

SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.Delay = 0;
SWEP.Secondary.Ammo	= "";

SWEP.IsAlwaysRaised = true;

-- Called when the SWEP is deployed.
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW);
end;

-- Called when the SWEP is holstered.
function SWEP:Holster(switchingTo)
	self:SendWeaponAnim(ACT_VM_HOLSTER);
	
	return true;
end;

-- Called when the SWEP is initialized.
function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType);
end;

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay);
	
	if (self.Owner:OnGround()) then
		if (SERVER) then
			self.Owner:ForceSequence("zapattack1", nil, 1.5, true);
		end;
		
		local chargeSound = CreateSound(self.Owner, "npc/vort/attack_charge.wav");
		chargeSound:Play();
		
		ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, self.Owner, self.Owner:LookupAttachment("leftclaw"));
		ParticleEffectAttach("vortigaunt_charge_token", PATTACH_POINT_FOLLOW, self.Owner, self.Owner:LookupAttachment("rightclaw"));
		
		timer.Simple(1.5, function()
			chargeSound:Stop();
			self.Owner:EmitSound("npc/vort/attack_shoot.wav");
			
			local tr = util.QuickTrace(self.Owner:EyePos(), self.Owner:EyeAngles():Forward()*5000, self.Owner);
			
			self.Owner:StopParticles();

			local leftClaw = self.Owner:LookupAttachment("leftclaw");

			if (leftClaw) then
				util.ParticleTracerEx(
					"vortigaunt_beam", self.Owner:GetAttachment(leftClaw).Pos, tr.HitPos, true, self.Owner:EntIndex(), leftClaw
				);
			end;
			
			util.BlastDamage(self.Owner, self.Owner, tr.HitPos, 10, 400);
		end);
	end;
end;

function SWEP:SecondaryAttack()
	return false
end