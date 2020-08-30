local PANEL = {}

function PANEL:Init()
	if (ix.gui.music) then
		ix.gui.music:Stop()
		ix.gui.music = nil
	end

	self.volume = 0

	if(ix.config.Get("music", "") != "") then
		local path = "sound/" .. ix.config.Get("music")
		local url = path:match("http[s]?://.+")
		local play = url and sound.PlayURL or sound.PlayFile
		path = url and url or path

		play(path, "noplay", function(channel, error, message)
			if (!IsValid(channel)) then
				return
			end

			channel:SetVolume(0.25)
			channel:Play()

			ix.gui.music = channel
		end)
	end
end

-- We don't want the panel to be seen, because we're only using it to play music.
function PANEL:Paint() end

function PANEL:Destroy()
	self:CreateAnimation(1, {
		index = 10,
		target = {volume = 0},

		Think = function(animation, panel)
			if (IsValid(ix.gui.music)) then
				ix.gui.music:SetVolume(self.volume * 0.5)
			end
		end,

		OnComplete = function(animation, panel)
			if (IsValid(ix.gui.music)) then
				ix.gui.music:Stop()
				ix.gui.music = nil
				self:Remove()
			end
		end
	})
end

vgui.Register("ixCharBGMusic", PANEL, "DPanel")
