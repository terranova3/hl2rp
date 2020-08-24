local playerMeta = FindMetaTable("Player")

function playerMeta:IsCombine()
	local faction = self:Team()
	return faction == FACTION_MPF or faction == FACTION_OTA
end

function playerMeta:IsDispatch()
	local faction = self:Team()
	local bStatus = faction == FACTION_OTA

	if (!bStatus) then
		if(self:GetCharacter():GetRank() and ix.ranks.HasPermission(self:GetCharacter():GetRank().uniqueID, "Dispatch")) then
			bStatus = true
		end
	end

	return bStatus
end
