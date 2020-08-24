--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

ix.config.Add("healTickTimer", 300, "Duration between heal tick in seconds.", nil, {
	data = {min = 0, max = 3600},
	category = "Medical"
})

ix.config.Add("healTick", 300, "How much health a character can get max from a food heal tick.", nil, {
	data = {min = 0, max = 100},
	category = "Medical"
})

-- Called when we need to add healing to a character heal tick.
function PLUGIN:AddHealing(character, value)
    if(!self:GetHealTick(character)) then
        self:StartHealTick(character)
    end

    character.curHealTick = (character.curHealTick or 0) + value
end

-- Called when we need to start the character heal tick timer.
function PLUGIN:StartHealTick(character)
    character.curHealTick = 0

    timer.Create(character:GetID() .. "HealTick", ix.config.Get("healTickTimer", 300), -1, function()
        if(!character or character.curHealTick == nil) then
            self:StopHealTick(character)
        end

        local healing
        local client = character:GetPlayer()

        if(character.curHealTick >= ix.config.Get("healTick", 5)) then
            healing = ix.config.Get("healTick", 5)
        else
            healing = character.curHealTick
        end

        client:SetHealth(math.Clamp(client:Health() + healing, 0, client:GetMaxHealth()))
        character.curHealTick = character.curHealTick - healing

        if(character.curHealTick >= 0) then
            self:StopHealTick()
        end
    end)
end

-- Called when the character heal tick needs to be removed.
function PLUGIN:StopHealTick(character)
    if(self:GetHealTick(character)) then
        timer.Remove(character:GetID() .. "HealTick")
        character.curHealTick = nil
    end
end

-- Called when we need to see if the timer for the character tick already exists.
function PLUGIN:GetHealTick(character)
    return timer.Exists(character:GetID() .. "HealTick")
end