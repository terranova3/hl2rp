--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

function PLUGIN:SaveData()
	self:SaveKeycardTerminals()
end

function PLUGIN:LoadData()
    self:LoadKeycardTerminals();
end;

function PLUGIN:SaveKeycardTerminals()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_keycard_terminal")) do
		if (IsValid(v.door)) then
			data[#data + 1] = {
				v.door:MapCreationID(),
				v.door:WorldToLocal(v:GetPos()),
				v.door:WorldToLocalAngles(v:GetAngles()),
                v:GetLocked(),
                v:GetPos(),
                v:GetAngles()
			}
		end
	end

	ix.data.Set("keycardTerminals", data)
end

function PLUGIN:LoadKeycardTerminals()
	for _, v in ipairs(ix.data.Get("keycardTerminals") or {}) do
		local door = ents.GetMapCreatedEntity(v[1])

		if (IsValid(door) and door:IsDoor()) then
			local terminal = ents.Create("ix_keycard_terminal")

            terminal:SetPos(v[5])
            terminal:SetAngles(v[6])
            terminal:Spawn()
			terminal:SetDoor(door)
			terminal:SetLocked(v[4])
		end
	end
end

