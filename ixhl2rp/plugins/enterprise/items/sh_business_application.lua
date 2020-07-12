--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Business Application"
ITEM.description = "Contains a compact form with various questions and answers, for creating a business. Has a small union Ministry of Workforce logo at the top right."
ITEM.model = "models/props_office/paperfolder01.mdl"
ITEM.category = "Miscellaneous";
ITEM.functions.View = {
    icon = "icon16/book_edit.png",
	OnRun = function(itemTable)
        local client = itemTable.player
		
		if(itemTable:GetData("businessCharID")) then
			netstream.Start(client, "EditApplication", itemTable, true)
		else
			netstream.Start(client, "EditApplication", itemTable, false)
		end
		
        return false
	end
}

function ITEM:PopulateTooltip(tooltip)
	local data = tooltip:AddRow("data")
	local permitString = ""
	local permits = self:GetData("businessPermits", {})

	for i = 1, #permits do
		if(i == 1 or i == #permits) then
			permitString = permitString .. permits[i]
		else 
			permitString = permitString .. ", " .. permits[i]
		end
	end

	data:SetText("Business owner: " .. self:GetData("businessOwner", "N/A") .. 
		"\nBusiness name: " .. self:GetData("businessName", "N/A") .. 
		"\nBusiness description: " .. self:GetData("businessDescription", "N/A") ..
		"\nBusiness permits: " .. permitString or "N/A"
	)

	data:SetExpensiveShadow(0.5)
	data:SizeToContents()
end