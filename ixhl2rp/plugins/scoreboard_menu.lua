PLUGIN.name = "Scoreboard Admin Options"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "Adds scoreboard options for admins."

hook.Add("PopulateScoreboardPlayerMenu", "ixAdmin", function(client, menu)
	local options = {}
	options["Set Name"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Change Character Name", "What do you want to change this character's name to?", client:Name(), function(text)
					ix.command.Send("CharSetName", client:Name(), text)
				end, nil, "Change", "Cancel")
			end
		end
	}

	options["Set Health"] = {
		
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Change Character Health", "What do you want to change their health to?", client:Health(), function(text)
					ix.command.Send("PlySetHP", client:Name(), text, "true") --Need to put ix.type.bools in quotes????
				end, nil, "Set", "Cancel")
			end
		end
	}

	options["Set Armor"] = {
		
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Change Character Armor", "What do you want to change their armor to?", client:Armor(), function(text)
					ix.command.Send("PlySetArmor", client:Name(), text, "true")
				end, nil, "Set", "Cancel")
			end
		end
	}

	options["Kick Player"] = {
		
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Kick Player", "Why do you want to kick them?", "", function(text)
					ix.command.Send("PlyKick", client:Name(), text)
				end, nil, "Kick", "Cancel")
			end
		end
	}

	options["Ban Player"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Ban Reason", "Why do you want to ban them?", "", function(text)
					--ix.command.Send("PlyBan", client:Name(), text)
					Derma_StringRequest("Ban Length","For how long do you want to ban them? 0 is permanent.","",function(text2) ix.command.Send("PlyBan", client:Name(), text2, text) end, nil)
				end, nil, "Ban", "Cancel")
			end
		end
	}

		options["Change Model"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			if (IsValid(client) and LocalPlayer():IsAdmin()) then
				Derma_StringRequest("Change Character Model", "What do you want to change this character's model to?", client:GetModel(), function(text)
					ix.command.Send("CharSetModel", client:Name(), text)
				end, nil, "Change", "Cancel")
			end
		end
	}

		options["Give Item"] = {
		function()
			if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
			local menu = vgui.Create("DFrame")
			menu:SetSize(ScrW() / 6, ScrH() / 3)
			menu:MakePopup()
			menu:Center()
			menu:SetTitle("Character Item Menu")
			local panel = menu:Add("DScrollPanel")
			panel:Dock(FILL)
			local header = panel:Add("DLabel")
			header:Dock(TOP)
			header:SetText("Use the box to search for an item.")
			header:SetTextInset(3, 0)
			header:SetFont("ixMediumFont")
			header:SetTextColor(color_white)
			header:SetExpensiveShadow(1, color_black)
			header:SetTall(25)

			header.Paint = function(this, w, h)
				surface.SetDrawColor(ix.config.Get("color"))
				surface.DrawRect(0, 0, w, h)
			end
			local entry = menu:Add("DTextEntry")
			entry:Dock(TOP)
			for k, v in SortedPairs(ix.item.list) do
				local button = vgui.Create("DButton", panel)
				button:Dock(TOP)
				button:SetSize(20,30)
				button:SetText(L(v.name))
				function button:DoClick()
					ix.command.Send("CharGiveItem", client:Name(), v.uniqueID, 1)
				end
				function button.Paint()
					surface.SetDrawColor(Color(200,200,200,255))
				end
				function button:Think()
					if string.len(entry:GetText()) < 1 then self:Show() return end
					if not string.find(v.name, entry:GetText()) then
						panel:SetVerticalScrollbarEnabled(true)
						panel:ScrollToChild(self)
					else
						panel:SetVerticalScrollbarEnabled(true)
						--panel:ScrollToChild()
					end
				end
			end
		end
	}
	for k, v in pairs(options) do
		menu:AddOption(k,v[1])
	end
end)