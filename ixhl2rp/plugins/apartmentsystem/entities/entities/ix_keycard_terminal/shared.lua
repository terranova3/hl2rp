--[[
	© 2017 Terra Nova do not use, share, re-distribute or modify without 
	permission of its author(zacharyenriquee@gmail.com) (Adolphus). 
--]]

local PLUGIN = PLUGIN;

ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "Adolphus";
ENT.Category = "HL2 RP";
ENT.PrintName = "Keycard Terminal";
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisabled = false;

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Locked")
	self:NetworkVar("Bool", 1, "DisplayError")

	if (SERVER) then
		self:NetworkVarNotify("Locked", self.OnLockChanged)
	end
end