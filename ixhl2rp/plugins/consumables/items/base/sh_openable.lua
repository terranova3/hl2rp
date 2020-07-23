--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Openable item base";
ITEM.model = "models/props_junk/garbage_coffeemug001a.mdl";
ITEM.width	= 1;
ITEM.height	= 1;
ITEM.description = "Openable item base";
ITEM.category = "Containers";
ITEM.contains = {}
ITEM.deleteOnOpen = true
ITEM.playSound = true
ITEM.functions.Open = {
	OnRun = function(itemTable)
        local client = itemTable.player
        
        if(itemTable.contains and itemTable.contains[1]) then
            for k, v in pairs(itemTable.contains) do
                if(v.uniqueID and v.amount) then

                    if(v.uniqueID:lower() != "money")
                        if (!client:GetCharacter():GetInventory():Add(v.uniqueID, v.amount or 1, v.data)) then
                            ix.item.Spawn(v, client)
                        end
                    else
                        client:GetCharacter():GiveMoney(v.amount)
                    end
                else
                    ErrorNoHalt(string.format("%s does not have a valid 'contains' array. Missing uniqueID and amount fields.", itemTable.name))
                end
            end
        else
            client:Notify(string.format("%s does not contain anything!", itemTable.name))
        end

        if(itemTable.playSound) then
            client:EmitSound("ambient/fire/mtov_flame2.wav", 75, math.random(160, 180), 0.35)
        end

        if(itemTable.deleteOnOpen == false) then 
            return false
        end
	end
}