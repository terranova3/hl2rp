--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.command.Add("CharRemoveSpec", {
    description = "Removes a certification specialization from a civil protection unit.",
    permission = "Remove spec",
	arguments = {
		ix.type.character
	},
    OnRun = function(self, client, target)
        local character = client:GetCharacter()
        local canChangeCert, error = ix.certs.CanChangeCert(character, target)

        if(target:GetData("spec")) then
            if(character:HasOverride() or ix.ranks.HasPermission(character:GetRank().uniqueID, "Remove cert")) then
                if(canChangeCert) then
                    target:SetData("spec", nil)

                    target:UpdateCPStatus()
                    
                    client:Notify(string.format("You have removed %s's specialization.", target:GetName()))
                else
                    client:Notify(error)
                end
            end
        else
            client:Notify(string.format("%s doesnt have a specialization.", target:GetName()))
        end
	end;
})