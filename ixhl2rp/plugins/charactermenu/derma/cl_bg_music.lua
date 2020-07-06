local PANEL = {}

function PANEL:Init()
	if (ix.gui.music) then
		ix.gui.music:Stop()
		ix.gui.music = nil
	end

	self.volume = 0

	local path = "sound/" .. ix.config.Get("music")
	local url = path:match("http[s]?://.+")
	local play = url and sound.PlayURL or sound.PlayFile
	path = url and url or path

	play(path, "noplay", function(channel, error, message)
		if (!IsValid(channel)) then
			return
		end

		channel:SetVolume(self.volume or 0)
		channel:Play()

		ix.gui.music = channel

		self:CreateAnimation(2, {
			index = 10,
			target = {volume = 1},

			Think = function(animation, panel)
				if (IsValid(ix.gui.music)) then
					ix.gui.music:SetVolume(self.volume * 0.5)
				end
			end
		})
	end)
end

-- We don't want the panel to be seen, because we're only using it to play music.
function PANEL:Paint() end

function PANEL:Destroy()
	print("OnRemove")

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
