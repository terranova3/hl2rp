--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

local PLUGIN = PLUGIN

util.AddNetworkString("ixRecipeCraft")
util.AddNetworkString("ixMasterProfession")
util.AddNetworkString("ixRequestBlueprints")
util.AddNetworkString("ixSendBlueprints")
util.AddNetworkString("ixManageBlueprints")

net.Receive("ixRequestBlueprints", function(length, client)
    local charID = net.ReadInt(32)
    local target = ix.char.loaded[charID]

    if(!CAMI.PlayerHasAccess(client, "Helix - Request Character Blueprints", nil)) then
        return
    end

    if(!client:GetCharacter() or !target) then
        return
    end

    local blueprints = target:GetData("blueprints", {})

    PrintTable(blueprints)
    net.Start("ixSendBlueprints")
        net.WriteString(target:GetName(), 32)
        net.WriteTable(blueprints)
    net.Send(client)
end)

net.Receive("ixRecipeCraft", function(length, client)
    local uniqueID = net.ReadString(16)
    local character = client:GetCharacter()
    local recipe = ix.recipe.Get(uniqueID)
    
    if(!character or !recipe) then
        return
    end

    if(recipe:CanCraft(client)) then
        recipe:OnCraft(client)
    end
end)

net.Receive("ixMasterProfession", function(length, client)
    local uniqueID = net.ReadString(16)
    local character = client:GetCharacter()

    if(!character or !uniqueID) then
        return
    end

    if(character:GetMastery()) then
        return
    end

    PLUGIN:SetMastery(character, uniqueID)
end)

-- Called when we need to add a blueprint to a character.
function PLUGIN:AddBlueprint(character, blueprint)
    if(!character:HasBlueprint(blueprint)) then
        local blueprints = character:GetData("blueprints", {})

        table.insert(blueprints, blueprint)
        character:SetData("blueprints", blueprints)
    end
end

-- Called when we are setting the mastery of a character.
function PLUGIN:SetMastery(character, uniqueID)
    local profession = ix.profession.Get(uniqueID)

    if(profession) then
        character:SetData("mastery", uniqueID)
    end
end