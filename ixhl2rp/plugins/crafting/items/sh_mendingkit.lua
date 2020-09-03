
ITEM.name = "Armour Mending Kit"
ITEM.model = Model("models/Items/battery.mdl")
ITEM.description = "Various tools to repair ballistic armour."
ITEM.category = "Medical"
ITEM.price = 35
ITEM.flag = "Z"

ITEM.functions.Apply = {
    OnRun = function(itemTable)
        local client = itemTable.player
        local kevlar = client:GetCharacter():GetKevlar()

        if(kevlar and kevlar:GetData("armor") < 100) then
            kevlar:SetData("armor", math.Clamp(kevlar:GetData("armor", 0) + 20, 0, 100))
            client:SetArmor(math.Clamp(client:Armor() + 20, 0, 100))
        end
    end
}
ITEM.suppressed = function(itemTable, name)  
    local kevlar = itemTable.player:GetCharacter():GetKevlar()

    if(kevlar and kevlar:GetData("armor" >= 100)) then
        return true, name, "Your equipped kevlar is already at maximum armor."
    end

    return false
end

function ITEM:Combine(targetItem)
    if(targetItem:GetData("armor")) then
        targetItem:SetData("armor", math.Clamp(v:GetData("armor", 0) + 20, 0, 100))
        self:Remove()
    end
end