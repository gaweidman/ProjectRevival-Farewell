
local Clockwork = Clockwork;
local PLUGIN = PLUGIN;

Clockwork.radio = Clockwork.kernel:NewLibrary("Radio");
Clockwork.radio.channels = Clockwork.radio.channels or {};
Clockwork.radio.CHANNEL_NONE = "none";
Clockwork.radio.sayTypes = Clockwork.radio.sayTypes or {};

--[[
	Begin defining the radio channel class base for other radio channel's to inherit from.
--]]

--[[ Set the __index meta function of the class. --]]
local CLASS_TABLE = {__index = CLASS_TABLE};

CLASS_TABLE.name = "Radio Channel Base"; -- Display name
CLASS_TABLE.uniqueID = "radio_channel_base"; -- Internal name
CLASS_TABLE.subChannels = 1; -- Amount of sub-channels (only needed if global != true)
CLASS_TABLE.global = false; -- Does it transmit over all subchannels of a channel?
CLASS_TABLE.targetChannels = {}; -- Target channel if (global == true)
CLASS_TABLE.defaultPriority = 0; -- When a player's channels are reset, the one with the highest priority will be his default

-- Called when the channel is converted to a string.
function CLASS_TABLE:__tostring()
	return "CHANNEL["..self.name.."]";
end;

-- A function to override a channel's base data.
function CLASS_TABLE:Override(varName, value)
	self[varName] = value;
end;

-- A function to add target Channels
function CLASS_TABLE:AddTargetChannel(channel, range)
	if (channel) then
		if (!range) then
			self.targetChannels[channel] = "all";
		elseif (type(range) == "number") then
			self.targetChannels[channel] = {1, math.min(math.Round(range), 1)};
		elseif (type(range) == "table") then
			self.targetChannels[channel] = {math.min(math.Round(range[1]), 1), math.min(math.Round(range[1]), 1)};
		end;
	end;
end;

-- A function to register a new channel.
function CLASS_TABLE:Register()
	return Clockwork.radio:Register(self);
end;

--[[
	End defining the base channel class.
	Begin defining the channel utility functions.
--]]

-- A function to get all channels.
function Clockwork.radio:GetAll()
	return self.channels;
end;

-- A function to get a new channel.
function Clockwork.radio:New()
	local object = Clockwork.kernel:NewMetaTable(CLASS_TABLE);
	return object;
end;

-- A function to register a new channel.
function Clockwork.radio:Register(channel)
	channel.uniqueID = string.lower(string.gsub(channel.uniqueID or string.gsub(channel.name, "%s", "_"), "['%.]", ""));

	if (!channel.color) then
		channel.color = Color(42, 179, 0, 255);
	end;

	channel.subChannels = math.max(math.Round(channel.subChannels), 1);

	self.channels[channel.uniqueID] = channel;

	if (self.Initialized) then
		self:InitializeChannel(channel);
	end;
end;

-- A function to get a channel by its name.
function Clockwork.radio:FindByID(channelID)
	if (channelID and channelID != 0 and type(channelID) != "boolean"
		and channelID != self.CHANNEL_NONE and channelID != "") then
		local lowerName = string.lower(channelID);
		local channel = self.channels[lowerName];

		if (channel) then
			return channel;
		else
			for k, chnl in pairs(self.channels) do
				local channelName = string.lower(chnl.name);
				
				if (string.find(channelName, lowerName)
				and (!channel or string.len(channelName) < string.len(channel.name))) then
					channel = chnl;
				end;
			end;

			return channel;
		end;
	end;
end;

-- Returns if a channel exists
-- If bNotNone is true, it will exclude CHANNEL_NONE
function Clockwork.radio:IsValidChannel(channelID, bNotNone)
	return self.channels[channelID] or (channelID == self.CHANNEL_NONE and !bNotNone);
end;

-- Returns if a channel is an actual channel (it exists and is not a global one)
function Clockwork.radio:IsActualChannel(channelID)
	local channel = self:FindByID(channelID)
	if (channel and !channel.global) then
		return true;
	else
		return false;
	end;
end;

-- Returns if a channel has subchannels, and how many
function Clockwork.radio:HasSubChannels(channelID)
	local channel = self:FindByID(channelID);
	if (channel and channel.subChannels and channel.subChannels > 1) then
		return true, channel.subChannels;
	else
		return false, 1;
	end;
