--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

util.AddNetworkString("ixInventoryDragCombine")

function ix.item.PerformDragCombine(client, item, targetItem, invID)
    local character = client:GetCharacter()

    if (!character) then
        return
    end

    local inventory = ix.item.inventories[invID or 0]

    if (hook.Run("CanPlayerInteractItem", client, nil, item, {}) == false) then
        return
    end

    item = ix.item.instances[item]
    targetItem = ix.item.instances[targetItem]

    if (!item or !targetItem) then return end

    if (!inventory:OnCheckAccess(client)) then
        return
    end

    if (!inventory:GetItemByID(item.id) and !inventory:GetItemByID(targetItem.id)) then
        return
    end
    
    if (item.Combine) then
        local destroy = item:Call("Combine", client, nil, targetItem) or false

        if(destroy) then
            item:Remove()
            targetItem:Remove()
        end
    end
end

net.Receive("ixInventoryDragCombine", function(length, client)
    ix.item.PerformDragCombine(client, net.ReadUInt(32), net.ReadUInt(32), net.ReadUInt(32))
end)