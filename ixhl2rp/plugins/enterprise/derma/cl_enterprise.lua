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

	self.character = LocalPlayer():GetCharacter()

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

	self.members.OnSetActive = function() 
		self.membersScroll:Clear();

		for k, v in ipairs(self.enterprise.members) do
			local slot = self.membersScroll:Add("DPanel")
			slot:SetTall(72)
			slot:Dock(TOP)
			slot:DockMargin(5, 5, 5, 0)

			slot.icon = slot:Add("SpawnIcon")
			slot.icon:SetPos(2, 2)
			slot.icon:SetSize(64, 64)
			slot.icon:SetTooltip()
			slot.icon:SetModel(v.model);
			slot.icon:Dock(LEFT)

			slot.name = slot:Add("DLabel")
			slot.name:SetPos(64, 2)
			slot.name:SetFont("ixInfoPanelFont")
			slot.name:SetExpensiveShadow(1, Color(0, 0, 0, 200))
			slot.name:SetText(v.name)
			slot.name:SetTextColor(color_white)
			slot.name:SizeToContents()

			slot.rank = slot:Add("DLabel")
			slot.rank:SetPos(64, 32)
			slot.rank:SetFont("ixSmallFont")
			slot.rank:SetExpensiveShadow(1, Color(0, 0, 0, 200))
			slot.rank:SetText("Owner")
			slot.rank:SetTextColor(Color(225,225,225,255))
			slot.rank:SizeToContents()

			slot.kick = slot:Add("DButton")
			slot.kick:SetSize(64,64)
			slot.kick:SetFont("ixSmallFont")
			slot.kick:SetText("Kick")
			slot.kick:Dock(RIGHT)
			slot.kick:DockMargin(4,4,4,4)

			slot.manage = slot:Add("DButton")
			slot.manage:SetSize(64,64)
			slot.manage:Dock(RIGHT)
			slot.manage:SetFont("ixSmallFont")
			slot.manage:SetText("Manage")
			slot.manage:DockMargin(4,4,4,4)		
		end		
	end;

	self.leavePanel = self.members:Add("DPanel")
	self.leavePanel:Dock(BOTTOM)

	self.leaveButt = self.leavePanel:Add("DButton")
	self.leaveButt:SetText("Leave enterprise")
	self.leaveButt:Dock(FILL)
	self.leaveButt.DoClick = function()
		self.character:LeaveEnterprise()

		if(IsValid(ix.gui.menu)) then
			ix.gui.menu:Remove()
		end
	end

	PrintTable(self.enterprise)
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