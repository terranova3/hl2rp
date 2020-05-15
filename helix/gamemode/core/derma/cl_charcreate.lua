local PANEL = {}

function PANEL:Init()
	self:Center();
	self:SetText("")
	self.faction = "citizen";
end

function PANEL:SetupPosition(pos)
	if(pos < 1 or pos > 3) then return false end;

	self:SetSize(self:GetParent():GetWide() / 4.5, self:GetParent():GetTall())
	self:Center();

	panelPositioning = {
		self:GetPos() - (self:GetWide() - 45),
		0,
		self:GetPos() + (self:GetWide() + 20);
	}

	if(pos == 1 or pos == 3) then
		self:SetSize((self:GetParent():GetWide() / 4.5) * 0.8, self:GetParent():GetTall() * 0.8)
		self:SetPos(panelPositioning[pos], self:GetTall() * 0.1);
	end;
end;

function PANEL:Populate(name)
	self.faction = ix.faction.teams[name];
	self.depressed = true;

	local factionLabel = self:Add("DLabel")
	self.factionMaterials = {
		["Citizen"] = {
			normal = "materials/terranova/ui/charcreate/citizen_normal.png",
			depressed = "materials/terranova/ui/charcreate/citizen_normal.png"
		},
		["Metropolice Force"] = {
			normal = "materials/terranova/ui/charcreate/mpf_normal.png",
			depressed = "materials/terranova/ui/charcreate/mpf_normal.png"
		},
		["Overwatch Transhuman Arm"] = {
			normal = "materials/terranova/ui/charcreate/overwatch_normal.png",
			depressed = "materials/terranova/ui/charcreate/overwatch_normal.png"
		},
		["Administrator"] = {
			normal = "materials/terranova/ui/charcreate/administrator_normal.png",
			depressed = "materials/terranova/ui/charcreate/administrator_normal.png"
		},
		["Scanner"] = {
			normal = "materials/terranova/ui/charcreate/scanner_normal.png",
			depressed = "materials/terranova/ui/charcreate/scanner_normal.png"
		},
	}

	factionLabel:Dock(BOTTOM);
	factionLabel:SetSize(self:GetWide(), 100)
    factionLabel:SetContentAlignment(5)
    factionLabel:SetExpensiveShadow(2)
    factionLabel:SetFont("ixFactionFont")
	factionLabel:SetTextColor(color_white)
	factionLabel:SetText(self.faction.name)
	factionLabel.PaintOver = function()
		local gradient = surface.GetTextureID("vgui/gradient-d")
  	 	surface.SetDrawColor(80, 80, 80, 50);	
		surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
		surface.SetDrawColor(0, 0, 0, 50);	
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())

		surface.SetDrawColor(self.faction.color)
		surface.SetTexture(gradient)
		surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())
	end;

	self.mat = vgui.Create("Material", self)
	self:Depress(true);
	self.mat.AutoSize = false
	self.mat:Dock(FILL);
	self.mat:DockMargin(2, 0, 2, 0)

    self.alpha = 0
    self:SetAlpha(0)

    self:CreateAnimation(0.75, {
		indx = 1,
        target = {alpha = 255},
        easing = "outQuint",

        Think = function(animation, panel)
            panel:SetAlpha(panel.alpha)
            panel.mat:SetAlpha(panel.alpha);
        end
    })
end;

function PANEL:Depress(depress)
	self.depressed = depress;

	if(self.depressed) then 
		self.mat:SetMaterial(self.factionMaterials[self.faction.name].depressed or "materials/invalid.png")
	else
		self.mat:SetMaterial(self.factionMaterials[self.faction.name].normal or "materials/invalid.png")
	end;
end;

function PANEL:Exit(direction)
	local parent = ix.gui.factionList;

	if(direction == "right" or direction == "left") then
		local x, y = self:GetPos()
		local targetX = x;
		local finishedFade = false;

		if(direction == "right") then
			targetX = targetX + 200;
		else
			targetX = targetX - 200;
		end;

		self:CreateAnimation(0.5, {
			index = 2,
			target = {x = targetX, alpha = 0},
			easing = "outElastic",

			Think = function(animation, panel)			
				if(direction == "right") then
					x=x+2; 
					if(x > targetX) then x = targetX; end;
				else
					x=x-2;
					if(x < targetX) then x = targetX; end;
				end;

				if(panel.alpha < 0) then finishedFade = true; end;
				if(finishedFade) then panel.alpha = 0; end;

				panel:SetAlpha(panel.alpha)
				panel.mat:SetAlpha(panel.alpha);
				panel:SetPos(x, y)
			end,
			OnComplete = function(animation, panel)
				self:Repopulate(direction, parent, panel);
			end;
		})
	end;
