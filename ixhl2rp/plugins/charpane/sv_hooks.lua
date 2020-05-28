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
function PLUGIN:CharPanelItemEquipped(client, item)
	if(!item.outfitCategory) then return false end;
	local bodygroup = 0

	for _, v in pairs(item.bodyGroups) do 
		bodygroup = v;
	end

	PLUGIN:UpdateBodygroup(client, item.outfitCategory, bodygroup)
end;

-- Called when an item has been removed from the character panel
function PLUGIN:CharPanelItemUnequipped(client, item) 
	if(!item.outfitCategory) then return false end;

	PLUGIN:UpdateBodygroup(client, item.outfitCategory, 0)
end;

function PLUGIN:UpdateBodygroup(client, outfitCategory, bodygroup)
	local character = client:GetCharacter()
	local index = client:FindBodygroupByName(outfitCategory)
	local groups =character:GetData("groups", {})

	groups[index] = bodygroup

	character:SetData("groups", groups)
	client:SetBodygroup(index, bodygroup)
	
	net.Start("ixCharPanelUpdateModel")
		net.WriteUInt(index, 8)
		net.WriteUInt(bodygroup, 8)
	net.Send(client)
end

-- Called when the client is checking if it has access to see the character panel
function PLUGIN:CharPanelShouldShow(client)
	return true;
end;

netstream.Hook("RequestShowCharacterPanel", function(client)
	local show = hook.Run("CharPanelShouldShow", client)
	netstream.Start(client, "ShowCharacterPanel", show)
end)

netstream.Hook("UpdateCharacterModel", function(client)
	local bodygroups = client:GetCharacter():GetData("groups", nil)

	-- We send the message regardless if bodygroups is valid, because we need to tell the client to show their model.
	net.Start("ixCharPanelLoadModel")
		net.WriteTable(bodygroups or {})
	net.Send(client)
end)