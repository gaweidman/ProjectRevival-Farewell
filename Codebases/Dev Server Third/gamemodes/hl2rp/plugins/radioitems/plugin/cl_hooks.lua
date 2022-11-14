
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

Clockwork.datastream:Hook("radio_frequency", function(data)
	Derma_StringRequest("Frequency", "What would you like to set the frequency to?", data[3], function(text)
		Clockwork.datastream:Start("radio_frequency", {text, data[1], data[2]});
		
		if (!Clockwork.menu:GetOpen()) then
			gui.EnableScreenClicker(false);
		end;
	end);
	
	if (!Clockwork.menu:GetOpen()) then
		gui.EnableScreenClicker(true);
	end;
end);

Clockwork.datastream:Hook("create_item_channel", function(data)
	if (!Clockwork.radio:IsActualChannel(data[2])) then
		local CHANNEL = Clockwork.radio:New();
		CHANNEL.name = data[1];
		CHANNEL.uniqueID = data[2];
		CHANNEL.subChannels = 1;
		CHANNEL.global = false;
		CHANNEL.defaultPriority = 5;

		CHANNEL:Register();
	end;
end);

-- Called when an entity's menu options are needed.
function PLUGIN:GetEntityMenuOptions(entity, options)
	if (entity:GetClass() == "cw_itemradio") then
		if (!entity:IsOff()) then
			options["Turn Off"] = "cw_radioToggle";
		else
			options["Turn On"] = "cw_radioToggle";
		end;
		
		options["Set Frequency"] = function()
			Derma_StringRequest("Frequency", "What would you like to set the frequency to?", frequency, function(text)
				if (IsValid(entity)) then
					Clockwork.entity:ForceMenuOption(entity, "Set Frequency", text);
				end;
			end);
		end;
		
		options["Take"] = "cw_radioTake";
	end;
end;