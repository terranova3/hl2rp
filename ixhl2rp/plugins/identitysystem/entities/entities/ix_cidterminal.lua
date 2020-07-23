AddCSLuaFile()
--[[-------------------------------------------------------------------------
TODO: PLAY ANIMATION WHEN DEPLOYING SUPPORT
---------------------------------------------------------------------------]]
ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "CID Creator"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.RenderGroup = RENDERGROUP_BOTH

if SERVER then
	function ENT:Initialize()
		self:SetModel("models/props_combine/breenconsole.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		--self:PhysicsInit(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)
		self.health = 50
	end

	function ENT:Use(user)
		if(user:IsCombine() or user:GetCharacter():HasFlags("i")) then
			user:SetAction("Logging in...", 1, function()
				netstream.Start(user, "OpenCIDMenu", {})
				user:Freeze(false)
			end)

			self:EmitSound("buttons/button14.wav", 100, 50)
			user:SelectWeapon("ix_hands")
			user:Freeze(true)
		else
			user:Notify("The terminal doesn't appear to be responding to your ID Card.")
		end
	end
else
	surface.CreateFont("panel_font", {
		["font"] = "verdana",
		["size"] = 12,
		["weight"] = 128,
		["antialias"] = true
	})

	function ENT:Draw()
		self:DrawModel()
		local ang = self:GetAngles()
		local pos = self:GetPos() + ang:Up() * 48 + ang:Right() * -5 + ang:Forward() * -9.75
		ang:RotateAroundAxis(ang:Forward(), 42)
		cam.Start3D2D(pos, ang, 0.1)
		local width, height = 155, 77
		surface.SetDrawColor(Color(16, 16, 16))

		if self:GetNetVar("destroyed", false) then
			surface.SetDrawColor(Color(255, 0, 0, 255))
		end

		surface.DrawRect(0, 0, width, height)
		surface.SetDrawColor(Color(255, 255, 255, 16))

		if self:GetNetVar("destroyed", false) then
			surface.SetDrawColor(Color(255, 0, 0, 255))
		end

		surface.DrawRect(0, height / 2 + math.sin(CurTime() * 4) * height / 2, width, 1)
		local alpha = 191 + 64 * math.sin(CurTime() * 4)

		if not self:GetNetVar("InUse", false) then
			if self:GetNetVar("destroyed", false) then
				draw.SimpleText("", "panel_font", 5, 36, Color(90, 210, 255, alpha))
				draw.SimpleText("ERR-...", "panel_font", 5, 46, Color(102, 255, 255, alpha))
			end

			draw.SimpleText("CID Creation Terminal", "panel_font", width / 2, 25, Color(90, 210, 255, alpha), TEXT_ALIGN_CENTER)
			draw.SimpleText("Waiting for input", "panel_font", width / 2, height - 16, Color(205, 255, 180, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		else
			draw.SimpleText(LocalPlayer():SteamID64(), "panel_font", 5, 36, Color(90, 210, 255, alpha))
			draw.SimpleText("Validating Input...", "panel_font", 5, 46, Color(102, 255, 255, alpha))
		end

		cam.End3D2D()
	end
end