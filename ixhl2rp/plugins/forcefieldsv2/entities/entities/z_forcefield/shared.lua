if (SERVER) then
	AddCSLuaFile();
end;

local material = Material("effects/com_shield003a");

ENT.Type 			= "anim";
ENT.Base 			= "base_anim";
ENT.PrintName		= "Forcefield";
ENT.Category		= "Forcefields";
ENT.Spawnable		= true;
ENT.AdminOnly		= true;
ENT.RenderGroup 	= RENDERGROUP_BOTH;
ENT.PhysgunDisabled = true;
ENT.isLoaded = false

if (SERVER) then
	function ENT:SpawnFunction(player, trace)
		if !(trace.Hit) then return; end;
		local entity = ents.Create("z_forcefield");

		entity:SetPos(trace.HitPos + Vector(0, 0, 40));
		entity:SetAngles(Angle(0, trace.HitNormal:Angle().y - 90, 0));
		entity:Spawn();
		entity.Owner = player;

		return entity;
	end;

	function ENT:SetupDataTables()
		self:DTVar("Bool", 0, "Enabled");
		self:DTVar("Bool", 1, "UnionCard")
		self:DTVar("Entity", 0, "Dummy");
	end;

	function ENT:Initialize()
		self:SetModel("models/props_combine/combine_fence01b.mdl");
		self:SetSolid(SOLID_VPHYSICS);
		self:SetUseType(SIMPLE_USE);
		self:PhysicsInit(SOLID_VPHYSICS);
		self:DrawShadow(false);

		if (!self.isLoaded) then
			self:SetDTBool(0, true);
		end

		if (!self.noCorrect) then
			local data = {};
			data.start = self:GetPos();
			data.endpos = self:GetPos() - Vector(0, 0, 300);
			data.filter = self;
			local trace = util.TraceLine(data);

			if trace.Hit and util.IsInWorld(trace.HitPos) and self:IsInWorld() then
				self:SetPos(trace.HitPos + Vector(0, 0, 39.9));
			end;

			data = {};
			data.start = self:GetPos();
			data.endpos = self:GetPos() + Vector(0, 0, 150);
			data.filter = self;
			trace = util.TraceLine(data);

			if (trace.Hit) then
				self:SetPos(self:GetPos() - Vector(0, 0, trace.HitPos:Distance(self:GetPos() + Vector(0, 0, 151))));
			end;
		end;

		data = {};
		data.start = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -16;
		data.endpos = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -600;
		data.filter = self;
		trace = util.TraceLine(data);

		self.post = ents.Create("prop_physics")
		self.post:SetModel("models/props_combine/combine_fence01a.mdl")
		self.post:SetPos(self.forcePos or trace.HitPos - Vector(0, 0, 50))
		self.post:SetAngles(Angle(0, self:GetAngles().y, 0));
		self.post:Spawn();
		self.post:PhysicsDestroy()
		self.post:SetCollisionGroup(COLLISION_GROUP_WORLD);
		self.post:DrawShadow(false);
		self.post:DeleteOnRemove(self);
		self:DeleteOnRemove(self.post);

		local verts = {
			{pos = Vector(0, 0, -35)},
			{pos = Vector(0, 0, 150)},
			{pos = self:WorldToLocal(self.post:GetPos()) + Vector(0, 0, 150)},
			{pos = self:WorldToLocal(self.post:GetPos()) + Vector(0, 0, 150)},
			{pos = self:WorldToLocal(self.post:GetPos()) - Vector(0, 0, 35)},
			{pos = Vector(0, 0, -35)},
		}

		self:PhysicsFromMesh(verts);

		local physObj = self:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:SetMaterial("default_silent");
			physObj:EnableMotion(false);
		end;

		self:SetCustomCollisionCheck(true);
		self:EnableCustomCollisions(true);

		physObj = self.post:GetPhysicsObject();

		if (IsValid(physObj)) then
			physObj:EnableMotion(false);
		end;

		self:SetDTEntity(0, self.post);

		self.ShieldLoop = CreateSound(self, "ambient/machines/combine_shield_loop3.wav");
		self.AllowedClasses = {};
	end;

	function ENT:StartTouch(ent)
		if (!self:GetDTBool(0)) then return; end;

		if (ent:IsPlayer()) then
			if (!ent.ShieldTouch) then
				ent.ShieldTouch = CreateSound(ent, "ambient/machines/combine_shield_touch_loop1.wav");
				ent.ShieldTouch:Play();
				ent.ShieldTouch:ChangeVolume(0.25, 0);
			else
				ent.ShieldTouch:Play();
				ent.ShieldTouch:ChangeVolume(0.25, 0.5);
			end;
		end;
	end;

	function ENT:Touch(ent)
		if (!self:GetDTBool(0)) then return; end;

		if (ent:IsPlayer()) then
			if ent.ShieldTouch then
				ent.ShieldTouch:ChangeVolume(0.3, 0);
			end;
		end;
	end;

	function ENT:EndTouch(ent)
		if (!self:GetDTBool(0)) then return; end;

		if (ent:IsPlayer()) then
			if (ent.ShieldTouch) then
				ent.ShieldTouch:FadeOut(0.5);
			end;
		end;
	end;

	function ENT:Think()
		if (!self:GetDTBool(0)) and self.post:GetSkin() == 0 then
			self.post:SetSkin(1)
		end

		if (IsValid(self) and self:GetDTBool(0)) then
			self.ShieldLoop:Play();
			self.ShieldLoop:ChangeVolume(0.4, 0);
		else
			self.ShieldLoop:Stop();
		end;

		if (IsValid(self:GetPhysicsObject())) then
			self:GetPhysicsObject():EnableMotion(false);
		end;
	end;

	function ENT:OnRemove()
		if (self.ShieldLoop) then
			self.ShieldLoop:Stop();
		end;
	end;

	function ENT:Use(act, call, type, val)
		if ((self.nextUse or 0) < CurTime()) then
			self.nextUse = CurTime() + 1;
		else
			return;
		end;

		if (client:IsCombine() or character:Team() == FACTION_ADMIN) then
			if (act:KeyDown(IN_WALK)) then
				netstream.Start(act, "forcefieldMenu", self);

				act:SetNWEntity("ffTarget", self);

				return;
			end;
		end

		if character:GetClass() == CLASS_CWU then
			self:SetDTBool(0, !self:GetDTBool(0));

			if (!self:GetDTBool(0)) then
				self:SetSkin(1);
				self.post:SetSkin(1);
				self:EmitSound("shield/deactivate.wav");
				self:SetCollisionGroup(COLLISION_GROUP_WORLD);
			else
				self:SetSkin(0);
				self.post:SetSkin(0);
				self:EmitSound("shield/activate.wav");
				self:SetCollisionGroup(COLLISION_GROUP_NONE);
			end;

			self:EmitSound("buttons/combine_button5.wav", 110, 90);
		end;
	end;

	function ENT:OnRemove()
		if (self.ShieldLoop) then
			self.ShieldLoop:Stop();
			self.ShieldLoop = nil;
		end;

		if (self.ShieldTouch) then
			self.ShieldTouch:Stop();
			self.ShieldTouch = nil;
		end;
	end;

	function ENT:AddClass(class)
		self.AllowedClasses[class] = true;
		netstream.Start(nil, "forcefieldUpdate", "addClass", {self, class});
	end;

	function ENT:RemoveClass(class)
		self.AllowedClasses[class] = nil;
		netstream.Start(nil, "forcefieldUpdate", "removeClass", {self, class});
	end;

	function ENT:SendFullUpdate(player)
		if (IsValid(player)) then
			netstream.Start(player, "forcefieldUpdate", "fullUpdate", {self, self.AllowedClasses});
		elseif (player == false) then
			netstream.Start(nil, "forcefieldUpdate", "fullUpdate", {self, self.AllowedClasses});
		end;
	end;
