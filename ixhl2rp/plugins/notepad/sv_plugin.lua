--[[
	� 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

netstream.Hook("EditNotepad", function(client, text, id)
	local item = ix.item.instances[id]

	-- Make sure the item exists and the item is a notepad if it does.
	if(!item or item.uniqueID != "notepad") then
		return
	end

	-- Make sure the client requesting to edit the notepad is allowed to actually edit it.
	if(item:GetData("character") and item:GetData("character") != client:GetCharacter():GetID()) then
		return
	end

	item:SetData("text", string.sub(text, 0, 1000));

	if(!item:GetData("character")) then
		item:SetData("character", client:GetCharacter():GetID())
	end
end);