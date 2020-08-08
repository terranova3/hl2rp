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

ix.option.Add("toggleAlert", ix.type.bool, false, {
	category = "Admin Settings",
	hidden = function()
		return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - TERRANOVA", nil)
	end
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
		local color = team.GetColor(speaker:Team())
		icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)

		if(CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Admin Chat", nil) and CAMI.PlayerHasAccess(speaker, "Helix - Admin Chat", nil)) then
			chat.AddText(icon, Color(65, 129, 129), "@staff - ", Color(225,225,225), speaker:SteamName(), ": ", Color(200, 200, 200), text)
		end
	end,
	prefix = "/a"
})

ix.chat.Register("adminrequest", {
	format = "whocares",
	OnGetColor = function(self, speaker, text)
		return Color(0, 196, 255)
	end,
	OnCanHear = function(self, speaker, listener)
		if listener:IsAdmin() or listener == speaker then
			return true
		end

		return false
	end,
	OnChatAdd = function(self, speaker, text)
		local schar = speaker:GetChar()
		local color = team.GetColor(speaker:Team())
		local whitelist = {"STEAM_1:0:17704583", "STEAM_0:1:34297953", "STEAM_1:1:53007042"}
		if LocalPlayer():IsAdmin() or speaker == LocalPlayer() then
			chat.AddText(Color(225, 50, 50, 255), "[REPORT] ", Color(190, 90, 90), speaker:Name(), color, " (", speaker:SteamName(), "): ", Color(255, 255, 255, 255), text)
		end
        if CLIENT then
			if(ix.option.Get("toggleAlert")) then
				if not LocalPlayer().nextbellproc or LocalPlayer().nextbellproc <= CurTime() then
					surface.PlaySound("hl1/fvox/bell.wav")
					LocalPlayer().nextbellproc = CurTime() + 5
				end
			end
		end
	end
})

ix.command.Add("ar", {
	syntax = "<string message>",
	description = "Send a message to the admins.",
	OnRun = function(self, client, arguments)
		local text = table.concat(arguments, " ")
		local admintable = {}

		ix.chat.Send(client, "adminrequest", text)

		for k, v in pairs(player.GetAll()) do
			if v:IsAdmin() then
				table.insert(admintable, v:Name())
			end
		end

		ix.log.AddRaw(client:Name() .. " requested an admin: '" .. text .. "' | Admins Online: " .. table.concat(admintable, ", "))

		return true
	end
})