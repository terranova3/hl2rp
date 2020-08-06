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
	format = "** %s %s",
	GetColor = function(self, speaker, text)
		local color = ix.chat.classes.ic:GetColor(speaker, text)

		return Color(color.r + 35, color.g + 35, color.b + 35)
	end,
	CanHear = ix.config.Get("yellRange", 280) * 2,
	prefix = {"/MeL", "/ActionL"},
	description = "@cmdMeL",
	indicator = "chatPerforming",
	deadCanChat = true
})

ix.chat.Register("meC", {
	format = "** %s %s",
	GetColor = function(self, speaker, text)
		local color = ix.chat.classes.ic:GetColor(speaker, text)

		return Color(color.r - 35, color.g - 35, color.b - 35)
	end,
	CanHear = ix.config.Get("chatRange", 280) * 0.25,
	prefix = {"/MeC", "/ActionC"},
	description = "@cmdMeC",
	indicator = "chatPerforming",
	deadCanChat = true
})

ix.chat.Register("itL", {
	GetColor = function(self, speaker, text)
		local color = ix.chat.classes.ic:GetColor(speaker, text)

		return Color(color.r + 35, color.g + 35, color.b + 35)
	end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(ix.config.Get("chatColor"), "** "..text)
	end,
	CanHear = ix.config.Get("yellRange", 280) * 2,
	prefix = {"/ItL"},
	description = "@cmdItL",
	indicator = "chatPerforming",
	deadCanChat = true
})

ix.chat.Register("itC", {
	GetColor = function(self, speaker, text)
		local color = ix.chat.classes.ic:GetColor(speaker, text)

		return Color(color.r - 35, color.g - 35, color.b - 35)
	end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(ix.config.Get("chatColor"), "** "..text)
	end,
	CanHear = ix.config.Get("chatRange", 280) * 0.25,
	prefix = {"/ItC"},
	description = "@cmdItC",
	indicator = "chatPerforming",
	deadCanChat = true
})