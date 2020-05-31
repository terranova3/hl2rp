--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local character = ix.meta.character

function character:HasTrait(uniqueid)
    local traits = self:GetData("traits", {})

	for k, v in pairs(traits) do
		if(v == uniqueid) then return true end;
	end

    return false;
end