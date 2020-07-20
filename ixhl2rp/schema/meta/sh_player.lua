local playerMeta = FindMetaTable("Player")

function playerMeta:IsCombine()
	local faction = self:Team()
	return faction == FACTION_MPF or faction == FACTION_OTA
end

function playerMeta:IsDispatch()
	local name = self:Name()
	local faction = self:Team()
	local bStatus = faction == FACTION_OTA

	if (!bStatus) then
		if(ix.ranks.HasPermission(self:GetCharacter():GetRank().uniqueID, "Dispatch")) then
			bStatus = true
		end
	end

	return bStatus
end
