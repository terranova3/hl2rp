--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

PROFESSION.name = "Weaponry"
PROFESSION.description = "Placeholder description, this needs to be set."
PROFESSION.image = "terranova/ui/crafting/weaponry.png"
PROFESSION.icon = "terranova/ui/crafting/icons/weaponry.png"
PROFESSION.color = Color(202, 81, 81, 255)

-- This is the hook we can use to implement custom mastery effects.
function PROFESSION:GetMasteryEffects()
end


if(CLIENT) then

    -- We can use this to add any special derma to the crafting menu without editing it.
    function PROFESSION:GetDerma()

    end
end