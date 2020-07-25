ITEM.name = "Resource Base"
ITEM.model = "models/Items/BoxSRounds.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.baseAmount = 1 -- amount of the ammo
ITEM.maxAmount = 10
ITEM.description = "A pile with %s amount of resource."
ITEM.category = "Resource"
ITEM.splitSize = {1, 2, 5, 10}

function ITEM:GetDescription()
    local quant = self:GetData("quantity", self.baseAmount)
    local ammodesc = Format(self.description, quant)
    return (ammodesc)
end

if (CLIENT) then
	function ITEM:PaintOver(item, w, h)
		draw.SimpleText(
			item:GetData("quantity", item.baseAmount).."/"..item.maxAmount, "DermaDefault", 3, h - 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM, 1, color_black
		)
	end
end

ITEM.functions.split = {
    name = "Split",
    tip = "useTip",
    icon = "icon16/briefcase.png",
    isMulti = true,
    multiOptions = function(item, client)
		local targets = {}
        local quantity = item:GetData("quantity", item.baseAmount)
		
        for i=1,#item.splitSize-1 do
			if quantity > item.splitSize[i] then
				table.insert(targets, {
					name = item.splitSize[i],
					data = {item.splitSize[i]},
				})
			end
		end
        return targets
	end,
	OnCanRun = function(item)				
		return (!IsValid(item.entity))
	end,
    OnRun = function(item, data)
		if data[1] then
			local quantity = item:GetData("quantity", item.baseAmount)
			local client = item.player
			
			if quantity < data[1] then
				return false
			end
			
			client:GetCharacter():GetInventory():Add(item.uniqueID, 1, {["quantity"] = data[1]})
			
			quantity = quantity - data[1]
			
			item:SetData("quantity", quantity)
			
		end
		return false
	end,
}

ITEM.functions.combine = {
    OnCanRun = function(item, data)
        if !data then
            return false
        end
        
        if !data[1] then
            return false
        end
        
        local targetItem = ix.item.instances[data[1]]

        if targetItem.uniqueID == item.uniqueID then
            return true
        else
            return false
        end
    end,
    OnRun = function(item, data)
        local targetItem = ix.item.instances[data[1]]
        local localQuant = item:GetData("quantity", item.baseAmount)
        local targetQuant = targetItem:GetData("quantity", targetItem.baseAmount)
        local combinedQuant = (localQuant + targetQuant)

        if combinedQuant <= item.maxAmount then
            targetItem:SetData("quantity", combinedQuant)
            return true
        elseif localQuant >= targetQuant then
            targetItem:SetData("quantity",item.maxAmount)
            item:SetData("quantity",(localQuant - (item.maxAmount - targetQuant)))
            return false
        else
            targetItem:SetData("quantity",(targetQuant - (item.maxAmount - localQuant)))
            item:SetData("quantity",item.maxAmount)
            return false
        end
    end,
}
