--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

util.AddNetworkString("ixViewdataInitiate")
util.AddNetworkString("ixViewdataAction")

-- Called when a player adds a new row to a data file.
function PLUGIN.AddRow(data)
    if(!data.title) then
        return
    end

    data.record.rows[#data.record.rows+1] = {
        title = data.title,
        points = data.points or 0,
        description = data.description or nil
    }

    return data.record
end

-- Called when a player removes a row from a data file.
function PLUGIN.RemoveRow(data)
    if(!data.title and !data.index) then
        return
    end

    if(data.record.rows[data.index]) then
        data.record.rows[data.index] = nil
    end

    return data.record
end

-- Called when a player edits a row in a data file.
function PLUGIN.EditRow(data)
    if(!data.title and !data.index) then
        return
    end

    local row = data.record.rows[data.index]

    if(row) then
        row = {
            title = data.title,
            points = data.points or 0,
            description = data.description or nil
        }
    end

    return data.record
end

-- Called when a player updates a record variable.
function PLUGIN.UpdateVar(data)
    if(!data.info and !data.var) then
        return
    end

    data.record.vars[data.var] = data.info

    return data.record
end

-- Called when a character needs their data file setup for the first time.
function PLUGIN:CharacterLoaded(character)
    if(!character:GetData("record")) then
        character:SetData("record", {
            rows = {},
            vars = {}
        })
    end
end

-- Called when we need to check a netstream to see if it is valid.
function PLUGIN:SanityCheck(data)
    if(!data.client:IsCombine()) then
        return false
    end

    return true
end

-- Receives the net message from the client and checks if the message they're trying to run is implemented.
net.Receive("ixViewDataAction", function(length, client)
    local message = net.ReadString(16)
    local data = net.ReadTable()

    if(!PLUGIN.message[message] or !data or !data.target) then
        return
    end

    local record = data.target:GetData("record", {})

    -- We could send these as seperate variables, but its easier to have everything under 'data'.
    data.record = record
    data.client = client

    -- Using the message type to run the correct method.
    local newRecord = PLUGIN.message[message](data)

    -- Getting the data from the return method and updating the record.
    if(newRecord) then
        data.target:SetData("record", newRecord)
    end
end)