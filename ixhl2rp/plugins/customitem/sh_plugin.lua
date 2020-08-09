
local PLUGIN = PLUGIN

PLUGIN.name = "Custom Items"
PLUGIN.author = "Gary Tate"
PLUGIN.description = "Enables staff members to create custom items."
PLUGIN.readme = [[
Enables staff members to create custom items.

Support for this plugin can be found here: https://discord.gg/mntpDMU
]]

ix.command.Add("CreateCustomItem", {
	description = "@cmdCreateCustomItem",
	adminOnly = true,
	arguments = {
		ix.type.string,
		ix.type.string,
		ix.type.string,
		bit.bor(ix.type.text, ix.type.optional)
	},
	OnRun = function(self, client, name, model, description, tooltip)
		client:GetCharacter():GetInventory():Add("customitem", 1, {
			name = name,
			model = model,
			description = description,
			tip = tooltip
		})

		client:Notify(string.format("You have created a custom item with the name '%s'.", name))
	end
})
