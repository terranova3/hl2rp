--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

hook.Add("CreateMenuButtons", "ixGamemasterMenu", function(tabs)
	if (hook.Run("BuildGamemasterMenu") != false) then
		tabs["Gamemaster"] = {
			Create = function(info, container)

			end
		}	
	end
end)