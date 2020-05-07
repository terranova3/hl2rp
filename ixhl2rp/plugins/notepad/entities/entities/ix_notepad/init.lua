--[[
	� 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_lab/clipboard.mdl");
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetHealth(25);
	self:SetSolid(SOLID_VPHYSICS);
	
	local physicsObject = self:GetPhysicsObject();
	
	if (IsValid(physicsObject)) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

-- A function to explode the entity.
function ENT:Explode()
	local effectData = EffectData();
	
	effectData:SetStart( self:GetPos() );
	effectData:SetOrigin( self:GetPos() );
	effectData:SetScale(8);
	
	util.Effect("GlassImpact", effectData, true, true);
	
	self:EmitSound("physics/body/body_medium_impact_soft"..math.random(1, 7)..".wav");
end;

-- Called when the entity takes damage.
function ENT:OnTakeDamage(damageInfo)
	self:SetHealth( math.max(self:Health() - damageInfo:GetDamage(), 0) );
	
	if (self:Health() <= 0) then
		self:Explode(); self:Remove();
	end;
end;

-- A function to set the text.
function ENT:SetText(text)
	if (text) then
		self.text = text;
		self.uniqueID = util.CRC(text);
		self:SetDTBool(0, true);
	end;
end;

function ENT:OnOptionSelected(client, option)
	if(self.text and option == "Read") then
		if (!client.notepadIDs or !client.notepadIDs[self.uniqueID]) then
			if (!client.notepadIDs) then
				client.notepadIDs = {};
			end;
			
			client.notepadIDs[self.uniqueID] = true;
			netstream.Start(client, "ViewNotepad", {self, self.uniqueID, self.text});
		else
			netstream.Start(client, "ViewNotepad", {self, self.uniqueID});
		end;
	elseif ( arguments == "Edit" ) then
		if (self.uniqueID == client:UniqueID()) then
			if (!client.notepadIDs or !client.notepadIDs[self.uniqueID]) then
				if (!client.notepadIDs) then
					client.notepadIDs = {};
				end;
				
				client.notepadIDs[entity.uniqueID] = true;
				netstream.Start(client, "EditNotepad", {self, self.uniqueID, self.text});
			else
				netstream.Start(client, "EditNotepad", {self, self.uniqueID});
			end;
		else
			client:Notify("You do not own this notepad!");
		end;
	else
		print(client:GetName())
		netstream.Start(client, "EditNotepad", {self, self.uniqueID});
	end;
end