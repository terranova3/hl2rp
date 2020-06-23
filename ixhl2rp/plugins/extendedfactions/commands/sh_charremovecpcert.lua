--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharRemoveCPCert", {
    description = "Removes a certification to a civil protection unit.",
    accessLevel = cpSystem.config.commandsAccess["remove_cp_cert"],
	arguments = {
		ix.type.character,
		ix.type.string
	},
    OnRun = function(self, client, target, text)
        if(PLUGIN:GetAccessLevel(client:GetCharacter()) >= self.accessLevel) then
            if(PLUGIN:IsMetropolice(target)) then
                if(ix.certs.Get(text)) then
                    if(target:HasCert(text)) then
                        local certs = target:GetData("certs", {})

                        for k, v in pairs(certs) do 
                            if(v == text) then
                                certs[k] = nil
                            end 
                        end

                        target:SetData("certs", certs)
                        client:Notify(string.format("You have removed the certification %s from %s.", text, target:GetName()));
                    else
                        client:Notify("That character doesnt have that certification.");
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