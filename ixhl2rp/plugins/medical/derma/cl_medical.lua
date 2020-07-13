hook.Add("CreateMenuButtons", "ixInventory", function(tabs)
	tabs["inv"] = {
		bDefault = true,
		Create = function(info, container)				
			local characterPanel = container:Add("DPanel")
			characterPanel.Paint = function() end;
			characterPanel:SetSize(400, container:GetTall());
			characterPanel:Dock(LEFT)	

			local inventoryPanel = container:Add("DPanel");
			inventoryPanel.Paint = function() end;
			inventoryPanel:SetSize(container:GetWide(), container:GetTall());
			inventoryPanel:Dock(FILL)

			netstream.Start("CharacterPanelUpdate")
			netstream.Hook("ShowCharacterPanel", function(show)
				if(IsValid(ix.gui.charPanel)) then
					ix.gui.charPanel:Remove()
				end
				
				if(show) then 
					local cPanel = characterPanel:Add("ixCharacterPane")
					local charPanel = LocalPlayer():GetCharacter():GetCharPanel()

					if (charPanel) then
						cPanel:SetCharPanel(charPanel)
					end

					ix.gui.charPanel = cPanel
				end
			end)

			local canvas = inventoryPanel:Add("DTileLayout")

			local canvasLayout = canvas.PerformLayout
			canvas.PerformLayout = nil -- we'll layout after we add the panels instead of each time one is added
			canvas:SetBorder(0)
			canvas:SetSpaceX(2)
			canvas:SetSpaceY(2)
			canvas:Dock(FILL)

			ix.gui.menuInventoryContainer = canvas

			local panel = canvas:Add("ixInventory")
			panel:SetPos(0, 0)
			panel:SetDraggable(false)
			panel:SetSizable(false)
			panel:SetTitle(nil)
			panel.bNoBackgroundBlur = true
			panel.childPanels = {}

			local inventory = LocalPlayer():GetCharacter():GetInventory()

			if (inventory) then
				panel:SetInventory(inventory)
			end

			ix.gui.inv1 = panel

			if (ix.option.Get("openBags", true)) then
				for _, v in pairs(inventory:GetItems()) do
					if (!v.isBag) then
						continue
					end

					v.functions.View.OnClick(v)
				end
			end

			canvas.PerformLayout = canvasLayout
			canvas:Layout()
		end,
		Sections = {
			medical = {
				Create = function(info, container)
					ix.gui.limbPanel = container:Add("ixLimbPanel")
				end,
			}
		}
	}	
end)