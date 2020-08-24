--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

ix.command.Add("CharSetSpec", {
    description = "Adds a certification specialization to a character.",
    permission = "Set spec",
	arguments = {
		ix.type.character,
		ix.type.string
	},
    OnRun = function(self, client, target, text)
        local character = client:GetCharacter()
        local cert = ix.certs.Get(text)
        local canChangeCert, error = ix.certs.CanChangeCert(character, target, cert)
        local certs = target:GetData("certs", {})

        if(cert) then
            if(character:HasOverride() or ix.ranks.HasPermission(character:GetRank().uniqueID, "Remove cert")) then
                if(canChangeCert) then
                    for k, v in pairs(certs) do
                        if(v == text) then
                            certs[k] = nil
                        end
                    end

                    target:SetData("certs", certs)
                    target:SetData("spec", text)

                    target:UpdateCPStatus()

                    client:Notify(string.format("You have given %s the %s specialization.", target:GetName(), cert.name))
                else
                    client:Notify(error)
                end
            end
        else
            client:Notify(string.format("The certification '%s' doesn't exist.", text))
        end
	end;
})