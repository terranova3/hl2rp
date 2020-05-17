blacklisted = {
    ["weapon_physgun"] = true,
    ["gmod_tool"] = true,
    ["ix_hands"] = true,
    ["ix_keys"] = true,
    ["weapon_physcannon"] = true,
}



-- just a callback (taken from persistent_corpses)
function PLUGIN:RemoveEquippableItem(client, item)
		if (item.Unequip) then
			item:Unequip(client)
		elseif (item.RemoveOutfit) then
			item:RemoveOutfit(client)
		elseif (item.RemovePart) then
			item:RemovePart(client)
		end
	end

hook.Add("DoPlayerDeath", "hlwOnDeathDrop", function (ply)

    local character = ply:GetCharacter()
    local charInventory = character:GetInventory()

    -- drop the currently equipped weapon
    if(ix.config.Get("dropPrimaryWeapon", true) and ix.config.Get("dropLoadout", false)) then
        print("THIS FEATURE IS NOT SUPPORTED YET!") -- we can call item instead of ply:dropweapon when items are a thing
    end

    -- drop the players loadout
    if(ix.config.Get("dropLoadout", true)) then
        for k, v in pairs( ply:GetWeapons() ) do
            if(blacklisted[v:GetClass()]) then
                continue
            end
            ply:DropWeapon(v)
        end
    end



    local inventory = ix.item.CreateInv(width, height, os.time())
		inventory.noSave = true

    -- delete everything from the players inventory and spawn a copy in front of them
    if(ix.config.Get("dropInventory", true)) then
        for _, slot in pairs(charInventory.slots) do     
            for _, item in pairs(slot) do
                if(item:GetData("equip")) then
                    self:RemoveEquippableItem(ply, item)
                end
                item:Spawn(ply:GetPos())
                item:Transfer(inventory:GetID(), item.gridX, item.gridY)
            end
        end
    end