--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Breakdown Base";
ITEM.model = "models/props_junk/garbage_coffeemug001a.mdl";
ITEM.width = 1;
ITEM.height	= 1;
ITEM.description = "Breakdown base";
ITEM.category = "Breakdown";
ITEM.noBusiness = true
ITEM.functions.Breakdown = {
    icon = "icon16/cut_red.png",
    OnRun = function(itemTable)
        local client = itemTable.player
        
        if(itemTable.breakdown and itemTable.breakdown[1]) then
            for k, v in pairs(itemTable.breakdown) do
                if(v.uniqueID and v.amount) then

                    if(v.uniqueID:lower() != "money") then
                        if (!client:GetCharacter():GetInventory():Add(v.uniqueID, v.amount or 1, v.data)) then
                            ix.item.Spawn(v.uniqueID, client, nil, nil, v.data)
                        end
                    else
                        client:GetCharacter():GiveMoney(v.amount)
                    end
                else
                    ErrorNoHalt(string.format("%s does not have a valid 'breakdown' array. Missing uniqueID and amount fields.", itemTable.name))
                end
            end

            if(itemTable.OnBreakdown) then
                itemTable:OnBreakdown()
            end
        end

        if(itemTable.playSound) then
            client:EmitSound(itemTable.sound, 75, math.random(160, 180), 0.35)
        end
    end,
    OnCanRun = function(itemTable)
        local client = itemTable.player

        if(itemTable.tool and !client:GetCharacter():GetInventory():HasItem(itemTable.tool)) then
            return false
        end
    end
}