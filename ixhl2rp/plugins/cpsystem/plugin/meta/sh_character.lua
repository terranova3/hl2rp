
local CHAR = ix.meta.character

function CHAR:IsMetropolice()
	local faction = self:GetFaction()
	return faction == FACTION_MPF
end
