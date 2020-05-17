--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

if(SERVER) then
    function PerformCharPaneAction(client, action, item, data)
        local character = client:GetCharacter()

        if (!character) then
            return
        end

        local charpane = character:GetData("charpane") or {}

        if (hook.Run("CanPlayerInteractItem", client, action, item, data) == false) then
            return
        end

        if (isnumber(item)) then
            item = ix.item.instances[item]

            if (!item) then
                return
            end

            item.player = client
        end

        elseif (!inventory:GetItemByID(item.id)) then
            return
        end

        if(!item.outfitCategory) then
            return
        end;

        if(action == "add" or action == "replace") then
            charpane.slots[item.outfitCategory] = item;

            -- TODO
            if(action == "replace") then 
            end;
        elseif(action == "remove") then
            for k, v in pairs(charpane) do
                if(k == item.outfitCategory) then
                    charpane[k] = nil;
                end;
            end;
        end;

        character:SetData("charpane", charpane)
    end

	net.Receive("ixCharPaneAction", function(length, client)
        PerformCharPaneAction(client, net.ReadString(), net.ReadUInt(32), net.ReadTable())
    end)
end;