else
	function ENT:Initialize()
		local data = {};
		data.start = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -16;
		data.endpos = self:GetPos() + Vector(0, 0, 50) + self:GetRight() * -600;
		data.filter = self;

		local trace = util.TraceLine(data);

		local verts = {
			{pos = Vector(0, 0, -35)},
			{pos = Vector(0, 0, 150)},
			{pos = self:WorldToLocal(trace.HitPos - Vector(0, 0, 50)) + Vector(0, 0, 150)},
			{pos = self:WorldToLocal(trace.HitPos - Vector(0, 0, 50)) + Vector(0, 0, 150)},
			{pos = self:WorldToLocal(trace.HitPos - Vector(0, 0, 50)) - Vector(0, 0, 35)},
			{pos = Vector(0, 0, -35)},
		};

		self:PhysicsFromMesh(verts);
		self:EnableCustomCollisions(true);

		self.AllowedClasses = {};
	end;

	function ENT:Draw()
		local post = self:GetDTEntity(0);
		local angles = self:GetAngles();
		local matrix = Matrix();

		self:DrawModel();
		matrix:Translate(self:GetPos() + self:GetUp() * -40 + self:GetForward() * -2);
		matrix:Rotate(angles);

		render.SetMaterial(material);

		if (IsValid(post)) then
			local vertex = self:WorldToLocal(post:GetPos());
			self:SetRenderBounds(vector_origin - Vector(0, 0, 40), vertex + self:GetUp() * 150);

			cam.PushModelMatrix(matrix);
			self:DrawShield(vertex);
			cam.PopModelMatrix();

			matrix:Translate(vertex);
			matrix:Rotate(Angle(0, 180, 0));

			cam.PushModelMatrix(matrix);
			self:DrawShield(vertex);
			cam.PopModelMatrix();
		end;
	end;

	-- I took a peek at how Chessnut drew his forcefields.
	function ENT:DrawShield(vertex)
		if (self:GetDTBool(0)) then
			local dist = self:GetDTEntity(0):GetPos():Distance(self:GetPos());
			local matFac = 45;
			local height = 5;
			local frac = dist / matFac;

			mesh.Begin(MATERIAL_QUADS, 1);
				mesh.Position(vector_origin);
				mesh.TexCoord(0, 0, 0);
				mesh.AdvanceVertex();

				mesh.Position(self:GetUp() * 190);
				mesh.TexCoord(0, 0, height);
				mesh.AdvanceVertex();

				mesh.Position(vertex + self:GetUp() * 190);
				mesh.TexCoord(0, frac, height);
				mesh.AdvanceVertex();

				mesh.Position(vertex);
				mesh.TexCoord(0, frac, 0);
				mesh.AdvanceVertex();
			mesh.End();
		end;
	end;
