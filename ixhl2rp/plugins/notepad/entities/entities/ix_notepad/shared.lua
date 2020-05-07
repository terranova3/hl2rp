--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

DEFINE_BASECLASS("base_gmodentity");

ENT.Type = "anim";
ENT.Author = "RJ";
ENT.PrintName = "Notepad";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;

-- Called when the datatables are setup.
function ENT:SetupDataTables()
	self:DTVar("Bool", 0, "note");
end;