local playerMeta = FindMetaTable("Player");

function playerMeta:IsCombine()
	local faction = self:Team();
	local isCombine = (faction == FACTION_OTA);

	if(self:GetCharacter() != nil) then 
		if(faction == FACTION_MPF and !self:GetCharacter():IsUndercover()) then
			isCombine = true;
		end;
	end;

	return isCombine;
end