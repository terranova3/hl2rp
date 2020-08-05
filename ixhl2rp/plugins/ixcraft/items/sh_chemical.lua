
ITEM.name = "Suspicious Chemical"
ITEM.model = Model("models/mark2580/gtav/garage_stuff/plastic_canister.mdl")
ITEM.description = "An unlabled chemical container, it smell of it repulses you. You dont think drinking this is a good idea."
ITEM.width = 1
ITEM.height = 1
ITEM.price = 20
ITEM.category = "Crafting"
ITEM.rarity = "Rare"
ITEM.noBusiness = true

ITEM.functions.Drink = {
	sound = "npc/barnacle/barnacle_digesting1.wav",
	OnRun = function(itemTable)
		local client = itemTable.player
        local rareChance = math.random(1000)
        if (rareChance >= 1000) then
            client:SetRunSpeed(1200)
            client:Notify("You feel like god.")
        else
            client:Kill()
        end
    end
}
