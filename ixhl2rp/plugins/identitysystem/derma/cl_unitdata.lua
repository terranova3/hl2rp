local PANEL = {}
local gradient = surface.GetTextureID("vgui/gradient-d")

function PANEL:Build(target, cid, data, cpData)
    ix.gui.unitData = self

    self.target = target:GetCharacter()
    self.character = LocalPlayer():GetCharacter()

    self.commands = {}

    self.sidePanel = self:Add("DPanel")
    self.sidePanel:Dock(LEFT)
    self.sidePanel:SetSize(300, h)

	self.sidePanelTitleLabel = self.sidePanel:Add(self:AddLabel(true, "Unit Career File"))
	self.sidePanelLabel = self.sidePanel:Add(self:AddLabel(false, "Unit Rank: John Doe\nUnit Tagline: 11111\nSpecialization: N/A"))
    self.sidePanelLabel:DockMargin(0,0,0,8)
    
    self:RebuildSidePanel();

    self.infoLabel = self:Add("ixInfoText")
    self.infoLabel:SetText("This is the list of actions you can perform on this unit. Access is based on your rank.")
    self.infoLabel:Dock(TOP)
    self.infoLabel:DockMargin(4, 4, 4, 4)
    self.infoLabel:MakeBold()
    --self.infoLabel:SetInfoColor("blue")

    self.buttonLayout = self:Add("DIconLayout")
    self.buttonLayout:Dock(TOP)
    self.buttonLayout:DockMargin(4, 4, 4, 4)
    self.buttonLayout:SetSpaceX(4)
    self.buttonLayout:SetSpaceY(4)
    self.buttonLayout:SetStretchWidth(true)
    self.buttonLayout:SetStretchHeight(true)
    self.buttonLayout:InvalidateLayout(true)

    self:AddCommandButton("Promote", "Promote")
    self:AddCommandButton("Demote", "Demote")
    self:AddCommandButton("Add Certification", "Add cert", true)
    self:AddCommandButton("Set Specialization", "Set spec", true)
    self:AddCommandButton("Remove Specialization", "Remove spec")
    self:AddCommandButton("Remove Certification", "Remove cert", true)
    self:AddCommandButton("Change ID", "Set CP ID", true)
    self:AddCommandButton("Set Tagline", "Set CP Tagline", true)
    self:AddCommandButton("Change wage", "Change wage", true)
end

function PANEL:RebuildSidePanel()
    local sidePanelText = (
        "Unit Rank: " .. self.target:GetRank():GetDisplayName() ..
        "\nUnit Tagline: " .. self.target:GetCPTagline()
    )

    if(self.target:GetSpec() != nil) then
        sidePanelText = sidePanelText .. "\nSpecialization: " .. self.target:GetSpec():GetName()
    end

	self.sidePanelLabel:SetText(sidePanelText)
	self.sidePanelLabel:SizeToContents()
end;

function PANEL:AddCommandButton(text, perm, requiresData)
    local button = self.buttonLayout:Add("DButton")
    local hasPermission = self.character:HasOverride() or ix.ranks.HasPermission(self.character:GetData("rank"), perm)
    local parent = self

    if(requiresData) then
        table.insert(self.commands, perm)
    end

    button:SetText(text)
    button:SetSize(140, 140)
    button:SetFont("ixSmallFont")
    button:SetEnabled(hasPermission)
    button.PaintOver = function()
        surface.SetDrawColor(230, 230, 230, 16)
        surface.SetTexture(gradient)
        surface.DrawTexturedRect(0, 0, button:GetWide(), button:GetTall())
    end
    button.DoClick = function()
        parent:HandleCommandClick(perm)
    end
end

function PANEL:AddLabel(title, text)
    local label = self:Add("DLabel")
    local font = "ixSmallFont"

    if(title) then
        font = "ixBigFont"
    end

	label:SetContentAlignment(5)
	label:SetFont(font)
	label:SetText(text)
	label:Dock(TOP)
	label:SizeToContents()
    label:SetExpensiveShadow(3)

	return label
