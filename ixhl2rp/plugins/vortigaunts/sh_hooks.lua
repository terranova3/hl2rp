--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

function PLUGIN:GetPlayerPainSound(client)
	if (client:GetCharacter():IsVortigaunt()) then
		local PainVort = {
			"vo/npc/vortigaunt/vortigese11.wav",
			"vo/npc/vortigaunt/vortigese07.wav",
			"vo/npc/vortigaunt/vortigese03.wav",
		}
		local vort_pain = table.Random(PainVort)
		return vort_pain
	end
end

function PLUGIN:GetPlayerDeathSound(client)
	if (client:GetCharacter():IsVortigaunt()) then
		return false
	end
end

-- Called when the client is checking if it has access to see the character panel
function PLUGIN:CharPanelCanUse(client)
	local faction = client:GetCharacter():GetFaction()

	if(faction == FACTION_VORT or faction == FACTION_BIOTIC) then
		return false
	end
end;

if CLIENT then
	randomVortWords = {"ahglah", "ahhhr", "alla", "allu", "baah", "beh", "bim", "buu", "chaa", "chackt", "churr", "dan", "darr", "dee", "eeya", "ge", "ga", "gaharra",
"gaka", "galih", "gallalam", "gerr", "gog", "gram", "gu", "gunn", "gurrah", "ha", "hallam", "harra", "hen", "hi", "jah", "jurr", "kallah", "keh", "kih",
"kurr", "lalli", "llam", "lih", "ley", "lillmah", "lurh", "mah", "min", "nach", "nahh", "neh", "nohaa", "nuy", "raa", "ruhh", "rum", "saa", "seh", "sennah",
"shaa", "shuu", "surr", "taa", "tan", "tsah", "turr", "uhn", "ula", "vahh", "vech", "veh", "vin", "voo", "vouch", "vurr", "xkah", "xih", "zurr"}
end

ix.chat.Register("Vortigese", {
	format = "%s speaks in Vortigese \"%s\"",
	GetColor = function(self, speaker, text)
		-- If you are looking at the speaker, make it greener to easier identify who is talking.
		if (LocalPlayer():GetEyeTrace().Entity == speaker) then
			return ix.config.Get("chatListenColor")
		end

		-- Otherwise, use the normal chat color.
		return ix.config.Get("chatColor")
	end,
	CanHear = ix.config.Get("chatRange", 280),
	CanSay = function(self, speaker,text)
		if (speaker:GetCharacter():IsVortigaunt()) then
			return true
		else
			speaker:NotifyLocalized("You are not capable of comprehending Vortigese.")
			return false
		end
	end,
	OnChatAdd = function(self,speaker, text, anonymous, info)
		local color = self:GetColor(speaker, text, info)
		local name = anonymous and
				L"someone" or hook.Run("GetCharacterName", speaker, chatType) or
				(IsValid(speaker) and speaker:Name() or "Console")
		
		if (!LocalPlayer():GetCharacter():IsVortigaunt()) then
			local splitedText = string.Split(text, " ")
			local vortigese = {}

			for k, v in pairs(splitedText) do
				local word = table.Random(randomVortWords)
				table.insert( vortigese, word )

			end

			text = table.concat( vortigese, " " )
		end

		chat.AddText(color, string.format(self.format, name, text))
	end,	
	prefix = {"/v", "/vort"},
	description = "Says in vortigaunt language",
	indicator = "chatTalking",
	deadCanChat = false
})

