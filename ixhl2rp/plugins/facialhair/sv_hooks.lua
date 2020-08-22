--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PLUGIN = PLUGIN

util.AddNetworkString("ixUpdateFacialHair")

-- Returns if a character is allowed to change facial hair.
function PLUGIN:CanChangeFacialHair(character)
    local client = character:GetPlayer()

    if(client:IsFemale()) then
        return false, "You can't style your facial hair as a female!"
    end

    if(character:GetFaction() != FACTION_CITIZEN) then
        return false, "Only members of the citizen faction can style their facial hair."
    end

    if(character:IsWearingUniform()) then
        return false, "You can't style your character while wearing a uniform."
    end

    if((character.facialHairChange or 0) > CurTime()) then
        local waitTime = math.ceil((character.facialHairChange or 0) - CurTime())
        return false, "You must wait " .. waitTime .. " seconds before changing your facial hair again."
    end

    return true
end

-- Called when we need to update a character's facial hair.
function PLUGIN:UpdateFacialHair(character, value)
    local index = character:GetPlayer():FindBodygroupByName("facialhair")
    local groups = character:GetData("groups", {})
    groups[index] = value

    character:SetData("groups", groups)
    character.facialHairChange = CurTime() + (ix.config.Get("facialHairChangeTime", 0) * 60)
    
    self:RestoreFacialHair(character)
end

function PLUGIN:RestoreFacialHair(character)
    local index = character:GetPlayer():FindBodygroupByName("facialhair")
    local groups = character:GetData("groups", {})

    character:GetPlayer():SetBodygroup(index, groups[index])
end

net.Receive("ixUpdateFacialHair", function(length, client)
    local value = net.ReadInt(16)
    local character = client:GetCharacter()

    if(!character or !PLUGIN:CanChangeFacialHair(character)) then
        return
    end

    PLUGIN:UpdateFacialHair(character, value)
    ix.log.AddRaw(client:Name() .. " has updated their facial hair to " .. (PLUGIN.facialHair[value].name or "unknown") .. ".")
end)