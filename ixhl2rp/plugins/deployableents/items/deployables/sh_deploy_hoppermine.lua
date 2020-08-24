ITEM.name = "Deployable Hopper Mine"
ITEM.model = Model("models/props_combine/combine_mine01.mdl")
ITEM.entityName = "combine_mine"
ITEM.description = "A deactivated hopper mine ready to be switched on."

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