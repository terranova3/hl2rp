--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Splint base"
ITEM.model = Model("models/carlsmei/escapefromtarkov/medical/alusplint.mdl")
ITEM.description = "An orange, multi-use brace able to set fractures and breaks."
ITEM.category = "Medical"
ITEM.price = 18
ITEM.uses = 5
ITEM.flag = "m"
ITEM.backgroundColor = Color(76, 37, 29, 100)
ITEM.functions.Apply = {
    icon = "icon16/pill.png",
    OnRun = function(itemTable)
		local client = itemTable.player
        local character = client:GetCharacter()
        local hasFracture, fractures = character:GetFractures()

        if(hasFracture) then
            local rand = math.random(1, #fractures)

            ix.limb.SetFracture(character, fractures[rand].hitgroup, false) 

            client:Notify(string.format("You have fixed your %s.", fractures[rand].name))
            client:EmitSound("items/medshot4.wav", 80)

            -- No fractures anymore. Reset our movement.
            if(!character:GetFractures()) then
                ix.limb.ResetMovement(client)
            end

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
ITEM.functions.Give = {
    icon = "icon16/pill.png",
    OnRun = function(itemTable)
        local client = itemTable.player   
		local target = client:GetEyeTraceNoCursor().Entity;

        if (!target or !target:GetCharacter() or target:GetPos():Distance(client:GetShootPos() ) >= 192) then
            return false
        end

        local character = target:GetCharacter()
        local hasFracture, fractures = character:GetFractures()

        if(hasFracture) then
            local rand = math.random(1, #fractures)

            ix.limb.SetFracture(character, fractures[rand].hitgroup, false) 

            client:Notify(string.format("You have fixed your target's %s.", fractures[rand].name))
            client:EmitSound("items/medshot4.wav", 80)

            -- No fractures anymore. Reset our movement.
            if(!character:GetFractures()) then
                ix.limb.ResetMovement(target)
            end

            if(itemTable:GetData("currentUses") > 1) then
                itemTable:SetData("currentUses", itemTable:GetData("currentUses") - 1)
    
                return false
            end
        else
            client:Notify("You target doesn't have a fracture on one of their limbs!")

            return false
        end
	end
}

-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
    self:SetData("currentUses", self.uses)
end

if (CLIENT) then
    function ITEM:PaintOver(item, w, h)
        local amount = item:GetData("currentAmount", 0)

        if (amount) then
            surface.SetDrawColor(35, 35, 35, 225)
            surface.DrawRect(2, h-9, w-4, 7)

			local filledWidth = (w-5) * (item:GetData("currentUses", item.uses) / item.uses)
			
            surface.SetDrawColor(190, 62, 39, 255)
            surface.DrawRect(3, h-8, filledWidth, 5) 
		end
	end
end

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")
	data:SetBackgroundColor(Color(190, 62, 39, 120))
	data:SetText("This item will only fix a fracture. \nUses Left: " .. self:GetData("currentUses", self.uses))
	data:SizeToContents()
end