local CLIENT = FindMetaTable("Player")

function CLIENT:LimbsImmune()
	if (self:GetMoveType() == MOVETYPE_NOCLIP and self:GetMoveType() == MOVETYPE_LADDER) then
		return true
	end
	
	return false
end

function CLIENT:IsNoclipping()
	if(self:GetMoveType() == MOVETYPE_NOCLIP) then
		return true
	end
	
	return false
end