AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Money"
ENT.Category = "Helix"
ENT.Spawnable = false
ENT.ShowPlayerInteraction = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Amount")
end

if (SERVER) then
	local invalidBoundsMin = Vector(-8, -8, -8)
	local invalidBoundsMax = Vector(8, 8, 8)

	function ENT:Initialize()
		self:SetModel(ix.currency.model)
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(true)
			physObj:Wake()
		else
			self:PhysicsInitBox(invalidBoundsMin, invalidBoundsMax)
			self:SetCollisionBounds(invalidBoundsMin, invalidBoundsMax)
		end
	end

	local skinArray = {
		[1] = 0,
		[5] = 1,
		[10] = 2,
		[20] = 3,
		[50] = 4,
		[100] = 5,
		[200] = 6,
		[500] = 7
	}

	function ENT:AdaptModel()
		local amount = self:GetAmount()

		if(amount == 1) then
			self:SetCustomModel("single", 1)
		elseif(amount < 5) then
			self:SetCustomModel("stack", 1)
		elseif(amount == 5) then
			self:SetCustomModel("single", 5)
		elseif(amount < 9) then
			self:SetCustomModel("stack", 1)
		elseif(amount == 10) then
			self:SetCustomModel("single", 10)
		elseif(amount < 20) then
			self:SetCustomModel("stack", 5)
		elseif(amount == 20) then
			self:SetCustomModel("single", 20)
		elseif(amount < 50) then
			self:SetCustomModel("stack", 10)
		elseif(amount == 50) then
			self:SetCustomModel("single", 50)
		elseif(amount < 100) then
			self:SetCustomModel("stack", 20)
		elseif(amount == 100) then
			self:SetCustomModel("single", 100)
		elseif(amount < 200) then
			self:SetCustomModel("stack", 50)
		elseif(amount == 200) then
			self:SetCustomModel("single", 200)
		elseif(amount < 500) then
			self:SetCustomModel("stack", 100)
		elseif(amount == 500) then
			self:SetCustomModel("single", 500)
		elseif(amount < 2000) then
			self:SetCustomModel("stack", 200)
		else
			self:SetCustomModel("stack", 500)
		end
	end

	function ENT:SetCustomModel(modelType, skin)
		if(modelType == "stack") then
			self:SetModel("models/notes/stack.mdl")
		else
			self:SetModel("models/notes/singlenote.mdl")
		end

		self:SetSkin(skinArray[skin])
	end

	function ENT:Use(activator)
		if (self.ixSteamID and self.ixCharID) then
			local char = activator:GetCharacter()

			if (char and self.ixCharID != char:GetID() and self.ixSteamID == activator:SteamID()) then
				activator:NotifyLocalized("itemOwned")
				return false
			end
		end

		activator:PerformInteraction(ix.config.Get("itemPickupTime", 0.5), self, function(client)
			if (hook.Run("OnPickupMoney", client, self) != false) then
				self:Remove()
			end
		end)
	end

	function ENT:UpdateTransmitState()
		return TRANSMIT_PVS
	end
else
	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(container)
		local text = container:AddRow("name")
		text:SetImportant()
		text:SetText(ix.currency.Get(self:GetAmount()))
		text:SizeToContents()
	end
end
