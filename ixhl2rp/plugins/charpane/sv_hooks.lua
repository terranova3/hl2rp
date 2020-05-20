--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- Called during character setup
function PLUGIN:CharacterLoaded(character)
	local client = character:GetPlayer()
	local charPanel = character:GetCharPanel();

	-- Makes the client a receiver for the charPanel sync.
	charPanel:AddReceiver(client)
	
	-- Send all the data to the client
	charPanel:Sync(client)
end;

-- Called when an item has been added to the character panel
function PLUGIN:CharPanelItemEquipped(client, inventory, charPanel, item) end;

-- Called when the client is checking if it has access to see the character panel
function PLUGIN:CharPanelShouldShow(client)
	return false;
end;

netstream.Hook("RequestShowCharacterPanel", function(client)
	local show = hook.Run("CharPanelShouldShow", client) or true
	netstream.Start(client, "ShowCharacterPanel", show)
end)