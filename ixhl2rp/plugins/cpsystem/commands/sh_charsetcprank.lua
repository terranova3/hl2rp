--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN;

ix.command.Add("CharSetCPRank",  {
	description = "Sets the rank of a civil protection unit.";
	arguments = {
		ix.type.character,
		bit.bor{ix.type.string, ix.type.optional}
	},
	OnCheckAccess = function(self, client)
		return client:IsDispatch();
	end,
	OnRun = function(self, client, target, rank)
		local ranks = Schema.ranks.stored;
		local name = target:GetName();
		local newRank;

		if(target:GetFaction() == "Metropolice Force") then
			if(rank) then
				if(!table.KeyFromValue(ranks, string.upper(rank))) then
					return "Invalid rank input. That rank might not exist.";
				end;
			else
				if(string.find(name, ranks[#ranks])) then
					return "That character already is the highest rank possible.";
				end;

				for k, v in ipairs(ranks) do
					if(string.find(name, v)) then
						newRank = next(ranks, k);
						break;
					end;
				end;
			end;

			if(newRank) then
				newRank = ranks[newRank];

				target:SetData("cpRank", newRank);
				target:SetName(PLUGIN:GetCpName(target));

				for _, v in ipairs(player.GetAll()) do
                    if (self:OnCheckAccess(v) or v == target:GetPlayer()) then
                        v:NotifyLocalized("You have been promoted to %s!", newRank);
                    end
                end
			else
				return "Invalid rank input. That rank might not exist.";
			end;
		else
			return "That player is not a part of the Metropolice Force faction.";
		end;
	end;
})
