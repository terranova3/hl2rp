--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local playerMeta = FindMetaTable("Player")

function playerMeta:IsVortigaunt()
	local faction = self:Team()
	return faction == FACTION_VORT or faction == FACTION_BIOTIC
end

-- A function to handle a vortigaunt's night vision
function playerMeta:HandleNightVision()
	local nightvision = self:GetWeapon("ix_nightvision");
	
	if (IsValid(nightvision) and nightvision:IsActivated() and self:Alive() and !self:IsRagdolled()) then
		self:SetData("nvActive", true);
	else
		self:SetData("nvActive", false);
	end;
end;