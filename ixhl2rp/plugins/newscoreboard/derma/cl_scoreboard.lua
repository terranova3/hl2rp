local PANEL = {}
local BODYGROUPS_EMPTY = "000000000"

AccessorFunc(PANEL, "model", "Model", FORCE_STRING)
AccessorFunc(PANEL, "bHidden", "Hidden", FORCE_BOOL)

function PANEL:Init()
	self:SetSize(64, 64)
	self.bodygroups = BODYGROUPS_EMPTY
end

function PANEL:SetModel(model, skin, bodygroups)
	model = model:gsub("\\", "/")

	if (isstring(bodygroups)) then
		if (bodygroups:len() == 9) then
			for i = 1, bodygroups:len() do
				self:SetBodygroup(i, tonumber(bodygroups[i]) or 0)
			end
		else
			self.bodygroups = BODYGROUPS_EMPTY
		end
	end

	self.model = model
	self.skin = skin
	self.path = "materials/spawnicons/" ..
		model:sub(1, #model - 4) .. -- remove extension
		((isnumber(skin) and skin > 0) and ("_skin" .. tostring(skin)) or "") .. -- skin number
		(self.bodygroups != BODYGROUPS_EMPTY and ("_" .. self.bodygroups) or "") .. -- bodygroups
		".png"

	local material = Material(self.path, "smooth")

	-- we don't have a cached spawnicon texture, so we need to forcefully generate one
	if (material:IsError()) then
		self.id = "ixScoreboardIcon" .. self.path
		self.renderer = self:Add("ModelImage")
		self.renderer:SetVisible(false)
		self.renderer:SetModel(model, skin, self.bodygroups)
		self.renderer:RebuildSpawnIcon()

		-- this is the only way to get a callback for generated spawn icons, it's bad but it's only done once
		hook.Add("SpawniconGenerated", self.id, function(lastModel, filePath, modelsLeft)
			filePath = filePath:gsub("\\", "/"):lower()

			if (filePath == self.path) then
				hook.Remove("SpawniconGenerated", self.id)

				self.material = Material(filePath, "smooth")
				self.renderer:Remove()
			end
		end)
	else
		self.material = material
	end
end

function PANEL:SetBodygroup(k, v)
	self.bodygroups = self.bodygroups:SetChar(k + 1, v)
end

function PANEL:GetModel()
	return self.model or "models/error.mdl"
end

function PANEL:GetSkin()
	return self.skin or 1
end

function PANEL:DoClick()
end

function PANEL:DoRightClick()
end

function PANEL:OnMouseReleased(key)
	if (key == MOUSE_LEFT) then
		self:DoClick()
	elseif (key == MOUSE_RIGHT) then
		self:DoRightClick()
	end
end

function PANEL:Paint(width, height)
	if (!self.material) then
		return
	end

	surface.SetMaterial(self.material)
	surface.SetDrawColor(self.bHidden and color_black or color_white)
	surface.DrawTexturedRect(0, 0, width, height)
end

function PANEL:Remove()
	if (self.id) then
		hook.Remove("SpawniconGenerated", self.id)
	end
end

vgui.Register("ixScoreboardIcon", PANEL, "Panel")

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
			local priority = ix.class.list[character:GetClass()].order or 10

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
					class = ix.class.list[v2:GetCharacter():GetClass()].name,
					model = v2:GetModel(),
					skin = v2:GetSkin(),
					name = v2:Name()
				};
				
				panelList:AddItem(vgui.Create("ixScoreboardItem", self)) ;
			end;
			
			self.panelList:AddItem(characterForm);
			
			panelList:SetAutoSize(true);
			panelList:SetSpacing(2);
			
			characterForm:SetName("");
			characterForm:AddItem(panelList);
			characterForm:SetPadding(4); 
			characterForm.Header:SetSize( 30, 30 )

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
		class = playerData.class,
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