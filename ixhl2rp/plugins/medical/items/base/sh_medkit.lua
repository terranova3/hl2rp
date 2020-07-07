--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Medkit base"
ITEM.model = Model("models/carlsmei/escapefromtarkov/medical/salewa.mdl")
ITEM.backgroundColor = Color(62, 40, 26, 130)
ITEM.description = "Contains pre-combine medicine and various other tools and medical equipment."
ITEM.category = "Medical"
ITEM.price = 18
ITEM.charge = 300
ITEM.height = 2
ITEM.functions.Apply = {
	OnRun = function(itemTable)
		local client = itemTable.player
        local character = client:GetCharacter()
        local injuredLimbs = character:GetInjuredLimbs()

        if(injuredLimbs[1]) then
            local limb = injuredLimbs[math.random(1, #injuredLimbs)]
            local healingRequired = limb.health
            local healing = healingRequired
            local empty = false

            if(itemTable:GetData("currentCharge") >= healingRequired) then
                itemTable:SetData("currentCharge", itemTable:GetData("currentCharge") - healing)
            elseif(itemTable:GetData("currentCharge") < healingRequired) then
                healing = itemTable:GetData("currentCharge")
                empty = true
            end

            ix.limb.SetHealth(character, limb.hitgroup, -healing)
            client:Notify(string.format("You have healed your %s for %s.", limb.name, healing))

            return empty
        else
            client:Notify("Your limbs are all full health!")

            return false
        end
	end
}

-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
    self:SetData("currentCharge", self.charge)
end

local font = font

if (CLIENT) then
    function ITEM:PaintOver(item, w, h)
        if (item:GetData("currentCharge", 0)) then
            if(!self.useLabel) then
                self.useLabel = self:Add("DLabel")
                self.useLabel:SetPos(w - 60, h - 20)
                self.useLabel:SetColor(Color(190, 62, 39, 255))
                self.useLabel:SetExpensiveShadow(2)       
            end

            self.useLabel:SetText(item:GetData("currentCharge", item.charge) .. "/" .. item.charge)   
		end
	end
end

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")
	data:SetBackgroundColor(Color(190, 62, 39, 120))
	data:SetText("Uses Left: " .. self:GetData("currentCharge", self.charge))
	data:SetFont("BudgetLabel")
	data:SetExpensiveShadow(0.5)
	data:SizeToContents()
end