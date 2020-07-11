--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]


ix.command.Add("PropertyEditMode", {
	description = "Toggles the property edit model.",
	superAdminOnly = true,
    OnRun = function(self, client)
        client:SetData("propertyEdit", !client:GetData("propertyEdit"))

        if(client:GetData("propertyEdit")) then
            client:ChatNotify("You are now in property edit mode.")
        else
            client:ChatNotify("You have exited property edit mode.")
        end
	end
})