--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ITEM.name = "Business Application"
ITEM.description = "Contains a compact form with various questions and answers, for creating a business. Has a small union Ministry of Workforce logo at the top right."
ITEM.model = "models/props_office/paperfolder01.mdl"
ITEM.category = "Miscellaneous";
ITEM.functions.Edit = {
    icon = "icon16/book_edit.png",
	OnRun = function(itemTable)
        local client = itemTable.player
		
		netstream.Start(client, "EditApplication", itemTable)
		
        return false
	end
}

if(CLIENT) then
	do
		netstream.Hook("EditApplication", itemTable, function()
			ix.gui.businessApplication = vgui.Create("ixBusinessApplication")
			ix.gui.businessApplication:Build(itemTable)
		end)
	end
end
