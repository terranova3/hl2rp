--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Business Application"
ITEM.description = "Contains a compact form with various questions and answers, for creating a business. Has a small union Ministry of Workforce logo at the top right."
ITEM.model = "models/props_office/paperfolder01.mdl"
ITEM.category = "Other";
ITEM.functions.View = {
    icon = "icon16/book_edit.png",
	OnRun = function(itemTable)
		local client = itemTable.player
		local editMode = false
		
		if(itemTable:GetData("businessCharID")) then
			editMode = false
		end
		
		net.Start("ixBusinessApplicationEdit")
			net.WriteTable(ix.property.sections)
			net.WriteTable(ix.property.stored)
			net.WriteInt(itemTable.id, 16)
			net.WriteBool(editMode)
		net.Send(client)
		
        return false
	end
}
ITEM.functions.Approve = {
    icon = "icon16/book.png",
	OnRun = function(itemTable)
        local client = itemTable.player
		
		if(!client:GetCharacter():CanApproveApplication()) then
			client:Notify("You can't approve business applications!")
			return false 
		end

		local data = {
			["description"] = itemTable:GetData("businessDescription"),
			["permits"] = itemTable:GetData("businessPermits"),		
		}

		if(itemTable:GetData("businessOwner") and itemTable:GetData("businessName")) then
			ix.enterprise.New(itemTable.player, itemTable:GetData("businessCharID"), itemTable:GetData("businessName"), data)
		else
			client:Notify("That application is missing important data. Cannot approve until it has been filled out!")

			return false
		end
	end
}
ITEM.suppressed = function(itemTable)
	if(!itemTable:GetData("businessOwner") or !itemTable:GetData("businessName")) then
		return true, "Approve", "This application has not been filled out!"
	end

	if(!itemTable.player:GetCharacter():CanApproveApplication()) then
		return true, "Approve", "You can't approve business applications!"
	end

	return false
end

function ITEM:PopulateTooltip(tooltip)
	if(self:GetData("businessOwner")) then
		local data = tooltip:AddRow("data")
		local permitString = ""
		local propertiesString = ""
		local permits = self:GetData("businessPermits", {})
		local properties = self:GetData("businessProperties", {})

		for i = 1, #permits do
			if(i == 1) then
				permitString = permitString .. permits[i]
			else 
				permitString = permitString .. ", " .. permits[i]
			end
		end

		for i = 1, #properties do
			if(i == 1) then
				propertiesString = propertiesString .. properties[i].name
			else 
				propertiesString = propertiesString .. ", " .. properties[i].name
			end
		end

		data:SetText("Business owner: " .. self:GetData("businessOwner", "N/A") .. 
			"\nBusiness name: " .. self:GetData("businessName", "N/A") .. 
			"\nBusiness description: " .. self:GetData("businessDescription", "N/A") ..
			"\nBusiness permits: " .. permitString or "N/A" ..
			"\nBusiness properties: " .. propertiesString or "N/A" 
		)

		data:SetExpensiveShadow(0.5)
		data:SizeToContents()
	end
end