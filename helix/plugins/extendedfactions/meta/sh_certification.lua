--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]


ix.meta = ix.meta or {}

local CERT = ix.meta.cert or {}
CERT.__index = CERT
CERT.name = "undefined"
CERT.description = "undefined"
CERT.uniqueID = "undefined"
CERT.icon = "undefined"
CERT.faction = nil
CERT.offset = 0

function CERT:GetName()
	return self.name
end

function CERT:GetDescription()
	return self.description
end

function CERT:GetIcon()
	return self.icon
end

ix.meta.cert = CERT
