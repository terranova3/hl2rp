ITEM.name = "Deployable Turret"
ITEM.model = Model("models/combine_turrets/floor_turret.mdl")
ITEM.entityName = "npc_turret_floor"
ITEM.description = "A deactivated turret, ready to be switched on."
ITEM.width = 2
ITEM.height = 4
ITEM.iconCam = {
	pos = Vector(-22, 137.25489807129, 39.215686798096),
	ang = Angle(0, -82.35294342041, 0),
	fov = 12.352941176471,
}

ITEM.functions.Deploy = {
	OnRun = function(item)
        if item.entityName then
            local pos = item.entity:GetPos()
            pos:Add(Vector(0, 0, 5)) --prevention for stuck ents inside  world
            local spawned = ents.Create(item.entityName)
            spawned:SetAngles(item.player:GetAngles())
            spawned:SetPos(pos)
            spawned:Spawn()
            return true
        end
		
	end,
	OnCanRun = function(item)
                return IsValid(item.entity)
	end
}