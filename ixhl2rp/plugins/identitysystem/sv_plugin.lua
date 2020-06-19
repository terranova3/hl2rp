netstream.Hook("updatecheckboxes", function(ply, data)
	local item = ix.item.instances[data[1]]
	local cb1 = data[2]
	local cb2 = data[3]
	local cb3 = data[4]

	local tbl = item:GetData("checkboxes", {})
	tbl["wanted"] = cb1
	tbl["survey"] = cb2
	if cb3 then
		item:SetData("elevated", true)
	else
		item:SetData("elevated", false)
	end
	item:SetData("checkboxes", tbl)
end)