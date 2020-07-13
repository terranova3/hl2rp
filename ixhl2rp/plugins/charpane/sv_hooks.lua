--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- Called when a player enters observer
function PLUGIN:OnPlayerObserve(client, state)
	if(state) then
		local curParts = client:GetParts()

		-- Hide any PACs when going observer.
		if (curParts) then
			client:ResetParts()
		end
	else
		-- Reload the pacs when exiting out of observer.
		local charPanel = client:GetCharacter():GetCharPanel();
		local inv = client:GetCharacter():GetInventory()

		for _, v in pairs(charPanel:GetItems()) do
			if (v.pacData) then
				client:AddPart(v.uniqueID, v)
			end
		end

		for _, v in pairs(inv:GetItems()) do
			if (v:GetData("equip") == true and v.pacData) then
				client:AddPart(v.uniqueID, v)
			end
		end
	end
end

function PLUGIN:CharPanelLoaded(character)
	local charPanel = character:GetCharPanel();

	for _, v in pairs(charPanel:GetItems()) do
		if (v.pacData) then
			character:GetPlayer():AddPart(v.uniqueID, v)
		end
	end
end

-- Called when an item has been added to the character panel
function PLUGIN:CharPanelItemEquipped(client, item)
	if(!item.outfitCategory) then return false end;

	if(item.bodyGroups) then
		local bodygroup = 0

		for _, v in pairs(item.bodyGroups) do 
			bodygroup = v;
		end

		PLUGIN:UpdateBodygroup(client, item.outfitCategory, bodygroup)
	elseif(item.pacData) then
		client:AddPart(item.uniqueID, item)
	end
end;

-- Called when an item has been removed from the character panel
function PLUGIN:CharPanelItemUnequipped(client, item) 
	if(!item.outfitCategory) then return false end;

	if(item.bodyGroups) then
		PLUGIN:UpdateBodygroup(client, item.outfitCategory, 0)
	elseif(item.pacData) then
		client:RemovePart(item.uniqueID)
	end
end;

function PLUGIN:UpdateBodygroup(client, outfitCategory, bodygroup)
	local character = client:GetCharacter()
	local index = client:FindBodygroupByName(outfitCategory)
	local groups = character:GetData("groups", {})

	groups[index] = bodygroup

	character:SetData("groups", groups)
	client:SetBodygroup(index, bodygroup)
	
	net.Start("ixCharPanelUpdateModel")
		net.WriteUInt(index, 8)
		net.WriteUInt(bodygroup, 8)
	net.Send(client)
end