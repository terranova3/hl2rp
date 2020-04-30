local playerMeta = FindMetaTable("Player");

function playerMeta:IsMetropolice()
	local faction = self:Team();
	return faction == FACTION_MPF;
end;

function playerMeta:IsDispatch()
	local character = self:GetCharacter();
	local faction = self:Team();
	local bStatus = faction == FACTION_OTA;

	if (!bStatus) then
		if(Schema.ranks.Get(character:GetData(cpRank)).access >= ix.config.Get("Dispatch Access Level")) then
			bStatus = true;
		end;
	end

	return bStatus
end