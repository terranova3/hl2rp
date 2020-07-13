--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local CHAR = ix.meta.character

function CHAR:CanApproveApplication()
	return true
end

function CHAR:GetEnterprise()
	print("Data:" .. self:GetData("enterprise", "Doesnt have"))

	if(self:GetData("enterprise") != nil) then
		return self:GetData("enterprise")
	end

	return false
end

function CHAR:LeaveEnterprise()
	if(!self:GetData("enterprise")) then
		return
	end

	net.Start("ixCharacterEnterpriseLeave")
		net.WriteInt(self:GetID(), 16)
		net.WriteInt(self:GetData("enterprise"), 16)
	net.SendToServer()
end