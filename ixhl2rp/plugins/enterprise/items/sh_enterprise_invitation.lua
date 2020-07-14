--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Offer of Employment"
ITEM.description = "A piece of paper that contains an offer of employment."
ITEM.model = "models/props_office/folder.mdl"
ITEM.category = "Miscellaneous";
ITEM.enterprise = true
ITEM.functions.FillOut = {
    name = "Fill out form",
    icon = "icon16/book_edit.png",
	OnRun = function(itemTable)
        local client = itemTable.player
        local character = itemTable.player:GetCharacter()
        
        if(!character:GetEnterprise()) then
            client:Notify("You can't fill out this form!")

            return false
        end

        local enterprise = ix.enterprise.stored[character:GetEnterprise()]

        if(!enterprise) then
            return false
        end

        itemTable:SetData("businessName", enterprise.name)
        itemTable:SetData("businessID", enterprise.id)
        itemTable:SetData("signedBy", character:GetName())

        return false
	end
}
ITEM.functions.Accept = {
    name = "Accept Employment",
    icon = "icon16/book.png",
	OnRun = function(itemTable)
        local client = itemTable.player
		
		if(client:GetCharacter():GetEnterprise()) then
			client:Notify("You're already a part of an enterprise!")
			return false 
		end
		
        return false
	end
}
ITEM.suppressed = function(itemTable, name)
    local character = itemTable.player:GetCharacter()
    if(name == "Accept Employment") then
        if(character:GetEnterprise()) then
            return true, name, "You're already a part of an enterprise!"
        end

        if(!itemTable:GetData("businessName")) then
            return true, name, "This offer of employment hasn't been filled out."
        end  
    elseif(name == "Fill out form") then
        if(!character:GetEnterprise()) then
            return true, name, "You can't approve business applications!"
        end
    end

	return false
end

function ITEM:PopulateTooltip(tooltip)
    if(self:GetData("businessName")) then
        local name = tooltip:AddRow("name")
        name:SetText("Business name: " .. self:GetData("businessName", "N/A"))
        name:SetExpensiveShadow(0.5)
        name:SizeToContents()
        
        local signed = tooltip:AddRow("signed")
        signed:SetText("Signed by " .. self:GetData("signedBy", "N/A"))
        signed:SetExpensiveShadow(0.5)
        signed:SizeToContents()
    end
end