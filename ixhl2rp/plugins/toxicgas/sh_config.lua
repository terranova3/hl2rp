
-- Toxic Gas Tick Timer
ix.config.Add("gasDmgTick", 5, "The time between each tick of damage.", nil, {
	category = "Toxic Gas",
	data = { min = 1, max = 100 }
})

-- Toxic Gas Damage
ix.config.Add("gasDmg", 1, "The total amount of damage per tick", nil, {
	category = "Toxic Gas",
	data = { min = 0, max = 100 }
})

-- Toxic Gas Damage
ix.config.Add("gasNotifyTime", 45, "The total amount of time between each gas notification.", nil, {
	category = "Toxic Gas",
	data = { min = 0, max = 600 }
})

-- Toxic Gas Run Slow
ix.config.Add("gasRunSlow", 0.5, "The multiplier for run speed while affected by gas", nil, {
	category = "Toxic Gas",
	data = {min = 0.01, max = 1, decimals = 2},
})

-- Toxic Gas Walk Slow
ix.config.Add("gasWalkSlow", 0.6, "The multiplier for walk speed while affected by gas", nil, {
	category = "Toxic Gas",
	data = {min = 0.01, max = 1, decimals = 2},
})
