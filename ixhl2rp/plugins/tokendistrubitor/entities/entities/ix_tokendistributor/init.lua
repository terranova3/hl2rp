include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Status:
-- 1: Green light (online)
-- 2: Red light (offline)
-- 3: orange light (busy)

local PLUGIN = PLUGIN

function ENT:Initialize()
	self:SetModel("models/props_combine/suit_charger001.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end

	self.RequesterList = {}
	self.BusyUntil = 0
	self.NextUse = 0
	self.UserTable = {}
	self:SetActive(true)
end

function ENT:Use(activator)

	if self.NextUse > CurTime() then
		return
	else
		self.NextUse = CurTime() + 1
	end

	if self.BusyUntil > CurTime() then return end


	if activator:IsValid() and activator:IsPlayer() then
		local chr = activator:GetCharacter()

		if !self:IsActive() and chr:GetFaction() != FACTION_ADMIN then
			self:EmitSound("buttons/combine_button_locked.wav")
		end

		if chr:GetClass() != nil and chr:GetClass() == CLASS_MM and self:IsActive() then
			local cooldown = self:GetCooldown(chr)
			if cooldown > 0 then
				local cooldownMinutes = math.ceil(cooldown / 60)
				ix.util.Notify("You can not use this machine for "..cooldownMinutes.." minutes.")
				self:Error()
				return
			end
			netstream.Start(activator, "ixTokenDistributorRequestPnl", "cwu", self)
		elseif chr:GetFaction() == FACTION_ADMIN then
			netstream.Start(activator, "ixTokenDistributorRequestPnl", "admin", self)
		elseif self:IsActive() then
			self:Error()
		end
	end
end

function ENT:SetActive(isActive)
	if self.BusyUntil > CurTime() then return end
	self.isActive = isActive
	self:SetNWInt("status", isActive and 1 or 2)
	self:SetNWBool("isActive", isActive)
	self:EmitSound("buttons/combine_button1.wav")
end

function ENT:Error()
	self:EmitSound("buttons/combine_button_locked.wav")
	self:SetNWInt("status", 2)
	self.BusyUntil = CurTime() + 0.8

	timer.Simple(0.5, function()
		self:SetNWInt("status", 1)
	end)
end

function ENT:ToggleActivity()
	self:SetActive(!self:IsActive())
end

function ENT:IsActive()
	return self.isActive
end

function ENT:GiveTokens(chr, amount)
	-- Hook that calls this function handles character permissions already.
	if !self:IsActive() then return end

	if self.BusyUntil > CurTime() then return end
	self.BusyUntil = CurTime() + 3.5

	self.UserTable[chr:GetID()] = CurTime()
	self:SetNWInt("status", 3)
	self:EmitSound("ambient/machines/combine_terminal_idle4.wav")

	timer.Simple(2.5, function()
		local entAngles = self:GetAngles()
		local tokenSpawnPos = self:GetPos() + entAngles:Forward() * 15
		ix.currency.Spawn(tokenSpawnPos, amount)
		self:SetNWInt("status", 1)
	end)
end

function ENT:GetCooldown(chr)
	for k,v in pairs(self.UserTable) do
		if k == chr:GetID() then
			local lastUsed = CurTime() - v
			if lastUsed >= PLUGIN.UseCooldown then
				self.UserTable[k] = nil
				return 0
			else
				return PLUGIN.UseCooldown - lastUsed
			end
		end
	end
	return 0
end