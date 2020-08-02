--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Medkit base"
ITEM.model = Model("models/carlsmei/escapefromtarkov/medical/salewa.mdl")
ITEM.backgroundColor = Color(76, 37, 29, 100)
ITEM.description = "Contains pre-combine medicine and various other tools and medical equipment."
ITEM.category = "Medical"
ITEM.price = 18
ITEM.charge = 300
ITEM.height = 2
ITEM.flag = "m"
ITEM.healthHealed = 30
ITEM.functions.Apply = {
    icon = "icon16/pill.png",
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
            client:SetHealth(math.Clamp(client:Health() + itemTable.healthHealed, 0, client:GetMaxHealth()))
            client:Notify(string.format("You have healed your %s for %s.", limb.name, healing))
            client:EmitSound("items/medshot4.wav", 80)

            return empty
        else
            client:Notify("Your limbs are all full health!")

            return false
        end
	end
}
ITEM.functions.Give = {
    icon = "icon16/pill.png",
	OnRun = function(itemTable)
        local client = itemTable.player   
		local target = client:GetEyeTraceNoCursor().Entity;

        if (!target or target:GetPos():Distance(client:GetShootPos() ) >= 192) then
            return false
        end

        local character = target:GetCharacter()
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
            target:SetHealth(math.Clamp(target:Health() + itemTable.healthHealed, 0, target:GetMaxHealth()))
            client:Notify(string.format("You have healed your target's %s for %s.", limb.name, healing))
            client:EmitSound("items/medshot4.wav", 80)

            return empty
        else
            client:Notify("Your target's limbs are all full health!")

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
        local amount = item:GetData("currentAmount", 0)

        if (amount) then
            surface.SetDrawColor(35, 35, 35, 225)
            surface.DrawRect(2, h-9, w-4, 7)

			local filledWidth = (w-5) * (item:GetData("currentCharge", item.charge) / item.charge)
			
            surface.SetDrawColor(190, 62, 39, 255)
            surface.DrawRect(3, h-8, filledWidth, 5) 
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