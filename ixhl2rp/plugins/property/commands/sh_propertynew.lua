--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]


ix.command.Add("PropertyNew", {
	description = "Enters property edit mode and allows you to make a property by selecting doors.",
	superAdminOnly = true,
    OnRun = function(self, client)
        client:SetData("propertyEdit", !client:GetData("propertyEdit"))

        if(client:GetData("propertyEdit")) then
            client:ChatNotify("You are now making a property. Select doors to set up the property.")
        else
            client:ChatNotify("You have exited property edit mode.")
        end
	end
})