end;

-- Returns if a channel is a global channel (it exists and is global)
function Clockwork.radio:IsGlobalChannel(channelID)
	local channel = self:FindByID(channelID)
	if (channel and channel.global) then
		return true;
	else
		return false;
	end;
end;

-- Called when channels should be initialized
function Clockwork.radio:Initialize()
	Clockwork.plugin:Call("RegisterRadioChannels");
	
	self.Initialized = true;
	local channels = self:GetAll();

	for k, channel in pairs(channels) do
		self:InitializeChannel(channel);
	end;
end;

function Clockwork.radio:InitializeChannel(channel)
	-- Setup chann
	if (channel.OnSetup) then 
		channel:OnSetup(); 
	end;
	-- Ensure a valid range if the channel is global
	if (channel.global) then
		local targetChannels = channel.targetChannels;
		for targetChannel, range in pairs(targetChannels) do
			local chnl = self:FindByID(targetChannel)
			-- Check if the channel exists
			if (!chnl or chnl.global) then targetChannels[targetChannel] = nil; end;
			-- Ensure the range is valid
			if (range != "all") then
				range[1] = math.max(range[1], 1);
				range[2] = math.min(range[2], chnl.subChannels);
			end;
		end;

		channel.targetChannels = targetChannels;
	end;

	Clockwork.plugin:Call("ClockworkRadioChannelInitialized", channel);
end;

