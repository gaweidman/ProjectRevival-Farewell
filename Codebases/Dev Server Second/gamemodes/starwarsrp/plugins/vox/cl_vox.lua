netstream.Hook("VOXBroadcast", function(string)
	voxBroadcast(string)
end)

netstream.Hook("VOXList", function(data)
	local dframe = vgui.Create("DFrame")
	dframe:SetSize(ScrW()/2, ScrH()/2)
	dframe:Center()
	dframe:MakePopup()
	local label = dframe:Add("DLabel")
	label:Dock(TOP)
	label:SetFont("ChatFont")
	label:SetText("  VOX HELP - Loading will take few second.")
	local html = dframe:Add("DHTML")
	html:Dock(FILL)
	html:OpenURL( "https://dl.dropboxusercontent.com/u/77744658/voxtext.txt" )
end)

local commands = {
	["delay"] = function(time, input, entity)
		return time + tonumber(input)
	end,
}

local sl = string.lower
local path = "vox/"

function voxBroadcast(string, entity, sndDat)
	local time = 0
	local emitEntity = entity or LocalPlayer()
	local table = string.Explode( " ", string )
	for k, v in ipairs( table ) do
		v = sl(v)
		local sndDir = path .. v .. ".wav"
		if (string.Left( v, 1 ) == "!") then
			v = string.sub(v, 2)
			local command = string.Explode( "=", v )
			if commands[command[1]] then
				time = commands[command[1]](time, command[2], entity)
			end
		else
			if (k != 1) then
				time = time + SoundDuration(sndDir) + .1
			end
			timer.Simple( time, function()
				if emitEntity:IsValid() then
					if emitEntity == LocalPlayer() then
						surface.PlaySound(sndDir)
					else
						local sndDat = sndDat or { pitch = 100, level = 70, volume = 1 }
						sound.Play(sndDir, emitEntity:GetPos(), sndDat.level, sndDat.pitch, sndDat.volume)
					end
				end
			end)
		end
	end
end