--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

util.AddNetworkString("ixUpdateOverwatchModel")


-- Returns if a character is allowed to change facial hair.
function PLUGIN:CanChangeOverwatchModel(character)
    if(character:GetFaction() != FACTION_OTA) then
        return false, "Only members of the overwatch faction can change their faction model."
    end

    if((character.otaModelChange or 0) > CurTime()) then
        local waitTime = math.ceil((character.otaModelChange or 0) - CurTime())
        return false, "You must wait " .. waitTime .. " seconds before changing your model again."
    end

    return true
end

net.Receive("ixUpdateOverwatchModel", function(length, client)
    local value = net.ReadString(32)
    local character = client:GetCharacter()

    if(!character) then
        client:Notify("Your character does not exist.")
        return
    end

    local canChange, error = PLUGIN:CanChangeOverwatchModel(character)

    if(!canChange) then
        client:Notify(error)
        return 
    end

    -- 15 second cooldown on changing model.
    character.otaModelChange = CurTime() + 15
    character:SetModel(value)
    ix.log.AddRaw(client:Name() .. " has updated their overwatch model to " .. value .. ".")
end)