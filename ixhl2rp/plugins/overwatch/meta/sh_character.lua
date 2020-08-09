local characterMeta = ix.meta.character

function characterMeta:IsOverwatch()
	local faction = self:GetPlayer():Team();

	if(faction == FACTION_OTA) then
		return true
	end;

	return false;
end
