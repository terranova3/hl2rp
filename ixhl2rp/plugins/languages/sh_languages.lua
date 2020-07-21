--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

--- Registers a new language with the information provided.
-- @realm shared
-- @string acronym - Becomes the shorthand command in the chat.
-- @string name - Name of the language as a variable, this is what you use to assign it.
-- @assignment - /CharSetLanguage <name>

ix.language.Add("ara", "Arabic")
ix.language.Add("pol", "Polish")
ix.language.Add("ger", "German")
ix.language.Add("yid", "Yiddish")

ix.language.Register()
