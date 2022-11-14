
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

function PLUGIN:PlayerAdjustChannels(player)
	local items = player:GetInventory();
	for k, itemList in pairs(items) do
		for k, itemTable in pairs(itemList) do
			if (!itemTable("frequency", false)) then
				break;
			else
				self:AddItemChannelToPlayer(player, itemTable);
			end;
		end;
	end;
end;

function PLUGIN:PlayerItemGiven(player, itemTable)
	if (itemTable("frequency", false)) then
		local freqID = self:AddItemChannelToPlayer(player, itemTable);

		if (freqID) then
			Clockwork.datastream:Start(player, "set_channel", {freqID, 1});
		end;
	end;
end;

function PLUGIN:PlayerItemTaken(player, itemTable)
	if (itemTable("frequency", false)) then
		timer.Simple(FrameTime() * 32, function()
			Clockwork.radio:SetPlayerChannels(player);
		end);
	end;
end;

Clockwork.datastream:Hook("radio_frequency", function(player, data)
	local itemTable = player:FindItemByID(data[2], tonumber(data[3]));

	if (itemTable) then
		if (string.find(data[1], "^%d%d%d%.%d$")) then
			local first = string.match(data[1], "(%d)%d%d%.%d");
			if (first != "0") then
				itemTable:SetData("frequency", data[1]);
				Clockwork.radio:SetPlayerChannels(player);
			
				Clockwork.player:Notify(player, "You have set this stationary radio's frequency to "..data[1]..".");
			else
				Clockwork.player:Notify(player, "The frequency must be between 100.0 and 999.9!");
			end;
		else
			Clockwork.player:Notify(player, "The radio frequency must look like xxx.x!");
		end;
	end;
end);

-- Called when Clockwork has loaded all of the entities.
function PLUGIN:ClockworkInitPostEntity()
	self:LoadRadios();
end;

-- Called just after data should be saved.
function PLUGIN:PostSaveData()
	self:SaveRadios();
end;

-- Called when an entity's menu option should be handled.
function PLUGIN:EntityHandleMenuOption(player, radio, option, arguments)
	if (radio:GetClass() == "cw_itemradio") then
		if (option == "Set Frequency" and type(arguments) == "string") then
			local channelTable = Clockwork.radio:FindByID(arguments);
			if (channelTable) then
				if (channelTable.stationaryCanAccess) then
					radio:SetFrequency(channelTable.uniqueID);
					
					Clockwork.player:Notify(player, "You have set this stationary radio's channel to "..channelTable.name..".");
				else
					Clockwork.player:Notify(player, "This stationary radio cannot tune in on that channel!");
				end;
			elseif (string.find(arguments, "^%d%d%d%.%d$")) then
				local first = string.match(arguments, "(%d)%d%d%.%d");
				if (first != "0") then
					local freqID = "freq_"..string.gsub(arguments, "%p", "")
					local channelTable = Clockwork.radio:FindByID(freqID);

					if (!channelTable) then
						self:CreateItemChannel("freq "..arguments, freqID);
					end;
					Clockwork.datastream:Start(nil, "create_item_channel", {"freq "..arguments, freqID});

					radio:SetFrequency(freqID);
						
					Clockwork.player:Notify(player, "You have set this stationary radio's frequency to "..arguments..".");
				else
					Clockwork.player:Notify(player, "The frequency must be between 100.0 and 999.9!");
				end;
			else
				Clockwork.player:Notify(player, "The radio frequency must look like xxx.x!");
			end;
		elseif (arguments == "cw_radioToggle") then
			radio:Toggle();
		elseif (arguments == "cw_radioTake") then
			local bSuccess, fault = player:GiveItem(Clockwork.item:CreateInstance("stat_radio"));
			
			if (!bSuccess) then
				Clockwork.player:Notify(player, fault);
			else
				radio:Remove();
			end;
		end;
	end;
end;

function PLUGIN:ChatBoxMessageAdded(info)
	local class = info.class
	if (class == "ic" or class == "whisper" or class == "yell") then
		local player = info.speaker
		local radio = player:GetEyeTraceNoCursor().Entity;

		if (radio and radio:GetClass() == "cw_itemradio") then
			if (!radio:IsOff()) then
				local range = Clockwork.config:Get("talk_radius"):Get();
				local sayType = nil
				if (class == "whisper") then
					range = range / 3;
					sayType = "whisper"
				elseif (class == "yell") then
					range = range * 2;
					sayType = "yell"
				end;

				if (radio:GetPos():DistToSqr(player:GetShootPos()) <= math.pow(range, 2)) then
					local data = {
						range = range,
						sayType = sayType,
						channelID = radio:GetFrequency(),
						stationaryRadio = true
					};
					Clockwork.radio:SayRadio(player, info.text, data, true);

					info.bShouldSend = false;
				end;
			end;
		end;
	end;
end;

function PLUGIN:PlayerCanHearRadioTransmit(player, info)
	local range = math.pow(Clockwork.config:Get("talk_radius"):Get(), 2);
	local radios = ents.FindByClass("cw_itemradio");
	local channelID = info.data.channelID;
	for k, radio in pairs(radios) do
		if (radio:IsOff() or radio:GetFrequency() != channelID) then
			continue;
		else
			if (player:GetPos():DistToSqr(radio:GetPos()) < range) then
				return true;
			end;
		end;
	end;
end;