local PLUGIN = PLUGIN


ix.config.Add("dropPrimaryWeapon", true, "Drops the equipped weapon upon death.", nil, {
    category = "Death Drops"
})

ix.config.Add("dropLoadout", false, "Drops the players inventory upon death.", nil, {
    category = "Death Drops"
})

ix.config.Add("dropInventory", false, "Drops the players inventory upon death.", nil,{
    category = "Death Drops"
})

ix.config.Add("dropPlayerRequisitionPercentage", 5, "Drops a % of the player's money when they die.", nil, {
    category = "Death Drops",
    data = { min = 0, max = 100 }
})