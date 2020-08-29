--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

-- Called when creating a new instance of an array with a metatable.
function ix.util.NewInstance(obj, seen)
    if type(obj) ~= 'table' then return obj end
    if seen and seen[obj] then return seen[obj] end
    local s = seen or {}
    local res = setmetatable({}, getmetatable(obj))
    s[obj] = res
    for k, v in pairs(obj) do res[ix.util.NewInstance(k, s)] = ix.util.NewInstance(v, s) end
    return res
end

-- Creats a dice roll
function ix.util.Chance(chance)
    local rand = math.random(0, 100)

    if(rand <= chance) then
        return true
    end

    return false
end

-- Converts a table into a string list
function ix.util.TableToString(array)
    if(!array) then
        return ""
    end
    
    local output = ""

    for i = 1, #array do
        if(i == 1) then
            output = output .. array[i]
        else
            output = output .. ", " .. array[i]
        end
    end

    return output
end

function ix.util.IncludeFolder(plugin, text)
    ix.util.IncludeDir(plugin.folder .. "/" .. text, true);
end