--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

ITEM.name = "Medkit base"
ITEM.model = Model("models/carlsmei/escapefromtarkov/medical/salewa.mdl")
ITEM.backgroundColor = Color(76, 37, 29, 100)
ITEM.description = "Contains pre-combine medicine and various other tools and medical equipment."
ITEM.category = "Medical"
ITEM.price = 18
ITEM.amount = 300
ITEM.height = 2
ITEM.flag = "m"
ITEM.functions.Apply = {
    icon = "icon16/pill.png",
	OnRun = function(itemTable)
		local client = itemTable.player

        local shouldDelete, notify = PLUGIN:HealPlayer(client:GetCharacter(), itemTable)
        client:Notify(notify)

        return shouldDelete
	end
}
ITEM.functions.Give = {
    icon = "icon16/pill.png",
	OnRun = function(itemTable)
        local client = itemTable.player   
		local target = client:GetEyeTraceNoCursor().Entity;

        if (!target or !target:IsPlayer() or !target:GetCharacter() or target:GetPos():Distance(client:GetShootPos() ) >= 192) then
            return false
        end

        local shouldDelete, notify = PLUGIN:HealPlayer(target:GetCharacter(), itemTable, true)
        client:Notify(notify)

        return shouldDelete
	end
}

-- Called when a new instance of this item has been made.
function ITEM:OnInstanced(invID, x, y)
    self:SetData("currentAmount", self.charge)
end

if (CLIENT) then
    function ITEM:PaintOver(item, w, h)
        local amount = item:GetData("currentAmount", 0)

        if (amount) then
            surface.SetDrawColor(35, 35, 35, 225)
            surface.DrawRect(2, h-9, w-4, 7)

			local filledWidth = (w-5) * (item:GetData("currentAmount", item.charge) / item.charge)
			
            surface.SetDrawColor(190, 62, 39, 255)
            surface.DrawRect(3, h-8, filledWidth, 5) 
		end
	end
end

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")
	data:SetBackgroundColor(Color(190, 62, 39, 120))
	data:SetText("Uses Left: " .. self:GetData("currentAmount", self.charge))
	data:SetExpensiveShadow(0.5)
	data:SizeToContents()
end