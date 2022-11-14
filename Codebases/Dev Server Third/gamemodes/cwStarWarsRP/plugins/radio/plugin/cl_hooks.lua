
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Called when the top screen HUD should be painted.
function PLUGIN:HUDPaintTopScreen(info)
	if (!Clockwork.Client:Alive()) then
		return;
	end;
	
	local blackFadeAlpha = Clockwork.kernel:GetBlackFadeAlpha();
	local colorWhite = Clockwork.option:GetColor("white");
	local height = draw.GetFontHeight("BudgetLabel");
	local listeningOn = {};
	-- List all listening channels
	if (self.listenChannels and table.Count(self.listenChannels) > 0) then
		for channel, channelNumber in pairs(self.listenChannels) do
			local channelTable = Clockwork.radio:FindByID(channel)
			if (channelTable) then
				-- Check if a channel number has to be added
				if (channelTable.subChannels > 1) then
					listeningOn[#listeningOn + 1] = channelTable.name.." (#"..channelNumber..")";
				else
					listeningOn[#listeningOn + 1] = channelTable.name;
				end;
			end;
		end;
		table.sort(listeningOn);
		-- Remove the last ', '
		listeningOn = table.concat(listeningOn, ", ");
	else
		listeningOn = Clockwork.radio.CHANNEL_NONE;
	end;
	-- Set transmittingOn channel
	local transmittingOn = Clockwork.Client:GetSharedVar("radio_transmit") or Clockwork.radio.CHANNEL_NONE;
	local channelTable = Clockwork.radio:FindByID(transmittingOn)
	-- If channel is not global, not none and has more than one subchannel, add in a channel number
	if (channelTable) then
		if (channelTable.global) then
			if (table.Count(channelTable.targetChannels) == 1) then
				local targetChannel = table.GetFirstKey(channelTable.targetChannels);
				transmittingOn = Clockwork.radio:FormatRadioChannel(targetChannel, channelTable.targetChannels[targetChannel]);
			end;
		elseif (channelTable.subChannels > 1) then
			if (self.listenChannels and self.listenChannels[transmittingOn]) then
				transmittingOn = channelTable.name.." (#"..self.listenChannels[transmittingOn]..")";
			end;
		else
			transmittingOn = channelTable.name;
		end;
	end;
	-- Set draw color
	local textColor = Color(colorWhite.r, colorWhite.g, colorWhite.b, 255 - blackFadeAlpha);
	-- Draw text
	if (listeningOn != "none" or transmittingOn != "none") then
		draw.SimpleText("Radio channels: "..listeningOn, "BudgetLabel", info.x, info.y, textColor);
		draw.SimpleText("Transmitting on: "..transmittingOn, "BudgetLabel", info.x, info.y + height, colorWhite);	
		info.y = info.y + (height * 2);
	end;
end;

-- Receive channel list
Clockwork.datastream:Hook("listen_channels", function(data)
	PLUGIN.listenChannels = data[1] or {};
	-- Reset quickmenu category
	Clockwork.quickmenu.categories["Channels"] = nil;
	-- Add regular channels
	for channel, channelNumber in pairs(PLUGIN.listenChannels) do
		-- Check how many subchannels there are
		local channelTable = Clockwork.radio:FindByID(channel)
		if (channelTable) then
			if (channelTable.subChannels > 1) then
				-- If more than one, add each subchannel
				local optionTable = {};
				for i = 1, channelTable.subChannels do
					optionTable[#optionTable + 1] = {"subchannel #"..i, channelTable.uniqueID.." "..tostring(i)};
				end;
				-- Add the menu option
				Clockwork.quickmenu:AddCommand(channelTable.name, "Channels", "SetChannel", optionTable);
			else
				-- Else add menu option with only one channel
				Clockwork.quickmenu:AddCommand(channelTable.name, "Channels", "SetChannel", {{channelTable.name, channelTable.uniqueID}});
			end;
		end;
	end;
	-- Add none/global
	local otherTable = {Clockwork.radio.CHANNEL_NONE};
	-- Check for global channels
	if (data[2]) then
		-- Add global channels
		for k, v in pairs(data[2]) do
			local channelTable = Clockwork.radio:FindByID(k);

			if (channelTable) then
				otherTable[#otherTable + 1] = {channelTable.name, channelTable.uniqueID};
			end;
		end;
	end;
	Clockwork.quickmenu:AddCommand("other", "Channels", "SetChannel", otherTable);
end);

Clockwork.datastream:Hook("set_channel", function(data)
	if (Clockwork.radio:IsActualChannel(data[1])) then
		PLUGIN.listenChannels[data[1]] = data[2];
	end;
end);

-- Gets the listen chanels in case the plugin is reloaded
Clockwork.datastream:Start("listen_channels", {true});

-- Update old radio command
local radioCommandUpdated = false;
function PLUGIN:Think()
	if (!radioCommandUpdated) then
		self:UpdateRadioCommand();
		radioCommandUpdated = true;
	end;
end;