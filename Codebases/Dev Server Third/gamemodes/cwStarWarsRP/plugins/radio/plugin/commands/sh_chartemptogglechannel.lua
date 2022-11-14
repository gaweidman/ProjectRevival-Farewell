
local PLUGIN = PLUGIN;

local COMMAND = Clockwork.command:New("CharTempToggleChannel");
COMMAND.tip = "Temporarily subcribes the player to a radio channel.";
COMMAND.text = "<string Name> <string ChannelName> [int DefaultChannelNumber|Default: 0]";
COMMAND.access = "a";
COMMAND.arguments = 2;
COMMAND.optionalArguments = 1;

-- Called when the command has been run.
function COMMAND:OnRun(player, arguments)
	local target = Clockwork.player:FindByID(arguments[1]);
	if (target) then
		local channel = string.lower(arguments[2]);
		local channelTable = Clockwork.radio:FindByID(channel);

		if (channelTable) then
			local channelID = channelTable.uniqueID;
			local channelList = target.tempChannels;

			if (channelList[channelID]) then
				channelList[channelID] = nil;

				if (player != target) then
					Clockwork.player:Notify(player, "You have unsubscribed "..target:Name().." from '"..channelTable.name.."'.");
					Clockwork.player:Notify(target, player:Name().." has unsubscribed you from '"..channelTable.name.."'.");
				else
					Clockwork.player:Notify(player, "You have been unsubscribed from '"..channelTable.name.."'.");
				end;
			else
				local channelNumber = tonumber(arguments[3]);
				if (!channelNumber or channelTable.global) then
					channelNumber = 1;
				else
					channelNumber = math.Clamp(math.floor(channelNumber), 1, channel.subChannels);
				end;

				channelList[channelID] = channelNumber;

				if (player != target) then
					Clockwork.player:Notify(player, "You have temporarily subscribed "..target:Name().." to '"..channelTable.name.."'.");
					Clockwork.player:Notify(target, player:Name().." has temporarily subscribed you to '"..channelTable.name.."'.");
				else
					Clockwork.player:Notify(player, "You have temporarily been subscribed to '"..channelTable.name.."'.");
				end;
			end;

			target.tempChannels = channelList;
			target:SetChannels();
		else
			Clockwork.player:Notify(player, channel.." is not a valid channel.");
		end;
	else
		Clockwork.player:Notify(player, arguments[1].." is not a valid player.");
	end;
end;

COMMAND:Register();