if (SERVER) then
	function Clockwork.radio:HasPlayerChannel(player, channelID, channelNumber)
		local channel = self:FindByID(channelID);

		if (channel) then
			if (channel.global) then
				return player.globalChannels[channel.uniqueID];
			else
				if (!channelNumber or type(channelNumber) == "boolean" or channelNumber == "all") then
					return player.listenChannels[channel.uniqueID];
				elseif (type(channelNumber) == "number") then
					return player.listenChannels[channel.uniqueID] == channelNumber;
				elseif (type(channelNumber) == "table") then
					return (player.listenChannels[channel.uniqueID] >= channelNumber[1]
						and player.listenChannels[channel.uniqueID] <= channelNumber[2]);
				end;
			end;
		end;
	end;

	-- Resets (or sets) a player's channels
	function Clockwork.radio:SetPlayerChannels(player)
		player.listenChannels = {};
		player.globalChannels = {};
		if (!player.tempChannels) then
			player.tempChannels = {};
		end;
		
		local success;
		-- Add faction channels
		local faction = Clockwork.player:GetFactionTable(player);
		if (faction and faction.listenChannels) then
			for channelID, channelNumber in pairs(faction.listenChannels) do
				success = self:AddChannelToPlayer(player, channelID, channelNumber);
				if (!success) then
					ErrorNoHalt("[Radio] Attempted to add unexisting faction channel "..channelID.." to player ("..player:GetFaction()..").");
				end;
			end;
		end;
		-- Add class channels
		local class = Clockwork.class:FindByID(player:Team());
		if (class and class.listenChannels) then
			for channelID, channelNumber in pairs(class.listenChannels) do
				success = self:AddChannelToPlayer(player, channelID, channelNumber);
				if (!success) then
					ErrorNoHalt("[Radio] Attempted to add unexisting class channel "..channelID.." to player ("..player:Team()..").");
				end;
			end;
		end;
		-- Add personal channels
		local listenChannels = player:GetCharacterData("listen_channels", {});
		for channelID, channelNumber in pairs(listenChannels) do
			success = self:AddChannelToPlayer(player, channelID, channelNumber);
			if (!success) then
				ErrorNoHalt("[Radio] Attempted to add unexisting listen channel "..channelID.." to player (listenChannels).");
			end;
		end;
		-- Add temporary channels
		for channelID, channelNumber in pairs(player.tempChannels) do
			success = self:AddChannelToPlayer(player, channelID, channelNumber);
			if (!success) then
				ErrorNoHalt("[Radio] Attempted to add unexisting temporary channel "..channelID.." to player (tempChannels).");
			end;
		end;

		Clockwork.plugin:Call("PlayerAdjustChannels", player, player.listenChannels, player.globalChannels);
								
		Clockwork.datastream:Start(player, "listen_channels", {player.listenChannels, player.globalChannels});

		if (table.Count(player.listenChannels) > 0) then
			local currentChannel = player:GetSharedVar("radio_transmit");
			if (currentChannel == "" or currentChannel == "none" or !self:HasPlayerChannel(player, currentChannel)) then
				self:ResetTransmitChannel(player);
			end;
		else
			player:SetSharedVar("radio_transmit", self.CHANNEL_NONE);
		end;
	end;

	-- Resets the current channel of a player
	function Clockwork.radio:ResetTransmitChannel(player)
		local channel = nil;
		for chnlID, v in pairs(player.listenChannels) do
			local chnl = self:FindByID(chnlID);
			if (chnl and (!channel or channel.defaultPriority < chnl.defaultPriority)) then
				channel = chnl;
			end;
		end;
		if (!channel) then
			for chnlID, v in pairs(player.globalChannels) do
				local chnl = self:FindByID(chnl);
				if (chnl and (!channel) or channel.defaultPriority < chnl.defaultPriority) then
					channel = chnl;
				end;
			end;
		end;

		if (channel) then
			player:SetSharedVar("radio_transmit", channel.uniqueID);
		else
			player:SetSharedVar("radio_transmit", self.CHANNEL_NONE);
		end;
	end;

	-- Gives a player access to a channel
	function Clockwork.radio:AddChannelToPlayer(player, channelID, channelNumber)
		local channel = self:FindByID(channelID);
		if (channel) then		
			if (!channel.global) then
				if (!channelNumber) then
					channelNumber = 1;
				end;
				player.listenChannels[channel.uniqueID] = math.Clamp(math.floor(channelNumber), 1, channel.subChannels);
			else
				player.globalChannels[channel.uniqueID] = 1;
			end;
			return true;
		else
			return false;
		end;
	end;

	-- Removes a channel from a player
	-- Returns true if the player was on the channel, false if the player wasn't (nil if the channel wasn't found)
	-- If the player was transmitting on the given channel, his transmit channel will be reset
	function Clockwork.radio:RemoveChannelFromPlayer(player, channelID)
		local channel = self:FindByID(channelID);
		if (channel) then
			local ret = nil;
			if (!channel.global) then
				ret = table.remove(player.listenChannels, channel.uniqueID);
			else
				ret = table.remove(player.globalChannels, channel.uniqueID);
			end;

			if (ret) then
				if (channel.uniqueID == player:GetSharedVar("radio_transmit")) then
					self:ResetTransmitChannel(player);
				end;
				return true;
			else
				return false;
			end;
		end;
	end;

	--[[
		A function to register a say type.
		@range: The eavesdrop range
		@type: The text used for the chat (<playerName> ..type.. in on <channelName>)
	]]
	function Clockwork.radio:RegisterSayType(sayType, range, typetext)
		if (range and type(range) == "number" and typetext and type(typeText) == "string") then
			self.sayTypes[sayType] = {range, typetext};
		end;
	end;

	--[[=
		A function to say something on radio.
		@player: the player saying the message
		@text: text to be said on radio
		@data: additional data (table)
			@data.channelID: use the given channel instead of the player's channel
			@data.color: use the given color in chat
			@data.bNoEavesdrop: prevents anyone from eavesdropping the message
			@data.sayType: the saytype to be used
		@bNoErrors: if true, no error messages will be send to the player
	]]
	function Clockwork.radio:SayRadio(player, text, data, bNoErrors)
		-- Check if text was specified
		if (text == "") then
			if (!bNoErrors) then	
				Clockwork.player:Notify(player, "You did not specify enough text!");
			end;
			return false;
		end;

		-- Check if any data was given, otherwise make an empty data table
		if (!data or type(data) != "table") then
			data = {};
		end;

		-- Get the channelTable
		local channelTable = nil;
		if (!data.channelID) then
			channelTable = self:FindByID(player:GetSharedVar("radio_transmit"));
			if (!channelTable) then
				if (!bNoErrors) then
					Clockwork.player:Notify(player, "You are not on a valid channel!");
				end;
				return false;
			end;
		else
			channelTable = self:FindByID(data.channelID);
			if (!channelTable) then
				if (!bNoErrors) then
					Clockwork.player:Notify(player, data.channelID.." is not a valid channel!");
				end;
				return false;
			end;
		end;

		--[[
			Begin setting up the data table
		]]

		-- Add channel info
		data.channelID = channelTable.uniqueID;
		data.channel = channelTable.name; -- Display name for in chat

		-- Add message color if none is set already
		if (!data.color) then
			data.color = channelTable.color;
		end;

		if (channelTable.sound) then
			data.sound = channelTable.sound;
		else
			data.sound = "npc/overwatch/radiovoice/on3.wav";
		end;

		-- Set the channel and channel number
		data.transmitTable = {};
		data.global = false;
		-- Check if it's a global channel
		if (channelTable.global) then
			data.global = true;
			data.transmitTable = channelTable.targetChannels;
		-- Check if a channelNumber has to be set
		else
			if (channelTable.subChannels > 1) then
				data.transmitTable[channelTable.uniqueID] = player.listenChannels[channelTable.uniqueID];
			else
				data.transmitTable[channelTable.uniqueID] = true;
			end;
		end;

		-- Set the sayType and message range
		data.range = Clockwork.config:Get("talk_radius"):Get();
		data.typeText = "radios";
		if (self.sayTypes[data.sayType]) then
			data.range = self.sayTypes[data.sayType][1];
			data.typeText = self.sayTypes[data.sayType][2];
		elseif (data.sayType == "yell") then
			data.range = data.range * 1.5;
			data.typeText = "yells";
		elseif (data.sayType == "whisper") then
			data.range = data.range / 4;
			data.typeText = "whispers";
		end;

		-- Should we not allow eavesdropping?
		data.bNoEavesdrop = data.bNoEavesdrop or Clockwork.plugin:Call("NoEavesdrop", player, channelTable, data);

		--[[
			End setting up data table
			Setup info table
		]]

		local info = {
			player = player,
			text = text,
			data = data,
			multiplier = 1,
			bShouldSend = true
		};

		Clockwork.plugin:Call("AdjustRadioTransmitInfo", info);

		--[[
			End setting up info table
			Gets listeners and eavesdroppers
		]]

		if (info.bShouldSend) then
			local players = _player.GetAll();
			local transmitPos = info.player:GetPos();
			local listeners = {};
			local eavesdroppers = {};

			for k, ply in pairs(players) do
				if (!ply:HasInitialized() or !ply:Alive() or !ply.listenChannels) then
					continue;
				end;
				-- Check if ply can hear the radio transmit
				local canHear = Clockwork.plugin:Call("PlayerCanHearRadioTransmit", ply, info);
				if (canHear or ply == info.player) then
					listeners[#listeners + 1] = ply;
				-- Else check if ply can eavesdrop
				elseif (!info.data.bNoEavesdrop) then
					local canEavesdrop = Clockwork.plugin:Call("PlayerCanEavesdropRadioTransmit", ply, info, transmitPos);
					if (canEavesdrop) then
						eavesdroppers[#eavesdroppers + 1] = ply;
					end;
				end;
			end;

			Clockwork.plugin:Call("AdjustRadioTransmitListeners", info, listeners);
			if (#listeners > 0) then
				if (info.multiplier) then
					Clockwork.chatBox:SetMultiplier(info.multiplier);
				end;
				Clockwork.chatBox:Add(listeners, info.player, "radio_transmit", info.text, info.data);
			end;

			Clockwork.plugin:Call("AdjustRadioTransmitEavesdroppers", info, eavesdroppers);
			if (info.multiplier) then
				Clockwork.chatBox:SetMultiplier(info.multiplier);
			end;
			Clockwork.chatBox:Add(eavesdroppers, info.player, "radio_eavesdrop", info.text, info.data);
		end;
	end;
else
	function Clockwork.radio:FormatRadioChannel(channel, channelNumber)
		if (type(channelNumber) == "string") then
			return self:FindByID(channel).name.." ("..channelNumber..")";
		elseif (type(channelNumber) == "number") then
			return self:FindByID(channel).name.." (#"..channelNumber..")";
		elseif (type(channelNumber) == "table") then
			return self:FindByID(channel).name.." (#"..channelNumber[1].."-"..channelNumber[2]..")";
		end;
	end;
end;

for k, v in pairs(file.Find(Clockwork.kernel:GetSchemaFolder().."/plugins/radio/plugin/channels/*.lua", "LUA", "namedesc")) do
	Clockwork.kernel:IncludePrefixed(Clockwork.kernel:GetSchemaFolder().."/plugins/radio/plugin/channels/"..v);
end;

Clockwork.plugin:Add("Radio", Clockwork.radio);