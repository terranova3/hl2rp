--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Splint"
ITEM.model = Model("models/carlsmei/escapefromtarkov/medical/alusplint.mdl")
ITEM.description = "An orange, multi-use brace able to set fractures and breaks."
ITEM.category = "Medical"
ITEM.price = 18
ITEM.uses = 5
ITEM.backgroundColor = Color(62, 40, 26, 130)
ITEM.functions.Apply = {
	OnRun = function(itemTable)
		local client = itemTable.player
        local character = client:GetCharacter()
        local hasFracture, fractures = character:GetFractures()

        if(hasFracture) then
            local rand = math.random(1, #fractures)

            ix.limb.SetFracture(character, fractures[rand].hitgroup, false) 

            client:Notify(string.format("You have fixed your %s.", fractures[rand].name))

            if(itemTable:GetData("currentUses") > 1) then
                itemTable:SetData("currentUses", itemTable:GetData("currentUses") - 1)
    
                return false
            end
        else
            client:Notify("You don't have a fracture on one of your limbs!")

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
                self.useLabel:SetExpensiveShadow(1)       
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