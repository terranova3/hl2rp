--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local CHAR = ix.meta.character

function CHAR:PlaySound(sound)
    net.Start("ixStartSound")
        net.WriteString(sound, 32)
    net.Send(self:GetPlayer())
end
