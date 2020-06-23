--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

ix.command.Add("SetSociostatus", {
    permission = "Set sociostatus",
	arguments = {
		ix.type.string
	},
    OnRun = function(self, client, text)
        local character = client:GetCharacter();

        if(PLUGIN:GetAccessLevel(character) >= self.accessLevel) then
            if(PLUGIN:IsMetropolice(character)) then
                local tryingFor = string.upper(text);

                if (not PLUGIN.sociostatusColors[tryingFor]) then
                    client:Notify(string.format("%s is not a valid sociostatus!", text));
                else
                    local players = {};
    
                    local pitches = {
                        BLUE = 95,
                        YELLOW = 90,
                        RED = 85,
                        BLACK = 80
                    };
    
                    local pitch = pitches[tryingFor] or 100;
                
                    for k, v in ipairs(player.GetAll()) do
                        if (v:IsCombine()) then
                            players[#players + 1] = v;
    
                            timer.Simple(k / 4, function()
                                if (IsValid(v)) then
                                    v:EmitSound("npc/roller/code2.wav", 75, pitch);
                                end;
                            end);
                        end;
                    end;
    
                    PLUGIN.socioStatus = tryingFor;

                    Schema:AddCombineDisplayMessage("ALERT! Sociostatus updated to " .. tryingFor .. "!", PLUGIN.sociostatusColors[tryingFor])
                    netstream.Start(players, "RecalculateHUDObjectives", tryingFor)
                end;
            else
                client:Notify(string.format("You are not a part of the '%s' faction.", target:GetFaction()));
            end;
        else
            client:Notify(string.format("This command requires an access level of %s. Your access level is %s.", self.accessLevel, PLUGIN:GetAccessLevel(client:GetCharacter())));
        end;
	end;
})