--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

PLUGIN.name = "Extended Roleplay Commands";
PLUGIN.description = "Adds additional roleplay commands that aren't in base helix.";
PLUGIN.author = "Adolphus";

ix.config.Add("yellRange", 280, "The maximum distance a person's IC chat message goes to.", nil, {
	data = {min = 10, max = 5000, decimals = 1},
	category = "chat"
})

ix.chat.Register("meL", {
	OnChatAdd = function(self, speaker, text, anonymous)
		if (!IsValid(speaker)) then
			return
		end
		local name = anonymous and
		L"someone" or hook.Run("GetCharacterName", speaker, "me") or
		(IsValid(speaker) and speaker:Name() or "Console")

		local chatColor = ix.config.Get("chatColor")
		chatColor = Color(chatColor.r + 35, chatColor.g + 35, chatColor.b + 35)

		if(ix.option.Get("factionNameColor", false)) then
			chat.AddText(chatColor, "*** ", speaker:GetCharacter():GetClassColor(), name, chatColor, " ", text)
		else
			chat.AddText(chatColor, "*** ", name, " ", text)
		end
	end,
	CanHear = ix.config.Get("chatRange", 280) * 2,
	prefix = {"/MeL", "/ActionL"},
	description = "Perform a physical action loudly.",
	indicator = "chatPerforming",
	deadCanChat = true
})

ix.chat.Register("meC", {
	OnChatAdd = function(self, speaker, text, anonymous)
		if (!IsValid(speaker)) then
			return
		end

		local name = anonymous and
		L"someone" or hook.Run("GetCharacterName", speaker, "me") or
		(IsValid(speaker) and speaker:Name() or "Console")

		local chatColor = ix.config.Get("chatColor")
		chatColor = Color(chatColor.r - 35, chatColor.g - 35, chatColor.b - 35)

		if(ix.option.Get("factionNameColor", false)) then
			chat.AddText(chatColor, "* ", speaker:GetCharacter():GetClassColor(), name, chatColor, " ", text)
		else
			chat.AddText(chatColor, "* ", name, " ", text)
		end
	end,
	CanHear = ix.config.Get("chatRange", 280) * 0.25,
	prefix = {"/MeC", "/ActionC"},
	description = "Perform a physical action quietly.",
	indicator = "chatPerforming",
	deadCanChat = true
})

ix.chat.Register("itL", {
	GetColor = function(self, speaker, text)
		local color = ix.config.Get("chatColor")

		return Color(color.r + 35, color.g + 35, color.b + 35)
	end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(ix.config.Get("chatColor"), "*** "..text)
	end,
	CanHear = ix.config.Get("chatRange", 280) * 2,
	prefix = {"/ItL"},
	description = "Make something around you perform an action loudly.",
	indicator = "chatPerforming",
	deadCanChat = true
})

ix.chat.Register("itC", {
	GetColor = function(self, speaker, text)
		local color = ix.config.Get("chatColor")

		return Color(color.r - 35, color.g - 35, color.b - 35)
	end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(ix.config.Get("chatColor"), "* "..text)
	end,
	CanHear = ix.config.Get("chatRange", 280) * 0.25,
	prefix = {"/ItC"},
	description = "Make something around you perform an action quietly.",
	indicator = "chatPerforming",
	deadCanChat = true
})

if(CLIENT) then
	CHAT_RECOGNIZED = CHAT_RECOGNIZED or {}
	CHAT_RECOGNIZED["itC"] = true
	CHAT_RECOGNIZED["itL"] = true
	CHAT_RECOGNIZED["meC"] = true
	CHAT_RECOGNIZED["meL"] = true
end
