local PLUGIN = PLUGIN

netstream.Hook("ix_token_distr_request", function(client, paygradeIndex, workerCount, entity)
	local workerCountNum = tonumber(workerCount)
	local paygradeIndexNum = tonumber(paygradeIndex)

	if workerCountNum == nil then return end
	if paygradeIndexNum == nil then return end

	if !IsValid(entity) then return end
	if entity:GetClass() != "ix_tokendistributor" then return end

	if workerCountNum < 1 or workerCountNum > PLUGIN.MaxWorkerCount then return end
	local paygrade = PLUGIN.Paygrades[paygradeIndexNum]
	if paygrade == nil then return end

	local character = client:GetCharacter()
	if !character then return end

	if character:GetClass() == 	CLASS_MM then
		local tokensToGive = workerCountNum * paygrade[2]
		entity:GiveTokens(character, tokensToGive)
	end
end)


netstream.Hook("ix_token_distr_toggle", function(client, entity)
	local character = client:GetCharacter()
	if character then
		if character:GetFaction() == FACTION_ADMIN then
			if IsValid(entity) and entity:GetClass() == "ix_tokendistributor" then
				entity:ToggleActivity()
			end
		end
	end

end)