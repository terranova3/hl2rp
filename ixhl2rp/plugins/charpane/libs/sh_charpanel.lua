--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

ix.charPanel = ix.charPanel or {}
ix.charPanels = ix.charPanels or {
	[0] = {}
}

function ix.charPanel.CreatePanel(id)
    local panel = setmetatable({id = id, slots = {}, vars = {}, receivers = {}}, ix.meta.charPanel)
        ix.charPanels[id] = panel

    return panel
end

function ix.charPanel.CharPanelShow(client)
    if(hook.Run("CharPanelShouldShow", client) != nil) then 
        return hook.Run("CharPanelShouldShow", client)
    else
        return true
    end
end	

function ix.charPanel.Update(client, isOwn)
    local bodygroups = client:GetCharacter():GetData("groups", nil)
    local show = ix.charPanel.CharPanelShow(client)

    netstream.Start(client, "ShowCharacterPanel", show)

    if((show and isOwn == true) or isOwn == false) then
        net.Start("ixCharPanelLoadModel")
            net.WriteString(client:GetModel(), 16)
            net.WriteTable(bodygroups or {})
        net.Send(client)
    end
end

netstream.Hook("CharacterPanelUpdate", function(client, isOwn)
    ix.charPanel.Update(client, isOwn)
end)