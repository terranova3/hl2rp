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
                    speaker:NotifyLocalized(string.format("You don't know how to speak %s.", language))
                    
                    return false
                end
                    
                return true
            end,
            OnChatAdd = function(self, speaker, text, bAnonymous, data)   
                local name = anonymous and
				L"someone" or hook.Run("GetCharacterName", speaker, language) or
                (IsValid(speaker) and speaker:Name() or "Console")

                if(ix.option.Get("factionNameColor", false)) then
                    if (LocalPlayer():GetCharacter():HasLanguage(language)) then
                        chat.AddText(speaker:GetCharacter():GetClassColor(), name, self.color, " speaks in " .. language .. ": ", string.format("\"%s\"", text))
                    else
                        chat.AddText(speaker:GetCharacter():GetClassColor(), name, self.color, " says something unintelligible in " .. language .. ".")
                    end
                else
                    if (LocalPlayer():GetCharacter():HasLanguage(language)) then
                        chat.AddText(self.color, name, " speaks in ".. language ..": ", string.format("\"%s\"", text))
                    else
                        chat.AddText(self.color, string.format("%s says something unintelligible in %s.", name, language))
                    end
                end
            end
        })
        
        if(CLIENT) then
            CHAT_RECOGNIZED = CHAT_RECOGNIZED or {}
            CHAT_RECOGNIZED[language] = true
            CHAT_RECOGNIZED[abbreviation] = true
        end

        --ix.language.RegisterItem(abbreviation, language)
    end
end

function ix.language.RegisterItem(k, v)
	local ITEM = ix.item.Register( "book_" .. k, nil, nil, nil, true)
    ITEM.name = v .. " For Dummies"
    ITEM.description = string.format("A hefty book packed with information about the %s language.", v)
    ITEM.model = "models/gibs/props_office/books_3_gib1.mdl"
    ITEM.category = "Literature"
    ITEM.language = v
    ITEM.flag = "l"
    ITEM.functions.learn = {
        name = "Learn Language",
        icon = "icon16/book_open.png",
        OnRun = function(itemTable, data)
            local character = itemTable.player:GetCharacter()

            if(character:HasLanguage(itemTable.language)) then
                itemTable.player:Notify(string.format("You already know the %s language!", itemTable.language))

                return false
            end

            character:AddLanguage(itemTable.language)
            itemTable.player:Notify(string.format("You have learned the %s language.", itemTable.language))
        end
    }

    function ITEM:GetModel()
        local models = {
            "models/gibs/props_office/books_3_gib2.mdl",
            "models/gibs/props_office/books_3_gib3.mdl",
            self.model
        }

        return models[math.random(1, 3)]
    end
end

