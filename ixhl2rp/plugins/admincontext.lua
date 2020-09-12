
local PLUGIN = PLUGIN or {}

PLUGIN.name = "Context Menu Options"
PLUGIN.author = "Gary Tate"
PLUGIN.description = "Adds several context options on players."
PLUGIN.readme = [[
Adds several context options on players.

Support for this plugin can be found here: https://discord.gg/mntpDMU
]]
PLUGIN.license = [[
The MIT License (MIT)
Copyright (c) 2020 Gary Tate
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]

CAMI.RegisterPrivilege({
	Name = "Helix - Admin Context Options",
	MinAccess = "admin"
})

if (SERVER) then
	ix.log.AddType("contextMenuAdmin", function(client, ...)
		local arg = {...}
		return string.format("%s has used context menu option '%s' on player %s (%s)", client:SteamName().." ("..client:SteamID()..")", arg[1], arg[2], arg[3])
	end)
end

properties.Add("ixViewPlayerProperty", {
	MenuLabel = "#View Player",
	Order = 1,
	MenuIcon = "icon16/user.png",
	Format = "%s | %s\nHealth: %s\nArmor: %s",
	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,
	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,
	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			client:NotifyLocalized(string.format(self.Format, entity:Nick(), entity:SteamID(), entity:Health(), entity:Armor()))
		end
	end
})

properties.Add("ixSetHealthProperty", {
	MenuLabel = "#Health",
	Order = 2,
	MenuIcon = "icon16/heart.png",
	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,
	MenuOpen = function( self, option, ent, tr )
		local submenu = option:AddSubMenu()
		local hpchoices = {100,75,50,25,1,0}

		for i,v in ipairs(hpchoices) do
			submenu:AddOption(v, function() self:SetHealth( ent, v ) end )
		end
	end,
	SetHealth = function(self, target, health)
		self:MsgStart()
			net.WriteEntity(target)
			net.WriteUInt(health, 8)
		self:MsgEnd()
	end,
	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			local health = net.ReadUInt(8)

			entity:SetHealth(health)
			if (entity:Health() == 0) then entity:Kill() end
			
			ix.log.Add(client, "contextMenuAdmin", "SetHealth", entity:Name(), "HP->"..health)
		end
	end
})

properties.Add("ixSetArmorProperty", {
	MenuLabel = "#Armor",
	Order = 3,
	MenuIcon = "icon16/shield.png",
	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,
	MenuOpen = function( self, option, ent, tr )
		local submenu = option:AddSubMenu()

		for i = 100, 0, -25 do
			submenu:AddOption(i, function() self:SetArmor( ent, i ) end )
		end
	end,
	SetArmor = function(self, target, armor)
		self:MsgStart()
			net.WriteEntity(target)
			net.WriteUInt(armor, 8)
		self:MsgEnd()
	end,
	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			local armor = net.ReadUInt(8)

			entity:SetArmor(armor)
			
			ix.log.Add(client, "contextMenuAdmin", "SetArmor", entity:Name(), "Armor->"..armor)
			
		end
	end
})

properties.Add("ixSetDescriptionProperty", {
	MenuLabel = "#Edit Description",
	Order = 4,
	MenuIcon = "icon16/book_edit.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			client:RequestString("Set the character's description.", "New Description", function(text)
				entity:GetCharacter():SetDescription(text)
				ix.log.Add(client, "contextMenuAdmin", "SetDescription", entity:Name(), text)
			end, entity:GetCharacter():GetDescription())	
		end
	end
})

properties.Add("ixViewTraits", {
	MenuLabel = "#Print Traits",
	Order = 4,
	MenuIcon = "icon16/book_edit.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,

	Action = function(self, entity)
		self:MsgStart()
			net.WriteEntity(entity)
		self:MsgEnd()
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			local character = entity:GetCharacter()
			local traits = character:GetData("traits", {})
			local traitString = ""

			for i = 1, #traits do
				if(i == 1) then
					traitString = traitString .. traits[i]
				else 
					traitString = traitString .. ", " .. traits[i]
				end
			end
	

			client:NotifyLocalized("This players traits are: " .. traitString)
		end
	end
})

properties.Add("ixSendTo", {
	MenuLabel = "#Send to",
	Order = 5,
	MenuIcon = "icon16/world_go.png",

	Filter = function(self, entity, client)
		return CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil) and entity:IsPlayer()
	end,

	MenuOpen = function( self, option, ent, tr )

		local submenu = option:AddSubMenu()
		
		submenu:AddOption("Brazil", function() self:MsgStart()
			net.WriteEntity(ent)
			net.WriteInt(1,32)
		self:MsgEnd() end )
		
		submenu:AddOption("Bermuda", function() self:MsgStart()
			net.WriteEntity(ent)
			net.WriteInt(2,32)
		self:MsgEnd() end )
		
		submenu:AddOption("Bosnia", function() self:MsgStart()
			net.WriteEntity(ent)
			net.WriteInt(3,32)
		self:MsgEnd() end )

	end,

	Action = function(self, entity)
		-- not used
	end,

	Receive = function(self, length, client)
		if (CAMI.PlayerHasAccess(client, "Helix - Admin Context Options", nil)) then
			local entity = net.ReadEntity()
			local option = net.ReadUInt(8)
			
			if (option==1) then
				entity:Ignite(2)
				timer.Create(entity:GetName().."brazilTimer"..math.random(1,100), 2, 1, function() entity:Kill() end)
			
				ix.log.Add(client, "contextMenuAdmin", "BrazilianAirlines", entity:Name(), "cinzas as Cinzas")
			elseif (option==2) then
							
				ix.log.Add(client, "contextMenuAdmin", "BermudaAirlines", entity:Name(), "Kicked")
				entity:Kick("Kicked for Minging. Kicked by: ".. client:SteamName())				
			elseif (option==3) then
							
				ix.log.Add(client, "contextMenuAdmin", "BosnianAirlines", entity:Name(), "happy new year")
				

				entity:SetVelocity(Vector(0,0,10000))
				timer.Simple(1, function()
					
					if (IsValid(entity)) then
						local effectdata = EffectData()
						effectdata:SetOrigin(entity:GetPos())
						
						util.Effect("Explosion", effectdata)
						entity:Kill()
					end
				end)
				
			end
			
		end
	end
})