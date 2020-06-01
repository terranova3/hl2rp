include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");
  
function ENT:Initialize()   
	self:SetMoveType( MOVETYPE_NONE );
	self:SetSolid( SOLID_NONE );
	self:SetCollisionGroup( COLLISION_GROUP_NONE );
	ent:SetModel("models/error.mdl");
	ent:SetColor( Color(0,0,0,0) );
	ent:DrawShadow(false);
end;

function ENT:SetOwnerVariable(owner)
	self.Owner = owner;
end;

function ENT:RemoveLight(owner)
	local worldmodel = ents.FindInSphere(owner:GetPos(), 0.6);
	
	for k, v in pairs(worldmodel) do 
		if (v:GetClass() == "ix_nvlight" and v:GetOwner() == owner) then
			v:Remove();
		end;
	end;
end;