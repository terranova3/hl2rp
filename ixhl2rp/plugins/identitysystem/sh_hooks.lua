netstream.Hook("SubmitNewCID", function(ply, data)
    if ply:IsCombine() then
        local char = ply:GetCharacter()
        local inv = char:GetInventory()
        local Timestamp = os.time()
        local TimeString = os.date("%H:%M:%S - %d/%m/%Y", Timestamp)

        local data2 = {
            ["citizen_name"] = data[1],
            ["cid"] = math.random(10000, 99999),
            ["issue_date"] = TimeString,
            ["officer"] = ply:Name()
        }

        inv:Add("cid", 1, data2)
        ply:EmitSound("buttons/button14.wav", 100, 25)
        ply:ForceSequence("harassfront1")
        ix.log.AddRaw(ply:Name() .. " has created a new CID with the name " .. data[1])
    end
end)