local playerMeta = FindMetaTable("Player");

function playerMeta:IsCombine()
	local faction = self:Team();
	local isCombine = (faction == FACTION_OTA);

	if(self:GetCharacter() != nil) then 
		if(faction == FACTION_MPF and !self:GetCharacter():IsUndercover()) then
			isCombine = true;
		else
			isCombine = false;
		end;
	end;

	return isCombine;
end

function playerMeta:IsMetropolice()
	local faction = self:Team();
	return faction == FACTION_MPF;
end;