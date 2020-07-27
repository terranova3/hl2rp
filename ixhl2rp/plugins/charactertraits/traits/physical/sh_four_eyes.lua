--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author.
--]]

TRAIT.name = "Four Eyes";
TRAIT.opposite = "Eagle Eye";
TRAIT.description = "Can you bring it a little closer?";
TRAIT.category = "Physical";
TRAIT.icon = "materials/terranova/ui/traits/foureyes.png";
TRAIT.negative = true;

function TRAIT:CharacterLoaded(character)
    print("Trait:CharacterLoaded")
end

function TRAIT:OnCharacterCreated(character)
    print("Called?")
    local inventory = character:GetInventory()
    local charPanel = character:GetCharPanel()
    local id

    inventory:Add("blackframes", 1)
    
    for k, v in pairs(character:GetInventory()) do
        if(v.uniqueID == "blackframes") then
            id = v.id
            break
        end
    end

    if(id) then
        charPanel:Add(id, nil, "Glasses")
    end
end