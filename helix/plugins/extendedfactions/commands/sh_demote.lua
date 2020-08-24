--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.command.Add("CharDemote", {
    description = "Demotes the character to the next lowest rank in their faction.",
	arguments = {
		ix.type.character
    },
    OnRun = function(self, client, target)
        local character = client:GetCharacter()
        local canDemote, error = ix.ranks.CanDemote(character, target)
        local prevRank = ix.ranks.PreviousRank(target:GetRank())
  
        if(character:HasOverride() or ix.ranks.HasPermission(character:GetRank().uniqueID, "Demote")) then
            if(canDemote) then
                target:SetData("rank", prevRank.uniqueID)

                hook.Run("OnCharacterRankChanged", character, target, prevRank)

                client:Notify(string.format("You have set the rank of %s to %s.", target:GetName(), prevRank.displayName));
            else
                client:Notify(error)
            end
        end
	end;
})
