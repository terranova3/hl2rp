--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Bandage"
ITEM.model = Model("models/carlsmei/escapefromtarkov/medical/bandage_med.mdl")
ITEM.backgroundColor = Color(62, 40, 26, 130)
ITEM.description = "A sealed gauze package manufactured in Russia able to temporarily patch certain trauma. "
ITEM.category = "Medical"
ITEM.price = 18
ITEM.uses = 2
ITEM.functions.Apply = {
	OnRun = function(itemTable)
		local client = itemTable.player
        local character = client:GetCharacter()
        local hasBleed, bleeds = character:GetBleeds()

        if(hasBleed) then
            local rand = math.random(1, #bleeds)

            ix.limb.SetBleed(character, bleeds[rand].hitgroup, false) 

            client:Notify(string.format("You have bandaged your %s.", bleeds[rand].name))

            if(itemTable:GetData("currentUses") > 1) then
                itemTable:SetData("currentUses", itemTable:GetData("currentUses") - 1)
    
                return false
            end
        else
            client:Notify("You don't have a bleed on one of your limbs!")

            return false
        end
	end
}

-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
    self:SetData("currentUses", self.uses)
end

local font = font

if (CLIENT) then
    function ITEM:PaintOver(item, w, h)
        if (item:GetData("currentUses", 0)) then
            if(!self.useLabel) then
                self.useLabel = self:Add("DLabel")
                self.useLabel:SetPos(w - 20, h - 20)
                self.useLabel:SetColor(Color(190, 62, 39, 255))
                self.useLabel:SetExpensiveShadow(2)       
            end

            self.useLabel:SetText(item:GetData("currentUses", item.uses) .. "/" .. item.uses)   
		end
	end
end

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")
	data:SetBackgroundColor(Color(190, 62, 39, 120))
	data:SetText("Uses Left: " .. self:GetData("currentUses", self.uses))
	data:SetFont("BudgetLabel")
	data:SetExpensiveShadow(0.5)
	data:SizeToContents()
end