end

function PANEL:HandleCommandClick(action)
    local requiresData = false
    local character = self.target

    for k, v in pairs(self.commands) do
        if(action == v) then
            requiresData = true
            break
        end
    end

    if(requiresData) then
        self.popoutPanel = vgui.Create("ixPopoutPanel")
        self.popoutPanel:SetHeaderText(action)

        if(action == "Add cert") then
            self.popoutPanel:SetInfoText("This is the list of certifications avaliable")

            local certs = ix.util.NewInstance(ix.certs.stored[FACTION_MPF])
            local charCerts = character:GetData("certs", {})

            -- We want to exclude the specialization from being added as a certification.
            if(character:GetData("spec") != nil) then
                table.insert(charCerts, character:GetData("spec"))
            end

            for _, uniqueID in pairs(charCerts) do
                for key, cert in pairs(certs) do
                    if(uniqueID == cert.uniqueID) then
                        certs[key] = nil
                    end
                end
            end

            if(certs == {}) then
                self.popoutPanel:SetInfoText("There are no certifications avaliable.", "red")
            end

            for k, v in pairs(certs) do
                local button = self.popoutPanel:AddBigButton(v.name)
                button:DockMargin(0,0,0,2)
                button.DoClick = function()
                    ix.command.Send("CharAddCert", character:GetName(), v.uniqueID)
                    button:Remove()
                end
            end
        elseif(action == "Set spec") then
            self.popoutPanel:SetInfoText("This is the list of specializations avaliable")

            local certs = ix.certs.stored[FACTION_MPF]

            if(!certs[1]) then
                self.popoutPanel:SetInfoText("There are no specializations avaliable.", "red")
            end

            for k, v in pairs(certs) do
                local button = self.popoutPanel:AddBigButton(v.name)
                button:DockMargin(0,0,0,2)
                button.DoClick = function()
                    ix.command.Send("CharSetSpec", character:GetName(), v.uniqueID)
                    self.popoutPanel:Remove()
                end
            end
        elseif(action == "Remove cert") then
            self.popoutPanel:SetInfoText("This is the list of certifications you can remove")

            local certs = {}

            for _, uniqueID in pairs(character:GetData("certs", {})) do
                table.insert(certs, ix.certs.Get(uniqueID))
            end

            if(certs == {}) then
                self.popoutPanel:SetInfoText("There are no certifications to remove.", "red")
            end

            for k, v in pairs(certs) do
                local button = self.popoutPanel:AddBigButton(v.name)
                button:DockMargin(0,0,0,2)
                button.DoClick = function()
                    ix.command.Send("CharRemoveCert", character:GetName(), v.uniqueID)
                    button:Remove()
                end
            end
        elseif(action == "Set CP ID") then
            for i = 1, 9 do
                local button = self.popoutPanel:AddBigButton("Set ID to ".. i)
                button:DockMargin(0,0,0,2)
                button.DoClick = function()
                    ix.command.Send("CharSetCPID", character:GetName(), i)
                    self.popoutPanel:Remove()
                end
            end
        elseif(action == "Set CP Tagline") then
            for k, v in pairs(cpSystem.config.taglines) do
                local button = self.popoutPanel:AddBigButton(v)
                button:DockMargin(0,0,0,2)
                button.DoClick = function()
                    ix.command.Send("CharSetCPTagline", character:GetName(), v)
                    self.popoutPanel:Remove()
                end
            end
        elseif(action == "Change wage") then

        end
    else
        if(action == "Promote") then
            ix.command.Send("CharPromote", character:GetName())
        elseif(action == "Demote") then
            ix.command.Send("CharDemote", character:GetName())
        elseif(action == "Remove spec") then
            ix.command.Send("CharRemoveSpec", character:GetName())
        end
    end
end

vgui.Register("ixUnitData", PANEL, "DPanel")