end;

function PANEL:Repopulate(direction, parent, panel)
	panel:SetAlpha(0)
	panel.mat:SetAlpha(0);
	panel:Clear();

	local nextFactionRight = parent.currentFaction+2;
	local nextFactionLeft = parent.currentFaction-2;

	if(direction == "left") then
		if(parent.factionArray[nextFactionRight]) then
			panel:Populate(parent.factionArray[nextFactionRight].name)
			parent.currentFaction = parent.currentFaction + 1;
			panel:SetupPosition(3);
			parent:ReorganiseArray(direction);
		end;
	elseif(direction == "right") then
		if(parent.factionArray[nextFactionLeft]) then 
			panel:Populate(parent.factionArray[nextFactionLeft].name)
			parent.currentFaction = parent.currentFaction - 1;
			panel:SetupPosition(1);
			parent:ReorganiseArray(direction);
		end;
	end;
end;

function PANEL:Paint()
	local drawColor = Color(80,80,80,50);

	if(faction) then 
		local drawColor = faction.color;
	end;

	surface.SetDrawColor(drawColor);	
	surface.DrawOutlinedRect(0, 0, self:GetWide(), self:GetTall())
	surface.SetDrawColor(0, 0, 0, 50);	
	surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
end

vgui.Register("ixFactionButton", PANEL, "DButton")

local PANEL = {}

function PANEL:Init()
	ix.gui.factionList = self;

	self.main = self:GetParent();
	self.factionArray = {}
	self.factionButtons = {}
	self.currentFaction = 2;

	self.Paint = function() end;

	for k, v in pairs(ix.faction.teams) do
		data = { name = k }
		table.insert(self.factionArray, data);
	end;

	self:SetSize(ScrW() * 0.8, ScrH() * 0.90)
	self:Center();

	self:Populate();
end

function PANEL:Populate()
	self.moveLeft = self:Add("DButton")
	self.moveLeft:SetText("<")
	self.moveLeft:SetExpensiveShadow(2)
	self.moveLeft:SetPos(20, self:GetTall() / 2)
	self.moveLeft:SetSize(64,64)
	self.moveLeft:SetFont("ixFactionFont")

	self.moveRight = self:Add("DButton")
	self.moveRight:SetText(">")
	self.moveRight:SetExpensiveShadow(2)
	self.moveRight:SetPos(self:GetWide() - 80, self:GetTall() / 2)
	self.moveRight:SetSize(64,64)
	self.moveRight:SetFont("ixFactionFont")

	for i = 1, 3 do
		self.factionButtons[i] = self:Add("ixFactionButton");
		self.factionButtons[i]:Populate(self.factionArray[i].name)
		self.factionButtons[i]:SetupPosition(i);
	end;

	function self.moveRight:DoClick()
		local parent = ix.gui.factionList

		if(!parent.factionButtons[3]:IsVisible()) then
			parent.factionButtons[3]:SetVisible(true)
			parent.moveLeft:SetVisible(true)

			parent.factionButtons[1]:SetupPosition(1);
			parent.factionButtons[2]:SetupPosition(2);
			parent.currentFaction = parent.currentFaction + 1;

			return;
		elseif(!parent.factionArray[parent.currentFaction+2]) then
			parent.currentFaction = parent.currentFaction + 1;
			parent.factionButtons[1]:SetVisible(false);
			self:SetVisible(false);
		else
			parent.factionButtons[1]:Exit("left");
		end;

		timer.Simple(0.25, function() 
			parent.factionButtons[2]:SetupPosition(1);
			parent.factionButtons[3]:SetupPosition(2);
		end)
	end

	function self.moveLeft:DoClick()
		local parent = ix.gui.factionList

		if(!parent.factionButtons[1]:IsVisible()) then
			parent.factionButtons[1]:SetVisible(true)
			parent.moveRight:SetVisible(true)

			parent.factionButtons[3]:SetupPosition(3);
			parent.factionButtons[2]:SetupPosition(2);
			parent.currentFaction = parent.currentFaction - 1;
			return;
		elseif(!parent.factionArray[parent.currentFaction-2]) then
			parent.currentFaction = parent.currentFaction - 1;
			parent.factionButtons[3]:SetVisible(false);
			self:SetVisible(false);
		else
			parent.factionButtons[3]:Exit("right");
		end;

		timer.Simple(0.25, function() 
			parent.factionButtons[2]:SetupPosition(3);
			parent.factionButtons[1]:SetupPosition(2);
		end)
	end;
