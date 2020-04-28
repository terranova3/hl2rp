local playerMeta = FindMetaTable("Player");

function playerMeta:IsMetropolice()
	local faction = self:Team();
	return faction == FACTION_MPF;
end;