
ix.command.Add("CharPhysDesc", {
	description = "@cmdCharDesc",
	arguments = bit.bor(ix.type.text, ix.type.optional),
    OnRun = function(self, client, description)
        local character = client:GetCharacter()

        if (!description:find("%S")) then
            local displayDesc = character:GetDescription()
            local title = "@cmdCharDescTitle"

            if(character:IsUndercover()) then
                title = "Set your citizen description."
                displayDesc = character:GetData("cpCitizenDesc", "")
            elseif(character:IsMetropolice()) then
                title = "Set your unit description."
                displayDesc = character:GetData("cpDesc", "")
            end

			return client:RequestString(title, "@cmdCharDescDescription", function(text)
				ix.command.Run(client, "CharPhysDesc", {text})
			end, displayDesc)
		end

		local info = ix.char.vars.description
		local result, fault, count = info:OnValidate(description)

		if (result == false) then
			return "@" .. fault, count
		end

        if(character:IsUndercover()) then
            character:SetData("cpCitizenDesc", description)
        elseif(character:IsMetropolice()) then
            character:SetData("cpDesc", description)
        end

        character:SetDescription(description)

		return "@descChanged"
	end
})