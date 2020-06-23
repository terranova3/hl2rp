--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

util.AddNetworkString("PlayerNotify");

function ix.notify.SendMessage(client, data)
    net.Start("PlayerNotify");
        net.WriteTable(data);
    net.Send(client)
end;