--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local CHAR = ix.meta.character

function CHAR:AddLanguage(language)
    if(!ix.language.Get(language)) then
        return false, string.format("The language %s does not exist.", language)
    end

    if(self:HasLanguage(language)) then
        return false, string.format("%s already has the %s language!", self:GetName(), language)
    end

    local languages = self:GetData("languages", {})

    table.insert(languages, language)
    self:SetData("languages", languages)

    return true
end

function CHAR:RemoveLanguage(language)
    if(!ix.language.Get(language)) then
        return false, string.format("The language %s does not exist.", language)
    end

    if(!self:HasLanguage(language)) then
        return false, string.format("%s doesnt have the %s language!", self:GetName(), language)
    end

    local languages = self:GetData("languages", {})

    table.remove(languages, language)
    self:SetData("languages", languages)

    return true
end

function CHAR:HasLanguage(name)
    local languages = self:GetData("languages", {})
    
    for k, v in pairs(languages) do
        if(v == name) then
            return true
        end
    end

    return false
end
