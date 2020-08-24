--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.command.Add("CharPromote", {
    description = "Promotes the character to the next highest rank in their faction.",
	arguments = {
		ix.type.character
    },
    OnRun = function(self, client, target)
        local character = client:GetCharacter()
        local nextRank = ix.ranks.NextRank(target:GetRank())
        local canPromote, error = ix.ranks.CanPromote(character, target)

        if(character:HasOverride() or ix.ranks.HasPermission(character:GetRank().uniqueID, "Promote")) then
            if(canPromote) then
                target:SetData("rank", nextRank.uniqueID)

                hook.Run("OnCharacterRankChanged", character, target, nextRank)

                client:Notify(string.format("You have set the rank of %s to %s.", target:GetName(), nextRank.displayName));
            else
                client:Notify(error)
            end
        end
	end;
})
