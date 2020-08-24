--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.command.Add("CheckEdicts", {
    description = "Displays how many entities there are on the map.",
    adminOnly = true,
    OnRun = function(self, client)
        local count = 0
	
        for k, v in pairs(ents.GetAll()) do
            count=count+1
        end

        local countLeft = 8192 - count
    
        client:Notify(string.format("There are currently %s entities on the map. You can have %s more.", count, countLeft))
	end;
})