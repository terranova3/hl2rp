--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

util.AddNetworkString("ixInventoryDragCombine")

function ix.item.PerformDragCombine(client, item, item2, invID)
    local character = client:GetCharacter()

    if (!character) then
        return
    end

    local inventory = ix.item.inventories[invID or 0]

    if (hook.Run("CanPlayerInteractItem", client, action, item, {}) == false) then
        return
    end

    item = ix.item.instances[item]
    item2 = ix.item.instances[item2]

    if (!item or !item2) then return end

    if (!inventory:OnCheckAccess(client)) then
        return
    end

    if (!inventory:GetItemByID(item.id) and !inventory:GetItemByID(item2.id)) then
        return
    end

    if (item.dragged) then
        item.dragged(item, item2)
    end
end

net.Receive("ixInventoryDragCombine", function(length, client)
    ix.item.PerformDragCombine(client, net.ReadUInt(32), net.ReadUInt(32), net.ReadUInt(32))
end)