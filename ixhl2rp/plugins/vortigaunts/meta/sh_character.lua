--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local CHAR = ix.meta.character

function CHAR:IsVortigaunt()
	local faction = self:GetFaction()
	return faction == FACTION_VORT or faction == FACTION_BIOTIC
end