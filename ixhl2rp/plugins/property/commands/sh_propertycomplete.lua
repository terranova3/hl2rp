--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]


ix.command.Add("PropertyComplete", {
	description = "Exits property edit mode and brings you to the property completion screen.",
	superAdminOnly = true,
    OnRun = function(self, client)
        if(client.selectedDoors and client.selectedDoors[1]) then
            net.Start("ixPropertyAddDerma")
                net.WriteTable(client.selectedDoors or {})
                net.WriteTable(ix.property.sections)
            net.Send(client)
        else
            client:ChatNotify("You need to have at least one door selected to complete a property.")
        end
	end
})