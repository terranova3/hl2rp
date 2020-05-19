--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

util.AddNetworkString("ixArmoryBuy")
util.AddNetworkString("ixArmoryRequestLogs");

net.Receive("ixArmoryBuy", function(length, client)
    local data = net.ReadTable()
    local char = client:GetCharacter()

    if (!char) then
        return
    end

    if (table.IsEmpty(data)) then
        return
    end

    if(client:Team() == FACTION_MPF) then
        local inventory = char:GetInventory()
        
        for k, v in ipairs(data.cart) do
            local itemTable = ix.item.list[data.cart[k].uniqueID]

            if(!inventory:Add(data.cart[k].uniqueID, 1, {armoryid = char:GetName()})) then
                ix.item.Spawn(uniqueID, client)
            end;

            local log = string.format("%s has received %s from a cp armory. Reason: %s", client:GetName(), itemTable.name, data.reason or "No reason specified");
			local timeString = os.date("%H:%M:%S - %d/%m/%Y", os.time())

            ix.log.AddRaw(log);

            PLUGIN:AddArmoryLog({
                log = string.format("%s has received %s.", client:GetName(), itemTable.name),
                reason = data.reason,
                time = timeString
            });          
        end;
    end;
end)
