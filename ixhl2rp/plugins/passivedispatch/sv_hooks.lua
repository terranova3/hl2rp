local PLUGIN = PLUGIN;

function PLUGIN:EmitRandomChatter(client)
	local randomSounds = {
		"npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav",
		"npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav",
		"npc/overwatch/cityvoice/fprison_missionfailurereminder.wav"
	};

	
	local randomSound = randomSounds[ math.random(1, #randomSounds) ];
		if(randomSound == "npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav") then
			ix.chat.Send(client, "dispatch", "Citizen reminder. Inaction is conspiracy. Report counter behaviour to a Civil Protection team immediately.");
		end
		if(randomSound == "npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav") then
			ix.chat.Send(client, "dispatch","Citizen notice. Failure to co-operate will result in permanent off-world relocation");
		end
		if(randomSound == "npc/overwatch/cityvoice/fprison_missionfailurereminder.wav") then
			ix.chat.Send(client, "dispatch", "Attention ground units. Mission failure will result in permanent off-world assignment. Code reminder: SACRIFICE, COAGULATE, PLAN.");
		end
	client:EmitSound( randomSound, 60)
end;

-- Called each tick.
function PLUGIN:Tick()
	for k, v in ipairs(player.GetAll() ) do
		
			local curTime = CurTime();
			
			if (!self.nextChatterEmit) then
				self.nextChatterEmit = curTime + math.random(120, 150);
			end;
			
			if ( (curTime >= self.nextChatterEmit) ) then
				self.nextChatterEmit = nil;
				
				PLUGIN:EmitRandomChatter(v);
			end;

	end;
end;