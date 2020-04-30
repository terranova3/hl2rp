--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.command.Add("CharSetCPID",  {
	description = "Sets the id of a civil protection unit.";
	arguments = {
		ix.type.character,
		ix.type.number
	},
	OnCheckAccess = function(self, client)
		return client:IsDispatch();
	end,
	OnRun = function(self, client, target, text)
		if(target:GetFaction() == "Metropolice Force") then
			if(text > 0 and text < 10) then
            	target:SetData("cpID", text);

				if(!target:IsUndercover())
					target:SetName(PLUGIN:GetCpName(target));
				end;
				
				for _, v in ipairs(player.GetAll()) do
					if (self:OnCheckAccess(v) or v == target:GetPlayer()) then
						v:NotifyLocalized("Your cp id has been changed to %s-%s.", target:GetData("cpTagline"), text);
					end
				end
			else
				return "You must input a number that is 1-9.";
			end
        else
            return "That character is not a part of the Metropolice Force faction.";
        end;
	end;
})