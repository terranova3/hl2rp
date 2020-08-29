--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

util.AddNetworkString("ixUpdateOverwatchModel")

-- Called when a character has been loaded.
function PLUGIN:CharacterLoaded(character)
    if(character:GetFaction() == FACTION_OTA) then
        self:LoadDefaults(character)
        self:UpdateOverwatchName(character)
    end
end

-- Called when we need to check if a unit has their data set and if not, set it.
function PLUGIN:LoadDefaults(character)
	local faction = character:GetFaction()

    -- Grab the units previous name and turn the last 5 digits into an actual id.
    if(!character:GetData("id")) then
        local nameLength = string.len(character:GetName())
        local oldID = string.sub(character:GetName(), nameLength-4, nameLength)

		character:SetData("id", oldID or "ERROR");
    end
    
    if(!character:GetData("division")) then
        character:SetData("division", PLUGIN.config.defaultDivision)
    end

    if(!character:GetData("rank")) then
        character:SetData("rank", ix.ranks.GetDefaultRank(faction))
    end
end

-- Called when we need to update an overwatch character's name.
function PLUGIN:UpdateOverwatchName(character)
    character:SetName(character:GetOTAName())
end

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

-- Called when a unit's rank has been changed.
function PLUGIN:OnCharacterRankChanged(character)
	if(character:GetFaction() == FACTION_OTA) then
		self:UpdateOverwatchName(character)
	end;
end

net.Receive("ixUpdateOverwatchModel", function(length, client)
    local value = net.ReadInt(8)
    local character = client:GetCharacter()
    local otaType = PLUGIN.config.otaTypes[value]

    if(!character) then
        client:Notify("Your character does not exist.")
        return
    end

    if(!otaType) then
        client:Notify("That overwatch type does not exist!")
        return
    end

    local canChange, error = PLUGIN:CanChangeOverwatchModel(character)

    if(!canChange) then
        client:Notify(error)
        return 
    end

    -- 15 second cooldown on changing model.
    character.otaModelChange = CurTime() + 15
    character:SetModel(otaType.model)

    if(otaType.division) then
        character:SetData("division", otaType.division)
    end

    if(otaType.voiceType) then
        character:SetData("cpVoiceType", otaType.voiceType:lower())
    end

    PLUGIN:UpdateOverwatchName(character)

    ix.log.AddRaw(client:Name() .. " has updated their overwatch model to " .. value .. ".")
end)