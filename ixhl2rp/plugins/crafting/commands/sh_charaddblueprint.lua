--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharAddBlueprint", {
    description = "Adds a blueprint to a character.",
    adminOnly = true,
    arguments = {
        ix.type.character,
        ix.type.text
	},
    OnRun = function(self, client, target, text)
        local recipe = ix.recipe.Get(text)

        if(!recipe) then
            return "There is no recipe for this blueprint!"
        end

        if(!recipe:GetBlueprint()) then
            return "This recipe does not require a blueprint."
        end

        PLUGIN:AddBlueprint(target, recipe:GetUniqueID())

        client:Notify(string.format("You've given %s the %s blueprint.", target:GetName(), recipe:GetName()))

        if(client != target:GetPlayer()) then
            target:GetPlayer():Notify(string.format("You've received the %s blueprint.", recipe:GetName()))
        end
	end;
})
