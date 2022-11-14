netstream.Hook("EquippedRangefinder", function()
	if (IsValid(ix.gui.rangefinder)) then
		ix.gui.rangefinder:Remove()
	end
	
	vgui.Create("ixRangefinderDisplay"):SetOwner(LocalPlayer())
end)

hook.Add("HUDPaint", "ixSchemaPaintHUD", function()
	if LocalPlayer():GetNetVar("ShowBlackScreen", false) then
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end

	local topText = LocalPlayer():GetNetVar("TopText", false)

	if topText then
		draw.SimpleText(topText, "ixSubTitleFont", ScrW()/2, ScrH() /4, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	if LocalPlayer():GetNetVar("ScreenText", nil) then
		draw.SimpleText(LocalPlayer():GetNetVar("ScreenText"), "ixTitleFont", ScrW()/2, ScrH()/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	if LocalPlayer():GetNetVar("DrawLoading", false) then
		draw.SimpleText("Loading...", "ixSubTitleFont", ScrW()/2, ScrH() - 200, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local client = LocalPlayer()
	local char = client:GetCharacter()
	if ( !IsValid( LocalPlayer() ) ) then return end
end)

hook.Add("PostDrawEffects", "CinematicDraws", function()
	if ix.option.Get("drawCinematicOverlays", false) and LocalPlayer():IsAdmin() then
		if LocalPlayer():GetNetVar("ShowBlackScreen", false) and LocalPlayer():SteamID64() then
			surface.SetDrawColor(0, 0, 0, 255)
			surface.DrawRect(0, 0, ScrW(), ScrH())
		end

		if LocalPlayer():GetNetVar("ScreenText", nil) then
			draw.SimpleText(LocalPlayer():GetNetVar("ScreenText"), "ixTitleFont", ScrW()/2, ScrH()/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end

		if LocalPlayer():GetNetVar("DrawLoading", false) then
			draw.SimpleText("Loading...", "ixSubTitleFont", ScrW()/2, ScrH() - 200, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end
end)

net.Receive("ixNPCMessage", function()
	local speaker = net.ReadEntity()
	local message = net.ReadString()

	local color

	if LocalPlayer():GetEyeTrace().Entity == speaker then
		color = ix.config.Get("chatListenColor")
	else
		color = ix.config.Get("chatColor")
	end

	chat.AddText(color, speaker:GetNetVar("name", "Generic Actor").." says \""..message.."\"")
end)

netstream.Hook("EquippedUnRangefinder", function()
	vgui.Create("ixRangefinderDisplay"):SetOwner(LocalPlayer())
	ix.gui.rangefinder:Remove()
end)

netstream.Hook("OpenViewData", function(target, data)
    vgui.Create("ixViewData"):Populate(target, data)
end)

netstream.Hook("Frequency", function(oldFrequency)
	Derma_StringRequest("Frequency", "What would you like to set the frequency to?", oldFrequency, function(text)
		ix.command.Send("SetFreq", text)
	end)
end)