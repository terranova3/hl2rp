--[[
    Copyright © 2020 Cloud Sixteen

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]


function PLUGIN:LoadData()
	for _, v in ipairs(self:GetData() or {}) do
		local entity = ents.Create("ix_book")
		entity:SetPos(v.pos)
		entity:SetAngles(v.angles)
		entity:Spawn()

		entity:SetModel(v.model)
        entity:SetSkin(v.skin or 0)
        entity:SetBook(v.book)
		entity:SetSolid(SOLID_BBOX)
		entity:PhysicsInit(SOLID_BBOX)

		local physObj = entity:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end
end

function PLUGIN:SaveData()
	local data = {}

	for _, entity in ipairs(ents.FindByClass("ix_book")) do
		data[#data + 1] = {
			pos = entity:GetPos(),
			angles = entity:GetAngles(),
            model = entity:GetModel(),
            book = v.book.uniqueID,
		}
	end

	self:SetData(data)
end

netstream.Hook("TakeBook", function(client, data)
	if (IsValid(data)) then
		if (data:GetClass() == "ix_book") then
			if (client:GetPos():Distance( data:GetPos() ) <= 192 and client:GetEyeTraceNoCursor().Entity == data) then
				local inventory = client:GetCharacter():GetInventory()
				local success = inventory:Add(data.book.uniqueID)
					
				if (success) then
					data:Remove();
				end;
			end;
		end;
	end;
end);
