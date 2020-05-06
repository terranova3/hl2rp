--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.command.Add("ViewData", {
	accessLevel = cpSystem.config.commandsAccess["set_cp_tagline"],
	arguments = {
		ix.type.character
	},
	OnRun = function(self, client, target)
		if(PLUGIN:GetAccessLevel(client:GetCharacter() >= self.accessLevel) then
			local targetClient = target:GetPlayer()

			if (!hook.Run("CanPlayerViewData", client, targetClient)) then
				return "@cantViewData"
			end

			netstream.Start(client, "ViewData", targetClient, target:GetData("cid"), target:GetData("combineData"))
		else
			client:Notify(string.format("This command requires an access level of %s. Your access level is %s.", self.accessLevel, PLUGIN:GetAccessLevel(client:GetCharacter())));
		end;
	end;
})