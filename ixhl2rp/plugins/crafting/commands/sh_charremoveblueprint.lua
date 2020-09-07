--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

ix.command.Add("CharRemoveBlueprint", {
    description = "Remove a blueprint from a character.",
    adminOnly = true,
    arguments = {
        ix.type.character,
        ix.type.text
	},
    OnRun = function(self, client, target, text)
        local blueprints = target:GetData("blueprints", {})

        for k, v in pairs(blueprints) do
            if(v == text) then
                blueprints[k] = nil
            end
        end

        target:SetData("blueprints", blueprints)

        client:Notify(string.format("You've removed the %s blueprint from %s", text, target:GetName()))

        if(client != target:GetPlayer()) then
            target:GetPlayer():Notify(string.format("You've lost the %s blueprint.", text))
        end
	end;
})
