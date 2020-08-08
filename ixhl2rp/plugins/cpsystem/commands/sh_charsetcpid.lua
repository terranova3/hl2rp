--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharSetCPID", {
    description = "Sets the id of a civil protection unit.",
    permission = "Set CP ID",
	arguments = {
		ix.type.character,
		ix.type.number
	},
    OnRun = function(self, client, target, text)
        local character = client:GetCharacter()
        local correctInput = false

        for i = 1, 20 do
            if(text == i) then
                correctInput = true
                break
            end
        end

        if(correctInput) then
            if(character:HasOverride() or (ix.ranks.HasPermission(character:GetRank().uniqueID, "Set CP ID"))) then
                if(text != target:GetData("cpID")) then
                    if(target:IsMetropolice()) then
                        client:Notify(string.format("You have set the cp id of %s to %s.", target:GetName(), text));

                        -- Remove the old ID.
                        PLUGIN:RemoveFromCache(target)

                        target:SetData("cpID", text);
                        target:UpdateCPStatus()

                        -- Add the new ID
                        PLUGIN:AddToCache(target)
                        PLUGIN:SendCache()
                    else
                        client:Notify(string.format("That character is not a part of the '%s' faction.", target:GetFaction()));
                    end;
                else
                    client:Notify("That character already has that ID!");
                end
            else
                client:Notify("This command requires the 'Set CP ID' permission, which you do not have.");
            end;
        else
            client:Notify("Incorrect input. Enter a number from 1 to 9.")
        end
	end;
})