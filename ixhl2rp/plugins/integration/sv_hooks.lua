--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN
PLUGIN.api = "https://donate.terranova-rp.com/api.php?hash=1563de5ce0a757ef408383c20af60a9c&action=getTransactions"

-- Called when a player spawns.
function PLUGIN:PlayerSpawn(client)
	self:GetTransactions(client)
end

-- Called when we need to get all the transactions for a client.
function PLUGIN:GetTransactions(client)
	if(!IsValid(client) or client:IsBot()) then
		return
	end

	http.Post(self.api, {
		steamid = client:SteamID64()
	}, function(result)
		self:ReceivedTransactions(client, result)
	end, function(failed)
		self:ReceiveFailed(client, result)
	end)
end

-- Called when the asynchronous post operation is complete.
function PLUGIN:ReceivedTransactions(client, result)
	local response = util.JSONToTable(result)

	PrintTable(response)
end

-- Called when there was an error with the POST operation.
function PLUGIN:ReceiveFailed(client, result)
	ErrorNoHalt(string.format("%s's transaction failed. Error: %s", client:GetName(), result))
end

-- Called when we need to remove donator from a client.
function PLUGIN:RemoveDonator(client)
end

-- Called when we need to make a client a donator.
function PLUGIN:MakeDonator(client)
end