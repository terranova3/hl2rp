--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.command.Add("CharAddCert", {
    description = "Adds a certification to a player.",
    permission = "Add cert",
	arguments = {
		ix.type.character,
		ix.type.string
	},
    OnRun = function(self, client, target, text)
        local character = client:GetCharacter()
        local cert = ix.certs.Get(text)
        local canChangeCert, error = ix.certs.CanChangeCert(character, target, cert)

        if(cert) then
            if(character:HasOverride() or ix.ranks.HasPermission(character:GetRank().uniqueID, "Add cert")) then
                if(canChangeCert) then
                    if(!target:HasCert(cert.uniqueID) and !target:HasSpec(cert.uniqueID)) then
                        local certs = target:GetData("certs", {})
                        table.insert(certs, cert.uniqueID)

                        target:SetData("certs", certs)
                
                        client:Notify(string.format("You have given %s the %s certification.", target:GetName(), cert.name))
                    else
                        client:Notify(string.format("Your target already has the %s certification.", cert.name))
                    end
                else
                    client:Notify(error)
                end
            end
        else
            client:Notify(string.format("The certification '%s' doesn't exist.", text))
        end
	end;
})