local playerMeta = FindMetaTable("Player");

function playerMeta:IsCombine()
	local faction = self:Team();
	local isCombine = (faction == FACTION_OTA);

	if(faction == FACTION_MPF and self:GetCharacter():GetClass() != "CLASS_MPUH") then
		isCombine = true;
	else
		isCombine = false;
	end;

	return isCombine;
end

function playerMeta:IsMetropolice()
	local faction = self:Team();
	return faction == FACTION_MPF;
end;

function playerMeta:IsDispatch()
	local character = self:GetCharacter();
	local faction = self:Team();
	local bStatus = faction == FACTION_OTA;
	local accessLevel = ix.config.Get("Dispatch Access Level");

	if(!accessLevel) then accessLevel = 1; end;

	if (!bStatus) then
		if(Schema.ranks.Get(character:GetData(cpRank)).access >= accessLevel) then
			bStatus = true;
		end;
	end

	return bStatus;
end

function playerMeta:IsUndercover()
	if(self:GetCharacter():GetFaction() == FACTION_MPF and self:GetCharacter():GetClassName() == "Metropolice Unit Undercover") then
		return true;
	else
		return false;
	end;
end;

function playerMeta:GetClassName()
	return ix.class.list[self:GetCharacter():GetClass()].name;
end;