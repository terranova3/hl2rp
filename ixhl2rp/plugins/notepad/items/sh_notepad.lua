--[[
	� 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

ITEM.name = "Notepad";
ITEM.cost = 5;
ITEM.model = "models/props_office/notepad_terranova.mdl";
ITEM.weight = 0.1;
ITEM.flag = "g"
ITEM.category = "Other"
ITEM.description = "A clean notepad, useful for note taking.";
ITEM.functions.Edit = {
	icon = "icon16/book_edit.png",
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()

		if(item:GetData("character")) then
			if(character:GetID() != item:GetData("character")) then
				return false, "You don't own this notepad!"
			end
		end

		item:SetData("character", character:GetID())
		netstream.Start(client, "ViewNotepad", item:GetData("text"), item.id, true);

		return false
	end
}
ITEM.functions.View = {
	icon = "icon16/book_open.png",
	OnRun = function(item)
		local client = item.player

		netstream.Start(client, "ViewNotepad", item:GetData("text"))

		return false
	end
}
ITEM.functions.take.OnCanRun = function(item)
	local owner = item:GetData("character", 0)

	return IsValid(item.entity) and (owner == 0 or owner == item.player:GetCharacter():GetID())
end
