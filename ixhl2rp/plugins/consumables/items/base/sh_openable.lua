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

                    if(v.uniqueID:lower() != "money") then
                        if (!client:GetCharacter():GetInventory():Add(v.uniqueID, v.amount or 1, v.data)) then
                            ix.item.Spawn(v.uniqueID, client, nil, nil, v.data)
                        end
                    else
                        client:GetCharacter():GiveMoney(v.amount)
                    end
                else
                    ErrorNoHalt(string.format("%s does not have a valid 'contains' array. Missing uniqueID and amount fields.", itemTable.name))
                end
            end

            if(itemTable.OnOpen) then
                itemTable:OnOpen()
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

function ITEM:OnOpen()
    local client = self.player

    if(self:GetData("salary", 0) != 0) then
        client:GetCharacter():GiveMoney(self:GetData("salary"))
    end
end

function ITEM:PopulateTooltip(tooltip)
    if(self:GetData("salary", 0) > 0) then
        local data = tooltip:AddRow("data")
        data:SetText(string.format("\nContains %s bonus tokens from your salary.", self:GetData("salary")))
        data:SetFont("ixPluginCharSubTitleFont")
        data:SizeToContents()
    end
end