PLUGIN.name = "Admin Spawn Menu"
PLUGIN.author = "Pilot | Ported to helix: JohnyReaper"
PLUGIN.desc = "Allow admins to easily spawn items."

if (SERVER) then
	util.AddNetworkString("adminSpawnMenu")
	util.AddNetworkString("adminSpawnItem")

	ix.log.AddType("adminSpawnItemLog", function(client, name)
	return string.format("%s has spawned \"%s\"", client:GetCharacter():GetName(), tostring(name))
	end)

	net.Receive("adminSpawnItem", function(len, client)
		local name = net.ReadString()
		if (!client:IsAdmin()) then return end
		if (!client:Alive()) then return end
		for k, v in pairs(ix.item.list) do
			if v.name == name then
				ix.item.Spawn(v.uniqueID, client:GetShootPos() + client:GetAimVector()*84 + Vector(0, 0, 16))
				ix.log.Add(client, "adminSpawnItemLog", v.name)
				break
			end
		end
	end)
end

ix.command.Add("adminspawnmenu", {
    adminOnly = true,
	OnRun = function(self, client)
		net.Start("adminSpawnMenu")
		net.Send(client)
	end
})

if (CLIENT) then
	net.Receive("adminSpawnMenu",function()
		local background = vgui.Create("DFrame")
		background:SetSize(ScrW() / 2, ScrH() / 2)
		background:Center()
		background:SetTitle("Admin Spawn Menu")
		background:MakePopup()
		background:ShowCloseButton(true)

		scroll = background:Add("DScrollPanel")
		scroll:Dock(FILL)

		categoryPanels = {}

		for k, v in pairs(ix.item.list) do
			if (!categoryPanels[L(v.category)]) then
				categoryPanels[L(v.category)] = v.category
			end
		end
		
		for category, realName in SortedPairs(categoryPanels) do
			local collapsibleCategory = scroll:Add("DCollapsibleCategory")
			collapsibleCategory:SetTall(36)
			collapsibleCategory:SetLabel(category)
			collapsibleCategory:Dock(TOP)
			collapsibleCategory:SetExpanded(0)
			collapsibleCategory:DockMargin(5, 5, 5, 0)
			collapsibleCategory.category = realName

			for k, v in pairs(ix.item.list) do
				if (v.category) == collapsibleCategory.category then
					local item = collapsibleCategory:Add("DButton")
					item:SetText(v.name)
					item:SetTextColor( Color(255,255,255, 255) )
					item:SizeToContents()
					item.DoClick = function()
						net.Start("adminSpawnItem")
						net.WriteString(v.name)
						net.SendToServer()
						surface.PlaySound("buttons/button14.wav")
					end
				end
			end

			categoryPanels[realName] = collapsibleCategory
		end
	end)
end