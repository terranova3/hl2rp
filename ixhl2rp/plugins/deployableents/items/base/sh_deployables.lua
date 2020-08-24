ITEM.name = "Deploy Base"
ITEM.model = Model("models/props_junk/cardboard_box001a.mdl")
ITEM.category = "Deployables"
ITEM.entityName = "npc_turret_floor"
ITEM.description = "Deploy It"
ITEM.width = 2
ITEM.height = 2
ITEM.noBusiness = true
ITEM.price = 50

ITEM.functions.Deploy = {
	OnRun = function(item)
        if item.entityName then
            local pos = item.entity:GetPos()
            pos:Add(Vector(0, 0, 50)) --prevention for stuck ents inside  world
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