end;

function PANEL:ReorganiseArray(direction)
	if(direction == "right" or direction == "left") then
		local newArray = {}
		
		if(direction == "left") then
			newArray[1] = self.factionButtons[2];
			newArray[2] = self.factionButtons[3];
			newArray[3] = self.factionButtons[1];
		else
			newArray[1] = self.factionButtons[3];
			newArray[2] = self.factionButtons[1];
			newArray[3] = self.factionButtons[2];
		end;

		self.factionButtons = newArray;
	end;
end;

function PANEL:GetCurrentFaction(index)
	local parent = ix.gui.factionList;

	if(index) then
		return parent.currentFaction;
	end;
	
	return ix.faction.teams[parent.factionArray[parent.currentFaction].name];
end;

vgui.Register("ixFactionPanel", PANEL, "DPanel")

local padding = ScreenScale(32)

-- create character panel
DEFINE_BASECLASS("ixCharMenuPanel")
local PANEL = {}

function PANEL:Init()
	local parent = self:GetParent()
	local halfWidth = parent:GetWide() * 0.5 - (padding * 2)
	local halfHeight = parent:GetTall() * 0.5 - (padding * 2)
	local modelFOV = (ScrW() > ScrH() * 1.8) and 100 or 78

	self:ResetPayload(true)

	self.factionButtons = {}
	self.repopulatePanels = {}

	-- faction selection subpanel
	self.factionPanel = self:AddSubpanel("faction", true)
	self.factionPanel.Paint = function(w, h)
		surface.SetDrawColor(80, 80, 80, 50);	
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	end;
	self.factionPanel:SetTitle("")
	self.factionPanel.OnSetActive = function()
		-- if we only have one faction, we are always selecting that one so we can skip to the description section
		if (#self.factionButtons == 1) then
			self:SetActiveSubpanel("description", 0)
		end
	end
	self.factionPanel:SetVisible(false);

	local modelList = self.factionPanel:Add("Panel")
	modelList.Paint = function(w, h)
		surface.SetDrawColor(80, 80, 80, 50);	
		surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
	end;
	modelList:Dock(RIGHT)
	modelList:SetSize(halfWidth + padding * 2, halfHeight)
	modelList:SetVisible(false);

	self.facList = self:Add("ixFactionPanel")
	
	self.facList.backButton = self.facList:Add("DButton")
	self.facList.backButton:SetText("Back")
	self.facList.backButton:SetExpensiveShadow(2)
	self.facList.backButton:SetPos(40, self.facList:GetTall() - 80)
	self.facList.backButton:SetSize(198,64)
	self.facList.backButton:SetFont("ixFactionFont")
	self.facList.backButton.DoClick = function()
		self.progress:DecrementProgress()

		self:SetActiveSubpanel("faction", 0)
		self:SlideDown()

		parent.mainPanel:Undim()
	end

	self.facList.finishButton = self.facList:Add("DButton")
	self.facList.finishButton:SetText("Next")
	self.facList.finishButton:SetExpensiveShadow(2)
	self.facList.finishButton:SetPos(self.facList:GetWide() / 1.18, self.facList:GetTall() - 80)
	self.facList.finishButton:SetSize(198,64)
	self.facList.finishButton:SetFont("ixFactionFont")
	self.facList.finishButton.DoClick = function()
		local faction = ix.faction.indices[self.facList:GetCurrentFaction(true)]
		local models = faction:GetModels(LocalPlayer())

		self.payload:Set("faction", self.facList:GetCurrentFaction(true))
		self.payload:Set("model", math.random(1, #models))

		self.progress:IncrementProgress()
		self.facList:SetVisible(false)
		self:Populate()
		self:SetActiveSubpanel("description")
	end;

	self.facList.finishButton.PaintOver = function()
		local drawColor = self.facList:GetCurrentFaction().color or Color(80,80,80,50);
		local gradient = surface.GetTextureID("vgui/gradient-d")

		surface.SetDrawColor(drawColor)
		surface.SetTexture(gradient)
		surface.DrawTexturedRect(0, 0, self:GetWide(), self:GetTall())
	end;

	local proceed = modelList:Add("ixMenuButton")
	proceed:SetText("proceed")
	proceed:SetContentAlignment(6)
	proceed:Dock(BOTTOM)
	proceed:SizeToContents()
	proceed.DoClick = function()
		self.progress:IncrementProgress()

		self:Populate()
		self:SetActiveSubpanel("description")
	end

	self.factionModel = modelList:Add("ixModelPanel")
	self.factionModel:Dock(FILL)
	self.factionModel:SetModel("models/error.mdl")
	self.factionModel:SetFOV(modelFOV)
	self.factionModel.PaintModel = self.factionModel.Paint
	self.factionModel:SetVisible(false);

	self.factionButtonsPanel = self.factionPanel:Add("ixCharMenuButtonList")
	self.factionButtonsPanel:SetWide(halfWidth)
	self.factionButtonsPanel:Dock(FILL)
	self.factionButtonsPanel:SetVisible(false);

	local factionBack = self.factionPanel:Add("ixMenuButton")
	factionBack:SetText("return")
	factionBack:SetVisible(false);
	factionBack:SizeToContents()
	factionBack:Dock(BOTTOM)
	factionBack.DoClick = function()
		self.progress:DecrementProgress()

		self:SetActiveSubpanel("faction", 0)
		self:SlideDown()

		parent.mainPanel:Undim()
	end

	-- character customization subpanel
	self.description = self:AddSubpanel("description")
	self.description:SetTitle("chooseDescription")

	local descriptionModelList = self.description:Add("Panel")
	descriptionModelList:Dock(LEFT)
	descriptionModelList:SetSize(halfWidth, halfHeight)

	local descriptionBack = descriptionModelList:Add("ixMenuButton")
	descriptionBack:SetText("return")
	descriptionBack:SetContentAlignment(4)
	descriptionBack:SizeToContents()
	descriptionBack:Dock(BOTTOM)
	descriptionBack.DoClick = function()
		self.progress:DecrementProgress()

		if (#self.factionButtons == 1) then
			factionBack:DoClick()
		else
			self:SetActiveSubpanel("faction")
			self.facList:SetVisible(true);
		end
	end

	self.descriptionModel = descriptionModelList:Add("ixModelPanel")
	self.descriptionModel:Dock(FILL)
	self.descriptionModel:SetModel(self.factionModel:GetModel())
	self.descriptionModel:SetFOV(modelFOV - 13)
	self.descriptionModel.PaintModel = self.descriptionModel.Paint

	self.descriptionPanel = self.description:Add("Panel")
	self.descriptionPanel:SetWide(halfWidth + padding * 2)
	self.descriptionPanel:Dock(RIGHT)

	local descriptionProceed = self.descriptionPanel:Add("ixMenuButton")
	descriptionProceed:SetText("proceed")
	descriptionProceed:SetContentAlignment(6)
	descriptionProceed:SizeToContents()
	descriptionProceed:Dock(BOTTOM)
	descriptionProceed.DoClick = function()
		if (self:VerifyProgression("description")) then
			-- there are no panels on the attributes section other than the create button, so we can just create the character
			if (#self.attributesPanel:GetChildren() < 2) then
				self:SendPayload()
				return
			end

			self.progress:IncrementProgress()
			local faction = ix.faction.indices[self.payload.faction].name

			if(faction == "Scanner") then
				self:SetActiveSubpanel("attributes")
			else		
				self:SetActiveSubpanel("customization")
			end;
		end
	end

	-- customization subpanel
	self.customization = self:AddSubpanel("customization")
	self.customization:SetTitle("Character customization")

	local customizationList = self.customization:Add("Panel")
	customizationList:Dock(LEFT)
	customizationList:SetSize(halfWidth, halfHeight)

	local customizationBack = customizationList:Add("ixMenuButton")
	customizationBack:SetText("return")
	customizationBack:SetContentAlignment(4)
	customizationBack:SizeToContents()
	customizationBack:Dock(BOTTOM)
	customizationBack.DoClick = function()
		self.progress:DecrementProgress()
		self:SetActiveSubpanel("description")
	end

	self.customizationModel = customizationList:Add("ixModelPanel")
	self.customizationModel:Dock(FILL)
	self.customizationModel:SetModel(self.factionModel:GetModel())
	self.customizationModel:SetFOV(modelFOV - 13)
	self.customizationModel.follow = false;
	self.customizationModel.PaintModel = self.customizationModel.Paint

	self.customPanel = self.customization:Add("Panel")
	self.customPanel:SetWide(halfWidth + padding * 2)
	self.customPanel:Dock(RIGHT)

	local customProceed = self.customPanel:Add("ixMenuButton")
	customProceed:SetText("proceed")
	customProceed:SetContentAlignment(6)
	customProceed:SizeToContents()
	customProceed:Dock(BOTTOM)
	customProceed.DoClick = function()
		if (self:VerifyProgression("customization")) then
			if (#self.attributesPanel:GetChildren() < 2) then
				self:SendPayload()
				return
			end

			self.progress:IncrementProgress()
			self:SetActiveSubpanel("attributes")
		end
	end

	-- attributes subpanel
	self.attributes = self:AddSubpanel("attributes")
	self.attributes:SetTitle("chooseSkills")

	local attributesModelList = self.attributes:Add("Panel")
	attributesModelList:Dock(LEFT)
	attributesModelList:SetSize(halfWidth, halfHeight)

	local attributesBack = attributesModelList:Add("ixMenuButton")
	attributesBack:SetText("return")
	attributesBack:SetContentAlignment(4)
	attributesBack:SizeToContents()
	attributesBack:Dock(BOTTOM)
	attributesBack.DoClick = function()
		self.progress:DecrementProgress()

		local faction = ix.faction.indices[self.payload.faction].name

		if(faction == "Scanner") then
			self:SetActiveSubpanel("description")
		else		
			self:SetActiveSubpanel("customization")
		end;
	end

	self.attributesModel = attributesModelList:Add("ixModelPanel")
	self.attributesModel:Dock(FILL)
	self.attributesModel:SetModel(self.factionModel:GetModel())
	self.attributesModel:SetFOV(modelFOV - 13)
	self.attributesModel.PaintModel = self.attributesModel.Paint

	self.attributesPanel = self.attributes:Add("Panel")
	self.attributesPanel:SetWide(halfWidth + padding * 2)
	self.attributesPanel:Dock(RIGHT)

	local create = self.attributesPanel:Add("ixMenuButton")
	create:SetText("finish")
	create:SetContentAlignment(6)
	create:SizeToContents()
	create:Dock(BOTTOM)
	create.DoClick = function()
		self:SendPayload()
	end

	-- creation progress panel
	self.progress = self:Add("ixSegmentedProgress")
	self.progress:SetBarColor(ix.config.Get("color"))
	self.progress:SetSize(parent:GetWide(), 0)
	self.progress:SizeToContents()
	self.progress:SetPos(0, parent:GetTall() - self.progress:GetTall())
	self.progress:SetVisible(false);

	local curSkinValue = 1;
	
	-- setup payload hooks
	self:AddPayloadHook("model", function(value)
		local faction = ix.faction.indices[self.payload.faction]

		if (faction) then
			local model = faction:GetModels(LocalPlayer())[value]

			local smallModel;
			
			if(faction.name == "Scanner") then
				smallModel = true;
			else
				smallModel = false;
			end;

			self.factionModel.smallModel = smallModel;
			self.descriptionModel.smallModel = smallModel;
			self.customizationModel.smallModel = smallModel;
			self.attributesModel.smallModel = smallModel;
			
			-- assuming bodygroups
			if (istable(model)) then
				self.factionModel:SetModel(model[1], model[2] or 0, model[3])
				self.descriptionModel:SetModel(model[1], model[2] or 0, model[3])
				self.customizationModel:SetModel(model[1], model[2] or 0, model[3])
				self.attributesModel:SetModel(model[1], model[2] or 0, model[3])
			else
				self.factionModel:SetModel(model)
				self.descriptionModel:SetModel(model)
				self.customizationModel:SetModel(model)
				self.attributesModel:SetModel(model)
			end

			self.descriptionModel.Entity:SetSkin(curSkinValue);	
			self.customizationModel.Entity:SetSkin(curSkinValue);	
			self.attributesModel.Entity:SetSkin(curSkinValue);	
		end
	end)

	self:AddPayloadHook("skin", function(value)
		curSkinValue = value;
		local faction = ix.faction.indices[self.payload.faction];

		if (faction) then
			self.descriptionModel.Entity:SetSkin(value);	
			self.customizationModel.Entity:SetSkin(value);	
			self.attributesModel.Entity:SetSkin(value);	
		end
	end)

	-- setup character creation hooks
	net.Receive("ixCharacterAuthed", function()
		timer.Remove("ixCharacterCreateTimeout")
		self.awaitingResponse = false

		local id = net.ReadUInt(32)
		local indices = net.ReadUInt(6)
		local charList = {}

		for _ = 1, indices do
			charList[#charList + 1] = net.ReadUInt(32)
		end

		ix.characters = charList

		self:SlideDown()

		if (!IsValid(self) or !IsValid(parent)) then
			return
		end

		if (LocalPlayer():GetCharacter()) then
			parent.mainPanel:Undim()
			parent:ShowNotice(2, L("charCreated"))
		elseif (id) then
			self.bMenuShouldClose = true

			net.Start("ixCharacterChoose")
				net.WriteUInt(id, 32)
			net.SendToServer()
		else
			self:SlideDown()
		end
	end)

	net.Receive("ixCharacterAuthFailed", function()
		timer.Remove("ixCharacterCreateTimeout")
		self.awaitingResponse = false

		local fault = net.ReadString()
		local args = net.ReadTable()

		self:SlideDown()

		parent.mainPanel:Undim()
		parent:ShowNotice(3, L(fault, unpack(args)))
	end)
end

function PANEL:SendPayload()
	if (self.awaitingResponse or !self:VerifyProgression()) then
		return
	end

	self.awaitingResponse = true

	timer.Create("ixCharacterCreateTimeout", 10, 1, function()
		if (IsValid(self) and self.awaitingResponse) then
			local parent = self:GetParent()

			self.awaitingResponse = false
			self:SlideDown()

			parent.mainPanel:Undim()
			parent:ShowNotice(3, L("unknownError"))
		end
	end)

	self.payload:Prepare()

	net.Start("ixCharacterCreate")
		net.WriteTable(self.payload)
	net.SendToServer()
end

function PANEL:OnSlideUp()
	self:ResetPayload()
	self:Populate()
	self.progress:SetProgress(1)

	-- the faction subpanel will skip to next subpanel if there is only one faction to choose from,
	-- so we don't have to worry about it here
	self:SetActiveSubpanel("faction", 0)
end

function PANEL:OnSlideDown()
end

function PANEL:ResetPayload(bWithHooks)
	if (bWithHooks) then
		self.hooks = {}
	end

	self.payload = {}

	-- TODO: eh..
	function self.payload.Set(payload, key, value)
		self:SetPayload(key, value)
	end

	function self.payload.AddHook(payload, key, callback)
		self:AddPayloadHook(key, callback)
	end

	function self.payload.Prepare(payload)
		self.payload.Set = nil
		self.payload.AddHook = nil
		self.payload.Prepare = nil
	end
end

function PANEL:SetPayload(key, value)
	self.payload[key] = value
	self:RunPayloadHook(key, value)
end

function PANEL:AddPayloadHook(key, callback)
	if (!self.hooks[key]) then
		self.hooks[key] = {}
	end

	self.hooks[key][#self.hooks[key] + 1] = callback
end

function PANEL:RunPayloadHook(key, value)
	local hooks = self.hooks[key] or {}

	for _, v in ipairs(hooks) do
		v(value)
	end
end

function PANEL:GetContainerPanel(name)
	-- TODO: yuck
	if (name == "description") then
		return self.descriptionPanel
	elseif (name == "attributes") then
		return self.attributesPanel
	elseif(name == "customization") then
		return self.customPanel
	end

	return self.descriptionPanel
end

function PANEL:AttachCleanup(panel)
	self.repopulatePanels[#self.repopulatePanels + 1] = panel
end

function PANEL:Populate()
	if (!self.bInitialPopulate) then
		-- setup buttons for the faction panel
		-- TODO: make this a bit less janky
		local lastSelected

		for _, v in pairs(self.factionButtons) do
			if (v:GetSelected()) then
				lastSelected = v.faction
			end

			if (IsValid(v)) then
				v:Remove()
			end
		end

		self.factionButtons = {}

		for _, v in SortedPairs(ix.faction.teams) do
			--if (ix.faction.HasWhitelist(v.index)) then
				local button = self.factionButtonsPanel:Add("ixMenuSelectionButton")
				button:SetBackgroundColor(v.color or color_white)
				button:SetText(L(v.name):upper())
				button:SizeToContents()
				button:SetButtonList(self.factionButtons)
				button.faction = v.index
				button.OnSelected = function(panel)
					local faction = ix.faction.indices[panel.faction]
					local models = faction:GetModels(LocalPlayer())

					self.payload:Set("faction", panel.faction)
					self.payload:Set("model", math.random(1, #models))
				end

				if ((lastSelected and lastSelected == v.index) or (!lastSelected and v.isDefault)) then
					button:SetSelected(true)
				end
			--end
		end
	end

	-- remove panels created for character vars
	for i = 1, #self.repopulatePanels do
		self.repopulatePanels[i]:Remove()
	end

	self.repopulatePanels = {}

	-- payload is empty because we attempted to send it - for whatever reason we're back here again so we need to repopulate
	if (!self.payload.faction) then
		for _, v in pairs(self.factionButtons) do
			if (v:GetSelected()) then
				v:SetSelected(true)
				break
			end
		end
	end

	self.factionButtonsPanel:SizeToContents()

	local zPos = 1

	-- set up character vars
	for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
		if (!v.bNoDisplay and k != "__SortedIndex") then
			local container = self:GetContainerPanel(v.category or "description")

			if (v.ShouldDisplay and v:ShouldDisplay(container, self.payload) == false) then
				continue
			end

			local panel

			-- if the var has a custom way of displaying, we'll use that instead
			if (v.OnDisplay) then
				panel = v:OnDisplay(container, self.payload)
			elseif (isstring(v.default)) then
				panel = container:Add("ixTextEntry")
				panel:Dock(TOP)
				panel:SetFont("ixMenuButtonHugeFont")
				panel:SetUpdateOnType(true)
				panel.OnValueChange = function(this, text)
					self.payload:Set(k, text)
				end
			end

			if (IsValid(panel)) then
				-- add label for entry
				local label = container:Add("DLabel")

				label:SetFont("ixMenuButtonLabelFont")
				label:SetText(L(k):upper())
				label:SizeToContents()
				label:DockMargin(0, 16, 0, 2)
				label:Dock(TOP)

				-- we need to set the docking order so the label is above the panel
				label:SetZPos(zPos - 1)
				panel:SetZPos(zPos)

				self:AttachCleanup(label)
				self:AttachCleanup(panel)

				if (v.OnPostSetup) then
					v:OnPostSetup(panel, self.payload)
				end

				zPos = zPos + 2
			end
		end
	end

	if (!self.bInitialPopulate) then
		-- setup progress bar segments
		if (#self.factionButtons > 1) then
			self.progress:AddSegment("@faction")
		end

		self.progress:AddSegment("@description")
		self.progress:AddSegment("@Customization")

		if (#self.attributesPanel:GetChildren() > 1) then
			self.progress:AddSegment("@skills")
		end

		-- we don't need to show the progress bar if there's only one segment
		if (#self.progress:GetSegments() == 1) then
			self.progress:SetVisible(false)
		end
	end

	self.bInitialPopulate = true
end

function PANEL:VerifyProgression(name)
	for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
		if (name ~= nil and (v.category or "description") != name) then
			continue
		end

		local value = self.payload[k]

		if (!v.bNoDisplay or v.OnValidate) then
			if (v.OnValidate) then
				local result = {v:OnValidate(value, self.payload, LocalPlayer())}

				if (result[1] == false) then
					self:GetParent():ShowNotice(3, L(unpack(result, 2)))
					return false
				end
			end

			self.payload[k] = value
		end
	end

	return true
end

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintCharacterCreateBackground", self, width, height)
	BaseClass.Paint(self, width, height)
end

vgui.Register("ixCharMenuNew", PANEL, "ixCharMenuPanel")
