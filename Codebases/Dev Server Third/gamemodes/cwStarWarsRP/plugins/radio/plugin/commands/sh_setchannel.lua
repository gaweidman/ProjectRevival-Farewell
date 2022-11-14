
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("SetChannel");
COMMAND.tip = "Sets the radio channel you are transmitting on.";
COMMAND.text = "<string ChannelName> [int ChannelNumber|Default: 1]";
COMMAND.flags = CMD_DEFAULT;
COMMAND.arguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local argTable = string.Explode(" ", arguments[1])
	local channel = string.lower(argTable[1]);
	local channelTable = Clockwork.radio:FindByID(channel);

	if (channelTable) then
		local channelName = channelTable.name;
		local channelID = channelTable.uniqueID;

		-- Check if the channel is none or a global one and the player has it, then set it (as those are easy)
		if (channelTable.global and player.globalChannels[channelID]) then
			local oldChannel = player:GetSharedVar("radio_transmit");

			player:SetSharedVar("radio_transmit", channelID);

			Clockwork.player:Notify(player, "You have set your channel to '"..channelName.."'.");
			Clockwork.plugin:Call("PlayerChannelSet", player, oldChannel, channelID);

		-- Check if it's an actual channel, then dig through channel number and set it
		elseif (player.listenChannels[channelID]) then
			local oldChannel = player:GetSharedVar("radio_transmit");

			player:SetSharedVar("radio_transmit", channelID);

			if (channelTable.subChannels > 1) then
				local channelNumber = tonumber(argTable[2]);
				
				if (!channelNumber) then
					channelNumber = 1;
				else
					channelNumber = math.Clamp(math.floor(channelNumber), 1, channelTable.subChannels);
				end;
				
				player.listenChannels[channelID] = channelNumber;
				Clockwork.datastream:Start(player, "set_channel", {channelID, channelNumber});

				Clockwork.player:Notify(player, "You have set your channel to '"..channelName.."' (#"..channelNumber..").");
				Clockwork.plugin:Call("PlayerChannelSet", player, oldChannel, channelID, channelNumber);
			else
				Clockwork.player:Notify(player, "You have set your channel to '"..channelName.."'.");
				Clockwork.plugin:Call("PlayerChannelSet", player, oldChannel, channelID);
			end;
		else
			Clockwork.player:Notify(player, "You do not have access to '"..channelName.."'.");
		end;
	elseif (channel == Clockwork.radio.CHANNEL_NONE) then
	    local oldChannel = player:GetSharedVar("radio_transmit");

		player:SetSharedVar("radio_transmit", channel);

		Clockwork.player:Notify(player, "You have set your channel to '"..channel.."'.");
		Clockwork.plugin:Call("PlayerChannelSet", player, oldChannel, channel);
	else
		Clockwork.player:Notify(player, channel.." is not a valid channel.");
	end;
end;

COMMAND:Register();