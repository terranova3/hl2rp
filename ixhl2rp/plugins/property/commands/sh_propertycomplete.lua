--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]


ix.command.Add("PropertyComplete", {
	description = "Exits property edit mode and brings you to the property completion screen.",
	superAdminOnly = true,
    OnRun = function(self, client)
        --if(client:GetData("propertyEdit")) then
            --client:SetData("propertyEdit", !client:GetData("propertyEdit"))

            net.Start("ixPropertyAddDerma")
                net.WriteTable(client.selectedDoors or {})
                net.WriteTable(ix.property.sections)
            net.Send(client)
        --end
	end
})