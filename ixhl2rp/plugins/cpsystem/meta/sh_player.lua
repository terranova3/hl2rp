--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local playerMeta = FindMetaTable("Player");

function playerMeta:IsCombine()
	local faction = self:Team();
	local isCombine = (faction == FACTION_OTA or faction == FACTION_SCN);

	if(self:GetCharacter() != nil) then 
		if(faction == FACTION_MPF and !self:GetCharacter():IsUndercover()) then
			isCombine = true;
		end;
	end;

	return isCombine;
end