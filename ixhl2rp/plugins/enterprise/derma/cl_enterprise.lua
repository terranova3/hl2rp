--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	if (IsValid(ix.gui.enterprise)) then
		ix.gui.enterprise:Remove()
	end

	self:SetWide(800);
	self:SetTall(400);
	self:Dock(LEFT);
    self.maxWidth = ScrW() * 0.2
	
	ix.gui.enterprise = self;
end;

function PANEL:RequestInformation()
	self.stagePanels = {}
	self:Clear()

	self:AddLoadingSymbol()

	net.Start("ixEnterpriseRequestInformation")
		net.WriteInt(LocalPlayer():GetCharacter():GetEnterprise(), 16)
	net.SendToServer()
end

net.Receive("ixEnterpriseReceiveInformation", function()
	local enterprise = net.ReadTable()

	print("Received")
	if(ix.gui.enterprise) then
		ix.gui.enterprise.enterprise = setmetatable(enterprise, ix.meta.enterprise)
		ix.gui.enterprise:Rebuild()
	end
end)

function PANEL:AddLoadingSymbol()

end

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self:AddLabel(self.enterprise:GetName() or "Error", true, true)
	self:AddLabel(self.enterprise:GetData("description") or "Error")

	self.topDock = self:Add("DPanel")
	self.topDock:Dock(TOP)
	self.topDock:DockMargin(4,4,4,4)
	self.topDock.Paint = function() end

	self:BuildMembers()
	self:BuildProperty()
	self:BuildManage()

	self:SetActivePanel("members")
end;

function PANEL:BuildMembers()
	self.members = self:AddStagePanel("members")
	self.membersButton = self.topDock:Add(self:AddStageButton("Members", "members"))

	self.membersScroll = self.members:Add("DScrollPanel")
	self.membersScroll:Dock(FILL)
end

function PANEL:BuildProperty()
	self.property = self:AddStagePanel("property")
	self.propertyButton = self.topDock:Add(self:AddStageButton("Property", "property"))

	self.propertyScroll = self.property:Add("DScrollPanel")
	self.propertyScroll:Dock(FILL)
end

function PANEL:BuildManage()
	self.manage = self:AddStagePanel("manage")
	self.manageButton = self.topDock:Add(self:AddStageButton("Manage", "manage"))

	self.manageScroll = self.manage:Add("DScrollPanel")
	self.manageScroll:Dock(FILL)
end

vgui.Register("ixEnterprise", PANEL, "ixStagePanel")

hook.Add("CreateMenuButtons", "ixEnterprise", function(tabs)
	if(LocalPlayer():GetCharacter():GetEnterprise()) then
		tabs["enterprise"] = {
			Create = function(info, container)
				local panel = container:Add("ixEnterprise")	
			end,
			OnSelected = function(info, container)
				if(ix.gui.enterprise) then
					ix.gui.enterprise:RequestInformation()
				end
			end
		}
	end
end)