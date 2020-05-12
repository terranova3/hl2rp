--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- Called when data is saved, on server close or every 600s.
function PLUGIN:SaveData()
	self:SaveApartmentData();
	self:SaveKeycardTerminals()
end

-- Called when data is loaded, on server initialize.
function PLUGIN:LoadData()
	self:LoadApartmentData();
	self:LoadKeycardTerminals();
end;

-- Saves all the keycard terminal entities
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

-- Loads al lthe keycard terminal entities.
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

-- Stores the whole apartment section table
function PLUGIN:SaveApartmentData()
	self:SetData(self.sections)
end;

-- Loads the 'old' apartment section table and restores data that we want to persist.
function PLUGIN:LoadApartmentData()
	for _, v in ipairs(self:GetData() or {}) do
		PLUGIN:AddApartmentSection(v.category, v.name, v.prefix, true)

		for _, k in ipairs(v.apartments) do
			for i = 1, #k.doorIDs do
				k.doors[i] = ents.GetMapCreatedEntity(k.doorIDs[i])
			end;

			PLUGIN:AddApartment(k.section, k.doors, k.doorIDs, true)
		end;
	end
end;