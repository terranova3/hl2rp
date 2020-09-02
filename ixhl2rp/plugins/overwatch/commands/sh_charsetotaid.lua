--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharSetOTAID", {
    description = "Sets the id of a overwatch unit",
	arguments = {
		ix.type.character,
		ix.type.number
	},
    OnRun = function(self, client, target, text)        
        if(text < 0 or text > 99999) then
            client:Notify("You must enter a number from 0-99999.")
            return
        end

        if(target:GetFaction() != FACTION_OTA) then
            client:Notify("Your target is not a member of the OTA faction.")
            return
        end

        client:Notify(string.format("You have changed your target's id to %s.", text))

        if(target:GetPlayer() != client) then
            target:Notify(string.format("Your id has been changed to %s.", text))
        end

        target:SetData("id", text)
        PLUGIN:UpdateOverwatchName(target)
	end;
})