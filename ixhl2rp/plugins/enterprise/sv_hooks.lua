--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

netstream.Hook("BusinessApplicationUpdate", function(client, data)
    if (!IsValid(client) or !client:GetCharacter()) then
        return
    end

    local character = client:GetCharacter()
    local item = ix.item.instances[data.id]

    -- Check if the client actually owns this item
    if(!item or item:GetOwner() != client) then
        return
    end

    item:SetData("businessCharID", character:GetID())
    item:SetData("businessOwner", character:GetName())
    item:SetData("businessName", data.name)
    item:SetData("businessDescription", data.description)
    item:SetData("businessPermits", data.permits)
end)
