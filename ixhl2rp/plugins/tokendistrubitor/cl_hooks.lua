
netstream.Hook("ixTokenDistributorRequestPnl", function(class, entity)
	local panel = vgui.Create("ixTokenDistrMngPnl")
	panel:SetEntity(entity)
	if class == "cwu" then 
		panel:InitCWU()
	elseif class == "admin" then 
		panel:InitAdmin()
	else 
		panel:Close() 
	end
end)
