--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

util.AddNetworkString("adminSpawnMenu")
util.AddNetworkString("adminSpawnItem")

ix.log.AddType("adminSpawnItemLog", function(client, name)
    return string.format("%s has spawned \"%s\"", client:GetCharacter():GetName(), tostring(name))
end)

net.Receive("adminSpawnItem", function(len, client)
    local name = net.ReadString()

    if (!client:IsAdmin() or !client:Alive()) then 
        return 
    end

    for k, v in pairs(ix.item.list) do
        if v.name == name then
            ix.item.Spawn(v.uniqueID, client:GetShootPos() + client:GetAimVector()*84 + Vector(0, 0, 16))
            ix.log.Add(client, "adminSpawnItemLog", v.name)
            break
        end
    end
end)
