--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local CHAR = ix.meta.character

function CHAR:GetLimbs()
    return self:GetData("limbs", {})
end

function CHAR:SetLimbs(data)
    self:SetData("limbs", data)
end

function CHAR:ResetLimbData()
    self:SetData("limbs", {})
end

function ix.limb.HasFracture(character, group)
    local limbs = character:GetLimbs()

    if(limbs and limbs[group]) then
        return limbs[group].fracture
    end

    return false
end

function CHAR:GetInjuredLimbs()
    local data = ix.limb.hitgroup
    local injuredLimbs = {}

    for k, v in pairs(self:GetLimbs()) do
        if(v.health > 0) then
            v.name = data[k].name
            v.hitgroup = k
            v.maxHealth = data[k].maxHealth

            table.insert(injuredLimbs, v)
        end
    end

    return injuredLimbs
end

function CHAR:GetLimbHP(hitgroup)
    local limb = self:GetLimbs()[hitgroup]

    if(!limb) then return 0 end

    return ix.limb.GetHealthPercentage(self:GetPlayer(), hitgroup, true)
end

function CHAR:GetFractures()
    local fractures = {}

    for k, v in pairs(self:GetLimbs()) do
        if(v.fracture) then 
            table.insert(fractures, v)

            v.name = ix.limb.hitgroup[k].name
            v.hitgroup = k
        end
    end

    if(fractures[1]) then
        return true, fractures
    end

    return false, fractures
end
