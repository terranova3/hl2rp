--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.command.Add("CharSetCPName",  {
	description = "Sets the citizen name of a civil protection unit.";
	arguments = {
		ix.type.character,
		bit.bor{ix.type.string, ix.type.optional}
	},
	OnCheckAccess = function(self, client)
		return client:IsDispatch();
	end,
	OnRun = function(self, client, target, text)
        if(target:GetFaction() == "Metropolice Force") then
            target:SetData("cpCitizenName", text);

            if(target:GetClass() != "CLASS_MPUH")
                target:SetName(target:GetData("cpCitizenName"));
            end;

            for _, v in ipairs(player.GetAll()) do
                if (self:OnCheckAccess(v) or v == target:GetPlayer()) then
                    v:NotifyLocalized("Your citizen name has been changed to '%s'.", text);
                end
            end
        else
            return "That character is not a part of the Metropolice Force faction.";
        end;
	end;
})