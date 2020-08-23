--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

PLUGIN.name = "Faction Colored Chat";
PLUGIN.description = "Adds an option for enabling character names to be based on their faction colour for the chatbox.";
PLUGIN.author = "Adolphus";

ix.option.Add("factionNameColor", ix.type.bool, true, {
    category = "Chat"
})

hook.Add("InitializedConfig", "ixChatTypes", function()
    ix.chat.Register("ic", {
        format = "%s says \"%s\"",
        indicator = "chatTalking",
        OnChatAdd = function(self, speaker, text, anonymous)
            if (!IsValid(speaker)) then
                return
            end

            local name = anonymous and
            L"someone" or hook.Run("GetCharacterName", speaker, "me") or
            (IsValid(speaker) and speaker:Name() or "Console")

            local chatColor = ix.config.Get("chatColor")

            if (LocalPlayer():GetEyeTrace().Entity == speaker) then
                chatColor = ix.config.Get("chatListenColor")
            end

            if(ix.option.Get("factionNameColor", false)) then
                chat.AddText(speaker:GetCharacter():GetClassColor(), name, chatColor, " says ", string.format("\"%s\"", text))
            else
                chat.AddText(chatColor, name, " says ", string.format("\"%s\"", text))
            end
        end,
        CanHear = ix.config.Get("chatRange", 280)
    })

    -- Actions and such.
    ix.chat.Register("me", {
        CanHear = ix.config.Get("chatRange", 280) * 2,
        OnChatAdd = function(self, speaker, text, anonymous)
            if (!IsValid(speaker)) then
                return
            end

            local name = anonymous and
            L"someone" or hook.Run("GetCharacterName", speaker, "me") or
            (IsValid(speaker) and speaker:Name() or "Console")

            local chatColor = ix.config.Get("chatColor")

            if(ix.option.Get("factionNameColor", false)) then
                chat.AddText(chatColor, "** ", speaker:GetCharacter():GetClassColor(), name, chatColor, " ", text)
            else
                chat.AddText(chatColor, "** ", name, " ", text)
            end
        end,
        prefix = {"/Me", "/Action"},
        description = "@cmdMe",
        indicator = "chatPerforming",
        deadCanChat = true
    })

    -- Actions and such.
    ix.chat.Register("it", {
        OnChatAdd = function(self, speaker, text, anonymous)
            chat.AddText(ix.config.Get("chatColor"), "** "..text)
        end,
        CanHear = ix.config.Get("chatRange", 280) * 2,
        prefix = {"/It"},
        description = "@cmdIt",
        indicator = "chatPerforming",
        deadCanChat = true
    })

    -- Whisper chat.
    ix.chat.Register("w", {
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
                chat.AddText(speaker:GetCharacter():GetClassColor(), name, chatColor, " whispers ", string.format("\"%s\"", text))
            else
                chat.AddText(chatColor, name, " whispers ", string.format("\"%s\"", text))
            end
        end,
        CanHear = ix.config.Get("chatRange", 280) * 0.25,
        prefix = {"/W", "/Whisper"},
        description = "@cmdW",
        indicator = "chatWhispering"
    })

    -- Yelling out loud.
    ix.chat.Register("y", {
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
                chat.AddText(speaker:GetCharacter():GetClassColor(), name, chatColor, " yells ", string.format("\"%s\"", text))
            else
                chat.AddText(chatColor, name, " yells ", string.format("\"%s\"", text))
            end
        end,
        CanHear = ix.config.Get("chatRange", 280) * 2,
        prefix = {"/Y", "/Yell"},
        description = "@cmdY",
        indicator = "chatYelling"
    })

    -- Out of character.
    ix.chat.Register("ooc", {
        CanSay = function(self, speaker, text)
            if (!ix.config.Get("allowGlobalOOC")) then
                speaker:NotifyLocalized("Global OOC is disabled on this server.")
                return false
            else
                local delay = ix.config.Get("oocDelay", 10)

                -- Only need to check the time if they have spoken in OOC chat before.
                if (delay > 0 and speaker.ixLastOOC) then
                    local lastOOC = CurTime() - speaker.ixLastOOC

                    -- Use this method of checking time in case the oocDelay config changes.
                    if (lastOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
                        speaker:NotifyLocalized("oocDelay", delay - math.ceil(lastOOC))

                        return false
                    end
                end

                -- Save the last time they spoke in OOC.
                speaker.ixLastOOC = CurTime()
            end
        end,
        OnChatAdd = function(self, speaker, text)
            if (!IsValid(speaker)) then
                return
            end

            local icon = "icon16/user.png"

            icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

            chat.AddText(icon, Color(255, 50, 50), "[OOC] ", speaker:GetCharacter():GetClassColor(), speaker:Name(), color_white, ": "..text)
        end,
        prefix = {"//", "/OOC"},
        description = "@cmdOOC",
        noSpaceAfter = true
    })

    -- Local out of character.
    ix.chat.Register("looc", {
        CanSay = function(self, speaker, text)
            local delay = ix.config.Get("loocDelay", 0)

            -- Only need to check the time if they have spoken in OOC chat before.
            if (delay > 0 and speaker.ixLastLOOC) then
                local lastLOOC = CurTime() - speaker.ixLastLOOC

                -- Use this method of checking time in case the oocDelay config changes.
                if (lastLOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
                    speaker:NotifyLocalized("loocDelay", delay - math.ceil(lastLOOC))

                    return false
                end
            end

            -- Save the last time they spoke in OOC.
            speaker.ixLastLOOC = CurTime()
        end,
        OnChatAdd = function(self, speaker, text)
            chat.AddText(Color(255, 50, 50), "[LOOC] ", ix.config.Get("chatColor"), speaker:Name()..": "..text)
        end,
        CanHear = ix.config.Get("chatRange", 280),
        prefix = {".//", "[[", "/LOOC"},
        description = "@cmdLOOC",
        noSpaceAfter = true
    })

    -- Roll information in chat.
    ix.chat.Register("roll", {
        format = "** %s has rolled %s out of %s.",
        color = Color(155, 111, 176),
        CanHear = ix.config.Get("chatRange", 280),
        deadCanChat = true,
        OnChatAdd = function(self, speaker, text, bAnonymous, data)
            chat.AddText(self.color, string.format(self.format,
                speaker:GetName(), text, data.max or 100
            ))
        end
    })

    -- run a hook after we add the basic chat classes so schemas/plugins can access their info as soon as possible if needed
    hook.Run("InitializedChatClasses")
end)