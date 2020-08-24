local PANEL = {}
local steps = {
	"ixCharacterFaction",
	"ixCharacterModel",
	"ixCharacterCustomisation",
	"ixCharacterBiography",
	"ixCharacterCPSetup",
	"ixCharacterTraits"
}

function PANEL:Init()
	local modelFOV = 50

	self:Dock(FILL)
	self:InvalidateParent(true);

	local canCreate, reason = self:CanCreateCharacter()

	if (not canCreate) then
		self.back = self:Add("DButton")
		self.back:SetFont("ixPluginCharButtonFont")
		self.back:SetTextColor(ix.gui.characterMenu.WHITE)
		self.back:Center()
		self.back:SetSize(700, 64)
		self.back:SetContentAlignment(5)
		self.back:SetText(reason)
		self.back.DoClick = function(cancel) 
			if (IsValid(ix.gui.characterMenu)) then
				ix.gui.characterMenu:showContent()
			end
		end

		return false
	end

	ix.gui.charCreate = self

	local sideMargin = 0
	if (ScrW() > 1280) then
		sideMargin = ScrW() * 0.15
	elseif (ScrW() > 720) then
		sideMargin = ScrW() * 0.075
	end

	self.content = self:Add("DPanel")
	self.content:Dock(FILL)
	self.content:InvalidateParent(true);
	self.content:DockMargin(sideMargin, 64, sideMargin, 0)
	self.content:SetDrawBackground(false)

	self.model = self.content:Add("ixModelPanel")
	self.model:SetWide(ScrW() * 0.25)
	self.model:Dock(LEFT)
	self.model:InvalidateParent(true);
	self.model:SetModel("models/error.mdl")
	self.model:SetFOV(modelFOV)

	self.buttons = self:Add("DPanel")
	self.buttons:Dock(BOTTOM)
	self.buttons:SetTall(48)
	self.buttons:DockMargin(0, 32, 0, 0)
	self.buttons:SetDrawBackground(false)

	self.prev = self.buttons:Add("ixCharButton")
	self.prev:SetText(L("back"):upper())
	self.prev:Dock(LEFT)
	self.prev:SetWide(96)
	self.prev.DoClick = function(prev) self:PreviousStep() end

	self.next = self.buttons:Add("ixCharButton")
	self.next:SetText(L("next"):upper())
	self.next:Dock(RIGHT)
	self.next:SetWide(96)
	self.next.DoClick = function(next) self:NextStep() end

	self.cancel = self.buttons:Add("ixCharButton")
	self.cancel:SetText(L("cancel"):upper())
	self.cancel:SizeToContentsX()
	self.cancel.DoClick = function(cancel) 
		if (IsValid(ix.gui.characterMenu)) then
			ix.gui.characterMenu:showContent()
		end
	end
	self.cancel.x = (ScrW() - self.cancel:GetWide()) * 0.5 - 64
	self.cancel.y = (self.buttons:GetTall() - self.cancel:GetTall()) * 0.5

	self.steps = {}
	self.curStep = 0

	self:ShowCancelButton()
	self:ResetPayload(true)

	for k, v in pairs(steps) do
		self:AddStep(vgui.Create(v))
	end

	hook.Run("ConfigureCharacterCreationSteps", self)

	if (#self.steps == 0) then
		return self:showError("No character creation steps have been set up")
	end

	self:NextStep()

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

		if (IsValid(ix.gui.characterMenu)) then
			ix.gui.characterMenu:showContent()
		end

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
		self.content:SetVisible(true)
		self.buttons:SetVisible(true)
		self:ShowMessage()
		self:ShowError("Server did not authenticate your charcreate!")
	end)

	ix.gui.characterMenu:AddCharCreateTracker()
	ix.gui.characterMenu.charCreateTracker:Build()
end

