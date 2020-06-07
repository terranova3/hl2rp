-- This file contains the panel that you should inherit from if you are adding
-- a new step for the character creation process.

local PANEL = {}

PANEL.isCharCreateStep = true

function PANEL:Init()
	self:Dock(FILL)
	self:SetDrawBackground(false)
	self:SetVisible(false)
	self.stagePanels = {}
end

-- Called when this step is made visible.
function PANEL:Display()
end

-- Requests for the next step to be shown, or to finish character creation
-- if this is the final step.
function PANEL:Forward()
	ix.gui.charCreate:NextStep()
end

-- Requests for the previous step to be shown.
function PANEL:Backwards()
	ix.gui.charCreate:PreviousStep()
end

-- Runs the character validation given the name of a character variable.
function PANEL:ValidateCharVar(name)
	local charVar = ix.char.vars[name]
	assert(charVar, "invalid character variable "..tostring(name))

	if (isfunction(charVar.OnValidate)) then
		return charVar.OnValidate(
			self,
			self:GetPayload(name),
			self:GetPayload()
		)
	end
	return true
end

-- Returns whether or not the input for this form is valid. You should override
-- this if you need custom validation.
function PANEL:Validate()
	return true
end

-- Sets the value of a character variable corresponding to key for the character
-- that is going to be created.
function PANEL:SetPayload(key, value)
	ix.gui.charCreate:SetPayload(key, value)
end

-- Removes any set character variables for the character that is going to be
-- created.
function PANEL:ResetPayload()
	ix.gui.charCreate:ResetPayload();
end

-- Returns the set character variable corresponding to key. If it does not
-- exist, then default (which is nil if not set) is returned.
function PANEL:GetPayload(key, default)
	if (key == nil) then
		return ix.gui.charCreate.payload
	end
	local value = ix.gui.charCreate.payload[key]
	if (value == nil) then
		return default
	end
	return value
end

function PANEL:GetPayloadSize(key)
	local payload = self:GetPayload(key)

	if(istable(payload)) then
		local count = 0

		for _, v in pairs(payload) do
			count = count + 1
		end

		return count
	end

	return 1
end

-- Returns the model panel to the left of the step view.
function PANEL:GetModelPanel()
	return ix.gui.charCreate.model
end

-- Requests that the model panel for the character is updated.
function PANEL:UpdateModelPanel()
	ix.gui.charCreate:UpdateModel()
end

-- Return true if this step should be skipped, false otherwise. This should
-- not have any side effects. Side effects go in onSkip.
function PANEL:ShouldSkip()
	return false
end

-- Helper function to add a label that is docked at the top of the step.
function PANEL:AddLabel(text)
	local label = self:Add("DLabel")
	label:SetFont("ixPluginCharButtonFont")
	label:SetText(L(text):upper())
	label:SizeToContents()
	label:Dock(TOP)
	return label
end

-- Helper function to add a label that is docked at the top of the step.
function PANEL:SubLabel(text)
	local label = self:Add("DLabel")
	label:SetFont("ixPluginCharButtonSubFont")
	label:SetText(L(text):upper())
	label:SizeToContents()
	label:Dock(TOP)
	return label
end

-- Helper function to register a name variable onto the panel.
function PANEL:Register(name)
	self.stepName = name
end

-- Helper function to add stages for a step.
function PANEL:AddStagePanel(name)
	local id = #self.stagePanels + 1;

	local panel = self:Add("DPanel");
	panel:InvalidateParent(true)
	panel:Dock(FILL)
	panel:SetVisible(false);
	panel.OnSetActive = function() end
	panel.Paint = function() end

	self.stagePanels[id] = {}
	self.stagePanels[id].panel = panel;
	self.stagePanels[id].subpanelName = name;

	return panel;
end;

-- Sets the active panel of the step.
function PANEL:SetActivePanel(name)
	for i = 1, #self.stagePanels do
		if(self.stagePanels[i].subpanelName == name) then
			self.stagePanels[i].panel:SetVisible(true);
			self.stagePanels[i].panel:OnSetActive();
		else
			self.stagePanels[i].panel:SetVisible(false);
		end;
	end;
end;

-- Called if this step has been skipped over.
function PANEL:OnSkip() end

-- Called if this step has been hidden.
function PANEL:OnHide() end

vgui.Register("ixCharacterCreateStep", PANEL, "DPanel")
