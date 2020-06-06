--[[
    Copyright © 2020 Cloud Sixteen

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
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

-- A function to set the book.
function ENT:SetBook(book)
	local itemTable = ix.item.instances[book];
	
	if (itemTable) then
		print("has itemtable")
		self.book = itemTable;
		
		if (itemTable.skin) then
			self:SetModel(itemTable.model);
			self:SetSkin(itemTable.skin);
		else
			self:SetModel(itemTable.model);
		end;
		
		self:SetID(itemTable.id)
		self:SetDisplayName(itemTable.name);
		self:SetDescription(itemTable.description);
	end;
end;

function ENT:OnOptionSelected(client, option)
	if(option == "View") then
		netstream.Start(client, "ViewBook", self);
	elseif(option == "Take") then
		local inventory = client:GetCharacter():GetInventory()
		local success = inventory:Add(self.book.uniqueID)
			
		if (success) then
			self:Remove();
		end;
	end;
end
