--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.command.Add("CharSetCPTagline",  {
	description = "Sets the tagline of a civil protection unit.";
	arguments = {
		ix.type.character,
		ix.type.string
	},
	OnCheckAccess = function(self, client)
		return client:IsDispatch();
	end,
	OnRun = function(self, client, target, text)
		if(target:GetFaction() == "Metropolice Force") then
			local i = 0;
			local taglineExists;

			for _ in pairs(cpSystem.config.taglines) do
				if(string.find(text, cpSystem.config.taglines[i])) then
					taglineExists = true;
					break;
				else
					taglineExists = false;
				end;
				i=i+1;
			end

			if(taglineExists)
            	target:SetData("cpTagline", text);

				if(!target:IsUndercover())
					target:SetName(PLUGIN:GetCpName(target));
				end;

				for _, v in ipairs(player.GetAll()) do
					if (self:OnCheckAccess(v) or v == target:GetPlayer()) then
						v:NotifyLocalized("Your cp tagline has been changed to %s-%s.", text, target:GetData("cpID"));
					end
				end
			else
				return "That is not a valid tagline.";
			end;
        else
            return "That character is not a part of the Metropolice Force faction.";
        end;
	end;
})