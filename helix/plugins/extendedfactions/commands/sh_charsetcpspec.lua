--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharSetSpec", {
    description = "Adds a certification specialization to a civil protection unit.",
    permission = "Set spec",
	arguments = {
		ix.type.character,
		ix.type.string
	},
    OnRun = function(self, client, target, text)
        if(PLUGIN:GetAccessLevel(client:GetCharacter()) >= self.accessLevel) then
            if(PLUGIN:IsMetropolice(target)) then
                if(ix.certs.Get(text)) then
                    if(!target:HasSpec(text)) then
                        local certs = target:GetData("certs", {})

                        for k, v in pairs(certs) do 
                            if(v == text) then
                                certs[k] = nil
                            end 
                        end

                        target:SetData("certs", certs)
                        target:SetData("spec", text)

                        PLUGIN:UpdateCharacter(target)

                        client:Notify(string.format("You have set the specialization of %s to %s.", target:GetName(), text));
                    else
                        client:Notify("That character already has that specialization.");
                    end
                else
                    client:Notify(string.format("The certification '%s' does not exist.", text));
                end;
            else
                client:Notify(string.format("That character is not a part of the '%s' faction.", target:GetFaction()));
            end;
        else
            client:Notify(string.format("This command requires an access level of %s. Your access level is %s.", self.accessLevel, PLUGIN:GetAccessLevel(client:GetCharacter())));
        end;
	end;
})