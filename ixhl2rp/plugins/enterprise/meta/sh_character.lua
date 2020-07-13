--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local CHAR = ix.meta.character

function CHAR:CanApproveApplication()
	return true
end

function CHAR:LeaveEnterprise()
	if(!self:GetEnterprise()) then
		return
	end

	net.Start("ixCharacterEnterpriseLeave")
		net.WriteInt(self:GetID(), 16)
		net.WriteInt(self:GetEnterprise(), 16)
	net.SendToServer()
end