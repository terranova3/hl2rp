--[[
	© 2017 Terra Nova do not use, share, re-distribute or modify without 
	permission of its author(zacharyenriquee@gmail.com) (Adolphus). 
--]]

include("shared.lua");
AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

ENT.PopulateEntityInfo = true

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel("models/props_combine/breenconsole.mdl");
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetHealth(20);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetDisplayName("<:: Uniform Assigner ::>")
	self:SetDescription("This machine is used for assigning a BIOLOCK ID to a unit's uniform.")

	local physicsObject = self:GetPhysicsObject();
	
	if ( IsValid(physicsObject) ) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end;
end;

-- Called when a player attempts to use a tool.
function ENT:CanTool(player, trace, tool)
	return false;
end;

function ENT:OnOptionSelected(client, option)
	if(option == "Assign: Standard Uniform") then
		client:RequestString("Enter the tagline of a unit to create this biolocked uniform for.", string.format("An example of a tagline would be %s.", cpSystem.GetCPTagline(client:GetCharacter())), function(text)
			local inventory = client:GetCharacter():GetInventory()
			
			inventory:Add("cp_standard", 1, {
				name = string.upper(text),
			})
		end)
	end;
end
