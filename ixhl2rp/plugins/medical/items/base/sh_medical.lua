--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Medical Base"
ITEM.model = Model("models/bloocobalt/l4d/items/w_eq_pills.mdl")
ITEM.description = "A bottle of antibiotics used to treat bacterial complications."
ITEM.backgroundColor = Color(76, 37, 29, 100)
ITEM.category = "Medical"
ITEM.flag = "m"
ITEM.price = 20
ITEM.restoreHealth = 0
ITEM.functions.Apply = {
    name = "Apply",
    icon = "icon16/pill.png",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + itemTable.restoreHealth, client:GetMaxHealth()))
		client:EmitSound("items/medshot4.wav", 80)
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

		client:EmitSound("items/medshot4.wav", 80)
		target:SetHealth(math.min(target:Health() + itemTable.restoreHealth, target:GetMaxHealth()))
	end
}

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")
	data:SetBackgroundColor(Color(190, 62, 39, 120))
	data:SetText("This item will restore your health for " .. self.restoreHealth or 0 .. ". Has one use.")
	data:SizeToContents()
end