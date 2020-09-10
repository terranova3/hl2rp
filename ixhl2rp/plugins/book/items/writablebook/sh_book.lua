
local PLUGIN = PLUGIN

ITEM.name = "Book"
ITEM.descriptionEmpty = "An empty book."
ITEM.descriptionOwned = "A book that has something written in it."
ITEM.price = 2
ITEM.model = Model("models/props_lab/binderblue.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.classes = {CLASS_EOW}
ITEM.business = true
ITEM.bAllowMultiCharacterInteraction = true

function ITEM:GetDescription()
	return self:GetData("owner", 0) == 0 and self.descriptionEmpty or self.descriptionOwned
end

function ITEM:GetCharacterCount()
	local textArray = self:GetData("text", {})
	local totalChrCount = 0
	for i=1, #textArray do

		if textArray[i] == nil then continue end
		totalChrCount = totalChrCount + textArray[i]:len()
	end
	return totalChrCount
end

function ITEM:SetMarker(markerPos)
	self:SetData("marker", markerPos)
end

function ITEM:SetText(textArray, character)
	-- Trimming last empty pages.
	for i = 1, #textArray do
		if textArray[#textArray + 1 - i] == "" then
			textArray[#textArray + 1 - i] = nil
		else
			break
		end
	end

	-- Making sure no line passes the character per page limit
	for i=1, #textArray do
		textArray[i] = textArray[i] == nil and "" or textArray[i]
		if textArray[i]:len() > PLUGIN.characterLimitPerPage then
			textArray[i] = string.sub(textArray[i],1,PLUGIN.characterLimitPerPage)
		end
	end

	-- Removing last pages if the character count exceeds the limit.
	-- In normal conditions, this procedure should not happen as it's checked on clientside.
	local chrCount = self:GetCharacterCount()
	local chrCountChanged = false

	while(chrCount > PLUGIN.characterLimit) do
		chrCount = self:GetCharacterCount()
		textArray[#textArray] = nil
		chrCountChanged = true
	end

	chrCount = chrCountChanged and self:GetCharacterCount() or chrCount

	self:SetData("text", textArray, nil, false, true)
	-- If the book is empty, make it unowned.
	self:SetData("owner", (character and self:GetCharacterCount() != 0) and character:GetID() or 0)
end

ITEM.functions.View = {
	OnRun = function(item)
		netstream.Start(item.player, "ixViewBook", item:GetID(), item:GetData("text", {}), 0, item:GetData("marker", -1))
		return false
	end,

	OnCanRun = function(item)
		return item:GetData("text", {}) != {}
	end
}

ITEM.functions.Edit = {
	OnRun = function(item)
		netstream.Start(item.player, "ixViewBook", item:GetID(), item:GetData("text", {}), 1, item:GetData("marker", -1))
		return false
	end,

	OnCanRun = function(item)
		local owner = item:GetData("owner", 0)
		return owner == 0 or owner == item.player:GetCharacter():GetID()
	end
}