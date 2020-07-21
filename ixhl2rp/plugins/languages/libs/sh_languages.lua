--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.language = {}
ix.language.stored = {}

function ix.language.Add(acronym, name)
    ix.language.stored[acronym] = name
end

function ix.language.Get(name)
    for k, v in pairs(ix.language.stored) do
        if(name == v) then
            return ix.language.stored[k]
        end
    end
    
    return false
end

function ix.language.Register()
    for abbreviation, language in pairs(ix.language.stored) do
        ix.chat.Register(abbreviation, {
			format = "%s says in " .. language .. ": \"%s\"",
			indicator = "chatTalking",
			GetColor = function(self, speaker, text)
				-- If you are looking at the speaker, make it greener to easier identify who is talking.
				if (LocalPlayer():GetEyeTrace().Entity == speaker) then
					return ix.config.Get("chatListenColor")
				end

				-- Otherwise, use the normal chat color.
				return ix.config.Get("chatColor")
			end,
            CanHear = ix.config.Get("chatRange", 280),
            prefix = {"/"..abbreviation, "/"..language},
            description = "Speaking in ".. language,
            CanSay = function(self, speaker, text)
                if(!speaker:GetCharacter():HasLanguage(language)) then
                    speaker:NotifyLocalized(string.format("You don't have the %s language.", language))
                    
                    return false
                end
                    
                return true
            end,
            OnChatAdd = function(self, speaker, text, bAnonymous, data)   
                if (LocalPlayer():GetCharacter():HasLanguage(language)) then
                    chat.AddText(self.color, string.format(self.format, speaker:GetName(), text))
                else
                    chat.AddText(self.color, string.format("%s says something unintelligible in %s.", speaker:GetName(), text))
                end
            end
		})

    end
end