-- Returns true if the local player can create a character, otherwise
-- returns false and a string reason for why.
function PANEL:CanCreateCharacter()
	local validFactions = {}
	for k, v in pairs(ix.faction.teams) do
		if (ix.faction.HasWhitelist(v.index)) then
			validFactions[#validFactions + 1] = v.index
		end
	end

	if (#validFactions == 0) then
		return false, "You are unable to join any factions"
	end
	self.validFactions = validFactions

	local maxChars = hook.Run("GetMaxPlayerCharacter", LocalPlayer()) or ix.config.Get("maxCharacters", 10)
	if (ix.characters and #ix.characters >= maxChars) then
		return false, "You have reached the maximum number of characters"
	end

	local canCreate, reason = hook.Run("ShouldMenuButtonShow", "create")
	if (canCreate == false) then
		return false, reason
	end

	return true
end

-- If the faction and model character data has been set, updates the
-- model panel on the left of the creation menu to reflect how the
-- character will look.
function PANEL:UpdateModel()
	local faction = ix.faction.indices[self.payload.faction]
	local modelInfo = faction.models[self.payload.model]
	local model, skin, groups

	if (istable(modelInfo)) then
		model, skin, groups = unpack(modelInfo)
	else
		model, skin, groups = modelInfo, 0, {}
	end

	self.model:SetModel(model)

	local entity = self.model:GetEntity()

	if (not IsValid(entity)) then return end

	entity:SetSkin(skin)

	if (istable(groups)) then
		for group, value in pairs(groups) do
			entity:SetBodygroup(group, value)
		end
	elseif (isstring(groups)) then
		entity:SetBodyGroups(groups)
	end
end

-- Shows a message with a red background in the current step.
function PANEL:ShowError(message, ...)
	if (IsValid(self.error)) then
		self.error:Remove()
	end
	if (not message or message == "") then return end
	message = L(message, ...)

	assert(IsValid(self.content), "no step is available")

	self.error = self.content:Add("DLabel")
	self.error:SetFont("ixPluginCharSubTitleFont")
	self.error:SetText(message)
	self.error:SetTextColor(color_white)
	self.error:Dock(TOP)
	self.error:SetTall(32)
	self.error:DockMargin(0, 0, 0, 8)
	self.error:SetContentAlignment(5)
	self.error.Paint = function(box, w, h)
		ix.util.DrawBlur(box)
		surface.SetDrawColor(255, 0, 0, 50)
		surface.DrawRect(0, 0, w, h)
	end
	self.error:SetAlpha(0)
	self.error:AlphaTo(255, ix.gui.characterMenu.ANIM_SPEED)

	ix.gui.characterMenu:warningSound()
end

-- Shows a normal message in the middle of this menu.
function PANEL:ShowMessage(message, ...)
	if (not message or message == "") then
		if (IsValid(self.message)) then self.message:Remove() end
		return
	end
	message = L(message, ...):upper()

	if (IsValid(self.message)) then
		self.message:SetText(message)
	end

	self.message = self:Add("DLabel")
	self.message:SetFont("ixPluginCharButtonFont")
	self.message:SetTextColor(ix.gui.characterMenu.WHITE)
	self.message:Dock(FILL)
	self.message:SetContentAlignment(5)
	self.message:SetText(message)
end

-- Resets the character creation menu to the first step and clears form data.
function PANEL:Reset()
	self:ResetPayload();

	if (IsValid(self.steps[self.curStep])) then
		self.steps[self.curStep]:SetVisible(false)
		self.steps[self.curStep]:OnHide()
	end

	self:NextStep()
end

-- Adds a step to the list of steps to be shown in the character creation menu.
-- Priority is a number (lower is higher priority) that can change order.
function PANEL:AddStep(step, priority)
	if (isnumber(priority)) then
		table.insert(self.steps, math.min(priority, #self.steps + 1), step)
	else
		self.steps[#self.steps + 1] = step
	end
	step:SetParent(self.content)
end

-- Moves to the next available step. If none are, onFinish is called.
-- If there is a validation error, that is shown first.
function PANEL:NextStep()
	local lastStep = self.curStep
	local curStep = self.steps[lastStep]

	if (IsValid(curStep)) then
		local res = {curStep:Validate()}
		
		if (res[1] == false) then return self:ShowError(unpack(res, 2)) end
	end

	-- Clear any error messages.
	self:ShowError()

	-- Move to the next step. Call onFinish if none exists.
	self.curStep = self.curStep + 1
	local nextStep = self.steps[self.curStep]
	while (IsValid(nextStep) and nextStep:ShouldSkip()) do
		self.curStep = self.curStep + 1
		nextStep:OnSkip()
		nextStep = self.steps[self.curStep]
	end
	if (not IsValid(nextStep)) then
		self.curStep = lastStep
		return self:SendPayload() 
	end

	-- Transition the view to the next step's view.
	self:OnStepChanged(curStep, nextStep)
	self:ShowCancelButton()

	-- Updates the index of the charactermenu, moving it to the right.
	if(ix.gui.characterMenu.charCreateTracker) then
		ix.gui.characterMenu.charCreateTracker:MoveRight()
	end
end

-- Moves to the previous available step if one exists.
function PANEL:PreviousStep()
	if(!IsValid(self:GetPreviousStep())) then
		if (IsValid(ix.gui.characterMenu)) then
			ix.gui.characterMenu:showContent()
		end
	end

	local curStep = self.steps[self.curStep]
	local newStep = self.curStep - 1
	local prevStep = self.steps[newStep]
	while (IsValid(prevStep) and prevStep:ShouldSkip()) do
		prevStep:OnSkip()
		newStep = newStep - 1
		prevStep = self.steps[newStep]
	end

	if (not IsValid(prevStep)) then return end

	self.curStep = newStep
	self:OnStepChanged(curStep, prevStep)
	self:ShowCancelButton()

	-- Updates the index of the charactermenu, moving it to the left.
	if(ix.gui.characterMenu.charCreateTracker) then
		ix.gui.characterMenu.charCreateTracker:MoveLeft()
	end
end

-- Returns the panel for the step shown prior to this step.
function PANEL:GetPreviousStep()
	local step = self.curStep - 1
	while (IsValid(self.steps[step])) do
		if (not self.steps[step]:ShouldSkip()) then
			hasPrevStep = true
			break
		end
		step = step - 1
	end
	return self.steps[step]
end

-- Called when the step has been changed via nextStep or previousStep.
-- This is where transitions are handled.
function PANEL:OnStepChanged(oldStep, newStep)
	local ANIM_SPEED = ix.gui.characterMenu.ANIM_SPEED
	local shouldFinish = self.curStep == #self.steps
	local nextStepText = L(shouldFinish and "finish" or "next"):upper()
	local shouldSwitchNextText = nextStepText ~= self.next:GetText()

	if (shouldSwitchNextText) then
		self.next:AlphaTo(0, ANIM_SPEED)
	end

	-- Transition the view to the new step view.
	local function ShowNewStep()
		newStep:SetAlpha(0)
		newStep:SetVisible(true)
		newStep:Display()
		newStep:InvalidateChildren(true)
		newStep:AlphaTo(255, ANIM_SPEED)

		if (shouldSwitchNextText) then
			self.next:SetAlpha(0)
			self.next:SetText(nextStepText)
			self.next:SizeToContentsX()
		end
		self.next:AlphaTo(255, ANIM_SPEED)
	end
	if (IsValid(oldStep)) then
		oldStep:AlphaTo(0, ANIM_SPEED, 0, function()
			self:ShowError()
			oldStep:SetVisible(false)
			oldStep:OnHide()
			ShowNewStep()
		end)
	else
		ShowNewStep()
	end
end

function PANEL:ShowCancelButton()
	if(!IsValid(self:GetPreviousStep())) then
		self.cancel:SetVisible(false)
	elseif(IsValid(self:GetPreviousStep())) then
		self.cancel:SetVisible(true)
	end
end

-- Called after the player has pressed "next" on the last step. This
-- requests for a character to be made using the set character data.
function PANEL:SendPayload()
	if (self.awaitingResponse or !self:VerifyProgression()) then
		return
	end

	self.content:SetVisible(false)
	self.buttons:SetVisible(false)
	self:ShowMessage("creating")
	self.awaitingResponse = true

	timer.Create("ixCharacterCreateTimeout", 10, 1, function()
		if (IsValid(self) and self.awaitingResponse) then
			self.awaitingResponse = false
			self.content:SetVisible(true)
			self.buttons:SetVisible(true)
			self:ShowMessage()
			self:ShowError("Unknown Error")
		end
	end)

	self.payload:Prepare()

	net.Start("ixCharacterCreate")
		net.WriteTable(self.payload)
	net.SendToServer()
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
					self:ShowError(L(unpack(result, 2)))
					return false
				end
			end

			self.payload[k] = value
		end
	end

	return true
end

vgui.Register("ixCharacterCreation", PANEL, "EditablePanel")