end;

hook.Add("ShouldCollide", "forcefieldShouldCollide", function(ent1, ent2)
	local projectiles = {};

	projectiles["crossbow_bolt"]		 	= true;
	projectiles["grenade_ar2"]			 	= true;
	projectiles["hunter_flechette"]	 		= true;
	projectiles["npc_clawscanner"]		 	= true;
	projectiles["npc_combine_camera"]	 	= true;
	projectiles["npc_combine_s"]		 	= true;
	projectiles["npc_combinedropship"]	 	= true;
	projectiles["npc_combinegunship"]	 	= true;
	projectiles["npc_cscanner"]		 		= true;
	projectiles["npc_grenade_frag"]			= true;
	projectiles["npc_helicopter"]		 	= true;
	projectiles["npc_hunter"]			 	= true;
	projectiles["npc_manhack"]			 	= true;
	projectiles["npc_metropolice"]		 	= true;
	projectiles["npc_rollermine"]		 	= true;
	projectiles["npc_stalker"]			 	= true;
	projectiles["npc_strider"]			 	= true;
	projectiles["npc_tripmine"]		 		= true;
	projectiles["npc_turret_ceiling"]	 	= true;
	projectiles["npc_turret_floor"] 	 	= true;
	projectiles["prop_combine_ball"]		= true;
	projectiles["prop_physics"]		 		= true;
	projectiles["prop_vehicle_zapc"]	 	= true;
	projectiles["rpg_missile"]			 	= true;

	local player
	local entity

	if (ent1:IsPlayer()) then
		player = ent1;
		entity = ent2;
	elseif (ent2:IsPlayer()) then
		player = ent2;
		entity = ent1;
	elseif (projectiles[ent1:GetClass()] and ent2:GetClass() == "z_forcefield") then
		return false;
	elseif (projectiles[ent2:GetClass()] and ent1:GetClass() == "z_forcefield") then
		return false;
	end;

	if (IsValid(entity) and entity:GetClass() == "z_forcefield") then
		if (IsValid(player)) then
			if (!entity:GetDTBool(0)) then
				return false;
			end;

			if (entity.AllowedClasses) then
				return false;
			elseif (entity:GetDTBool(1)) then
				if SERVER and player:HasItemByID("union_card") then
					return false
				end
			else
				return true;
			end;
		else
			return entity:GetDTBool(0);
		end;
	end;
end)