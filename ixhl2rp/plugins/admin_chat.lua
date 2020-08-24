PLUGIN.name = "Admin chat"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "Adds admin chat to HELIX."

CAMI.RegisterPrivilege({
	Name = "Helix - TERRANOVA",
	MinAccess = "admin"
})

CAMI.RegisterPrivilege({
	Name = "Helix - Admin Chat",
	MinAccess = "admin"
})

ix.chat.Register("adminchat", {
	format = "whocares",
	OnGetColor = function(self, speaker, text)
		return Color(0, 196, 255)
	end,
	OnCanHear = function(self, speaker, listener)
		if(CAMI.PlayerHasAccess(listener, "Helix - Admin Chat", nil)) then
			return true
		end

		return false
	end,
	OnCanSay = function(self, speaker, text)
		if(CAMI.PlayerHasAccess(speaker, "Helix - Admin Chat", nil)) then
			speaker:Notify("You aren't an admin. Use '@messagehere' to create a ticket.")

			return false
		end

		return true
	end,
	OnChatAdd = function(self, speaker, text)
		icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

		if(CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Admin Chat", nil) and CAMI.PlayerHasAccess(speaker, "Helix - Admin Chat", nil)) then
			chat.AddText(icon, Color(65, 129, 129), "@staff - ", Color(225,225,225), speaker:SteamName(), ": ", Color(200, 200, 200), text)
		end
	end,
	prefix = "/a"
})