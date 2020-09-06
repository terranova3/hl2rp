PLUGIN.name = "Scoreboard Admin Options"
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.description = "Adds scoreboard options for admins."

hook.Add("PopulateScoreboardPlayerMenu", "ixAdmin", function(client, menu)
	local options = {}

	if(LocalPlayer():IsAdmin()) then
		options["Give Whitelist"] = {
			function()
				if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
				local menu = vgui.Create("DFrame")
				menu:SetSize(ScrW() / 6, ScrH() / 3)
				menu:MakePopup()
				menu:Center()
				menu:SetTitle("Player Whitelist Menu")

				local panel = menu:Add("DScrollPanel")
				panel:Dock(FILL)

				for k, v in SortedPairs(ix.faction.indices) do
					local button = vgui.Create("DButton", panel)
					button:Dock(TOP)
					button:SetSize(20,30)
					button:SetText(L(v.name))
					button:SetFont("ixSmallFont")
					button:DockMargin(4,4,4,4)

					function button:DoClick()
						ix.command.Send("PlyWhitelist", client:Name(), v.name)
						button:Remove()
					end

					function button.Paint(w, h)
						local factionColor = v.color
						factionColor.a = 50

						derma.SkinFunc("PaintCategoryPanel", button, "", factionColor)

						surface.SetTextColor(Color(255,255,255,255))
						surface.SetTextPos(4, 4)
					end

					if(client:HasWhitelist(v.index)) then
						button:Remove()
					end
				end
			end
		}

		options["Give Flag"] = {
			function()
				if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
				local menu = vgui.Create("DFrame")
				menu:SetSize(ScrW() / 6, ScrH() / 3)
				menu:MakePopup()
				menu:Center()
				menu:SetTitle("Character Flag Menu")

				local panel = menu:Add("DScrollPanel")
				panel:Dock(FILL)

				for k, v in SortedPairs(ix.flag.list) do
					local button = vgui.Create("DButton", panel)
					button:Dock(TOP)
					button:SetSize(20,30)
					button:SetText(L(k) .. " - " .. v.description)
					button:SetFont("ixSmallFont")
					button:DockMargin(4,4,4,4)

					function button:DoClick()
						ix.command.Send("CharGiveFlag", client:Name(), k)
						button:Remove()
					end

					function button.Paint(w, h)
						derma.SkinFunc("PaintCategoryPanel", button, "", Color(0,0,0,100))

						surface.SetTextColor(Color(255,255,255,255))
						surface.SetTextPos(4, 4)
					end

					if(client:GetCharacter():HasFlags(k)) then
						button:Remove()
					end
				end
			end
		}

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

		options["Set Custom Class"] = {
			function()
				if LocalPlayer():IsAdmin() == false then ix.util.Notify("This function is only available for admins.") return end
				if (IsValid(client) and LocalPlayer():IsAdmin()) then
					Derma_StringRequest("Change Character Class", "What do you want to change this character's name to?", client:GetCharacter():GetCustomClass(), function(text)
						ix.command.Send("CharSetCustomClass", client:Name(), text)
					end, nil, "Change", "Cancel")
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

		options["Manage Blueprints"] = {
			function()
				if LocalPlayer():IsAdmin() == false then 
					ix.util.Notify("This function is only available for admins.") 
					return 
				end

				if(IsValid(ix.gui.menu)) then
					ix.gui.menu:Remove()
				end

				local management = vgui.Create("ixBlueprintManagement")
				management:MakePopup()
				management:SetCharacter(client:GetCharacter():GetID())
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
	end
	
	for k, v in pairs(options) do
		menu:AddOption(k,v[1])
	end
end)