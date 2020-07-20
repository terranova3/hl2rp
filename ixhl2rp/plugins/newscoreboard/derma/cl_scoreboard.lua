local PANEL = {};

-- Called when the panel is initialized.
function PANEL:Init()
	if (IsValid(ix.gui.scoreboard)) then
		ix.gui.scoreboard:Remove()
	end

	self:SetWide(800);
	self:SetTall(400);
	self:Dock(LEFT);
	self.nextThink = 0
	self.maxWidth = ScrW() * 0.2
	
	self.panelList = self:Add("DPanelList")
	self.panelList:Dock(FILL)
	self.panelList:EnableVerticalScrollbar();
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(2);
 	self.panelList:SizeToContents();
	

	function self.panelList:Paint()
	end;

	ix.gui.scoreboard = self;
	ix.gui.scoreboard:Rebuild();
end;

-- A function to rebuild the panel.
function PANEL:Rebuild()
	self.panelList:Clear();

	local availableClasses = {};
	local classes = {};

	for k, v in pairs(player.GetAll()) do
		local character = v:GetCharacter()

		if(character) then
			local class = character:GetCustomClass() or character:GetClassName() or "ERROR"
			local priority = character:GetClassScoreboardPriority()

			if (!availableClasses[class]) then
				availableClasses[class] = {
					players = {},
					priority = priority
				};
			end;
				
			table.insert(availableClasses[class].players, v)
		end;
	end;

	for k, v in pairs(availableClasses) do
		if (#v.players > 0) then
			classes[#classes + 1] = {name = k, priority = v.priority, players = v.players};
		end;
	end;
	
	table.sort(classes, function(a, b)
		return a.priority < b.priority;
	end);

	if (table.Count(classes) > 0) then
		for k, v in pairs(classes) do
			local characterForm = vgui.Create("DForm", self);
			local panelList = vgui.Create("DPanelList", self);
			
			for k2, v2 in pairs(v.players) do
				self.playerData = {
					avatarImage = true,
					steamName = v2:SteamName(),
					faction = v2:GetCharacter():GetFaction(),
					player = v2,
					model = v2:GetModel(),
					skin = v2:GetSkin(),
					name = v2:Name()
				};
				
				panelList:AddItem(vgui.Create("ixScoreboardItem", self)) ;
			end;
			
			self.panelList:AddItem(characterForm);
			--self.panelList:SetPos(0, -10)
			
			panelList:SetAutoSize(true);
			panelList:SetSpacing(2);
			
			characterForm:SetName("");
			characterForm:AddItem(panelList)
			characterForm:SetPadding(4);
			characterForm.Think = function()
				if(!characterForm:GetExpanded()) then
					characterForm.Header:SetSize(30, 30)
				else
					characterForm.Header:SetSize(20, 20)
				end
			end

			--characterForm.Header:SetSize( 30, 30 )

			function characterForm:Paint(w, h)
				derma.SkinFunc("PaintCategoryPanel", self, "", v.players[1]:GetCharacter():GetClassColor())
				surface.SetDrawColor(0, 0, 0, 50);	
				surface.DrawRect(0, 0, w, h)

				surface.SetTextColor(Color(255,255,255,255))
				surface.SetTextPos(4, 4)
				surface.DrawText(v.name)
			end;
		end;
	end;
	
	self.panelList:InvalidateLayout(true);
	self:SizeToContents();
end;

-- Called when the panel is painted.
function PANEL:Paint(w, h)
    surface.SetDrawColor(80, 80, 80, 80);	
end;

function PANEL:Think()
	self:InvalidateLayout(true);
end

vgui.Register("ixScoreboard", PANEL, "EditablePanel")

PANEL = {}

-- Called when the panel is initialized.
function PANEL:Init()
	self:SetSize(self:GetParent():GetWide(), 48);

	local playerData = self:GetParent().playerData;

	local info = {
		avatarImage = playerData.avatarImage,
		steamName = playerData.steamName,
		faction = playerData.faction,
		player = playerData.player,
		doesRecognise = true,
		model = playerData.model,
		skin = playerData.skin,
		name = playerData.name
	};

	self.toolTip = info.toolTip;
	self.player = info.player;

	local localCharacter = LocalPlayer():GetCharacter();
	local character = playerData.player:GetCharacter();

	info.doesRecognize = hook.Run("IsCharacterRecognized", localCharacter, character:GetID()) or hook.Run("IsPlayerRecognized", self.player)
	info.text = playerData.player:GetCharacter():GetDescription(); 
	
	self.nameLabel = vgui.Create("DLabel", self);
	self.nameLabel:SetFont("ixGenericFont")
	self.nameLabel:SetText(info.name);
	self.nameLabel:SetDark(true);
	self.nameLabel:SizeToContents();
	self.nameLabel:SetTextColor(Color(255,255,255,180))

	self.factionLabel = vgui.Create("DLabel", self); 
	self.factionLabel:SetText(info.faction);
	self.factionLabel:SetFont("ixSmallFont")
	self.factionLabel:SizeToContents();
	self.factionLabel:SetDark(true);
	self.factionLabel:SetTextColor(Color(255,255,255,180))
	
	if (type(info.text) == "string") then
		self.factionLabel:SetText(info.text);
		self.factionLabel:SizeToContents();
	end;
	
	if (info.doesRecognise) then
		self.spawnIcon = vgui.Create("ixScoreboardIcon", self);
		self.spawnIcon:SetModel(info.model, info.skin);
		self.spawnIcon:SetPos(1, 1);
		self.spawnIcon:SetSize(30, 30);

		for _, v in pairs(info.player:GetBodyGroups()) do
			self.spawnIcon:SetBodygroup(v.id, info.player:GetBodygroup(v.id))
		end
	else
		self.spawnIcon = vgui.Create("DImageButton", self);
		self.spawnIcon:SetImage("clockwork/unknown.png");
		self.spawnIcon:SetPos(1, 1);
		self.spawnIcon:SetSize(30, 30);
	end;
	
	self.spawnIcon:SetHelixTooltip(function(tooltip)
		local client = self.player

		if (IsValid(self) and IsValid(client)) then
			ix.hud.PopulatePlayerTooltip(tooltip, client)
		end
	end)

	-- Called when the spawn icon is clicked.
	function self.spawnIcon.DoClick(spawnIcon)	
		local client = self.player;
		local menu = DermaMenu();

		hook.Run("PopulateScoreboardPlayerMenu", client, menu);
		menu:Open();
	end;
end;

-- Called when the layout should be performed.
function PANEL:PerformLayout(w, h)
	self.factionLabel:SizeToContents();
	
	self.spawnIcon:SetPos(4, 4);
	self.spawnIcon:SetSize(40, 40);
	self.nameLabel:SetPos(50, 8);
	self.factionLabel:SetPos(50, 24); 
end;

vgui.Register("ixScoreboardItem", PANEL, "Panel");

hook.Add("CreateMenuButtons", "ixScoreboard", function(tabs)
	tabs["scoreboard"] = {
		Create = function(info, container)
			local panel = container:Add("ixScoreboard")	
		end,
		OnSelected = function(info, container)
			if(ix.gui.scoreboard) then
				ix.gui.scoreboard:Rebuild()
			end
		end
	}
end)