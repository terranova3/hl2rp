--[[
	© 2017 Terra Nova do not use, share, re-distribute or modify without 
	permission of its author(zacharyenriquee@gmail.com) (Adolphus). 
--]]

local PLUGIN = PLUGIN;

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "Adolphus";
ENT.Category = "Helix";
ENT.PrintName = "UniformGenerator";
ENT.Spawnable = false;
ENT.AdminSpawnable = true;
ENT.PhysgunDisabled = false;

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "DisplayName")
	self:NetworkVar("String", 1, "Description")
end

function ENT:OnPopulateEntityInfo(container)
	local name = container:AddRow("name")
	name:SetImportant()
	name:SetText(self:GetDisplayName())
	name:SizeToContents()

	local descriptionText = self:GetDescription()

	if (descriptionText != "") then
		local description = container:AddRow("description")
		description:SetText(self:GetDescription())
		description:SizeToContents()
	end
end

function ENT:GetEntityMenu(client)
	local options = {}
	local character = client:GetCharacter();

	if(PLUGIN:IsMetropolice(character)) then
		if(!character:IsUndercover()) then 
			options["Assign: Standard Uniform"] = "";
		else
			ix.util.Notify("You cannot access that while not wearing a uniform.")
		end;
	else
		ix.util.Notify("You must be a part of the Civil Protection faction in order to interact with this entity.")
	end;

	return options
end