local PANEL = {}

local FADE_TIME = 5
local VOLUME = ix.config.Get("musicvolume", 0.25)

function PANEL:Init()
	if (ix.menuMusic) then
		ix.menuMusic:Stop()
		ix.menuMusic = nil
		timer.Remove("ixMusicFader")
	end

	self:SetVisible(false)

	ix.menuMusicIsLocal = false
	timer.Remove("ixMusicFader")

	local source = ix.config.Get("music", "")
	if (not source:find("%S")) then return end

	if (source:find("http")) then
		sound.PlayURL(source, "noplay", function(music, errorID, fault)
			if (music) then
				music:SetVolume(VOLUME)
				ix.menuMusic = music
				ix.menuMusic:Play()
			else
				MsgC(Color(255, 50, 50), errorID.." ")
				MsgC(color_white, fault.."\n")
			end
		end)
	else
		ix.menuMusicIsLocal = true
		ix.menuMusic = CreateSound(LocalPlayer(), source)
		ix.menuMusic:PlayEx(VOLUME, 100)
	end
end

function PANEL:OnRemove()
	local music = ix.menuMusic
	if (not music) then return end

	local fraction = 1
	local start, finish = RealTime(), RealTime() + FADE_TIME

	timer.Create("ixMusicFader", 0.1, 0, function()
		if (ix.menuMusic) then
			fraction = 1 - math.TimeFraction(start, finish, RealTime())
			if (music.ChangeVolume) then
				music:ChangeVolume(fraction * VOLUME, 0.1)
			elseif (music.SetVolume) then
				music:SetVolume(fraction * VOLUME)
			end

			if (fraction <= 0) then
				music:Stop()
				ix.menuMusic = nil

				timer.Remove("ixMusicFader")
			end
		else
			timer.Remove("ixMusicFader")
		end
	end)
end

vgui.Register("ixCharBGMusic", PANEL, "DPanel")
