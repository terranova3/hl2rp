--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

function PLUGIN:CanAutoFormatMessage(client, chatType, message)
	return ix.language.stored[chatType]
end