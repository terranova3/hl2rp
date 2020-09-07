--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

ix.command.Add("CharResetMastery", {
    description = "Resets a character's mastery.",
    adminOnly = true,
    arguments = {
        ix.type.character
	},
    OnRun = function(self, client, target)
        target:SetData("mastery", nil)

        client:Notify(string.format("You have reset %s's mastery.", target:GetName()))
        if(client != target:GetPlayer()) then
            target:GetPlayer():Notify("Your crafting mastery has been reset.")
        end
	end;
})
