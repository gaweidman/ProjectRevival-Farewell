
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.config:AddToSystem("No Noclip Eavesdrop", "no_noclip_eavesdrop", "Disables eavesdropping from players in observer.", 0, 1, 0);

Clockwork.chatBox:RegisterClass("radio_transmit", "ic", function(info)
	info.channel = info.data.channel;
	if (table.Count(info.data.transmitTable) == 1) then
		local targetChannel = table.GetFirstKey(info.data.transmitTable);
		local channelNumber = info.data.transmitTable[targetChannel]

		if (type(channelNumber) != "boolean") then
			info.channel = Clockwork.radio:FormatRadioChannel(targetChannel, channelNumber);
		end;
	end;

	info.sound = info.data.sound;
	info.useSound = true;

	Clockwork.plugin:Call("AdjustRadioTransmit", info);

	Clockwork.chatBox:Add(info.filtered, nil, info.data.color, info.name.." "..info.data.typeText.." on "..info.channel..": \""..info.text.."\"");
	if (info.useSound) then
		surface.PlaySound(info.sound);
	end;
end);

Clockwork.chatBox:RegisterClass("radio_eavesdrop", "ic", function(info)
	if (info.shouldHear) then
		local color = Color(255, 255, 175, 255);
		
		if (info.focusedOn) then
			color = Color(175, 255, 175, 255);
		end;
		
		if (info.data.typeText == "radios") then
			info.data.typeText = "says";
		end;

		info.sound = info.data.sound;
		info.useSound = false;

		Clockwork.plugin:Call("AdjustRadioEavesdrop", info);

		Clockwork.chatBox:Add(info.filtered, nil, color, info.name.." "..info.data.typeText.." on radio: \""..info.text.."\"");
		if (info.useSound) then
			surface.PlaySound(info.sound);
		end;
	end;
end);