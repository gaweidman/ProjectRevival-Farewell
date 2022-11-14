
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Setup the player's channels
function PLUGIN:PostPlayerSpawn(player, lightSpawn, changeClass, firstSpawn)
	if (firstSpawn) then
		-- Clear temp channels
		player.tempChannels = {};
	end;
end;

-- Update channels
function PLUGIN:PlayerClassSet(player)
	Clockwork.radio:SetPlayerChannels(player);
end;

-- Client asks for channel update so update channels
Clockwork.datastream:Hook("listen_channels", function(player, data)
	if (player:HasInitialized()) then
		Clockwork.radio:SetPlayerChannels(player);
	end;
end);

--[[
	Begin radio library Hooks
]]

-- Called when a player's channel get set
function PLUGIN:PlayerChannelSet(player, oldChannel, newChannel, channelNumber) end;

-- Called when radio channels should be registered
function PLUGIN:RegisterRadioChannels() end;

-- Called when a radio channel has been initialized
function PLUGIN:ClockworkRadioChannelInitialized(channel) end;

-- Called when a player's channels should be adjusted
function PLUGIN:PlayerAdjustChannels(player, listenChannels, globalChannels) end;

-- Called to check if a radio message can be eavesdropped
function PLUGIN:NoEavesdrop(player, channelID, sayType)
	if (Clockwork.config:Get("no_noclip_eavesdrop"):Get()) then
		if (player:IsNoClipping()) then
			return true;
		end;
	end;
end;

-- Called when the radio transmit info should be adjusted
function PLUGIN:AdjustRadioTransmitInfo(info) end;

-- Called to check if a player can hear a radio message over radio
function PLUGIN:PlayerCanHearRadioTransmit(player, info)
	local transmitChannels = info.data.transmitTable;

	for channelID, channelNumber in pairs(transmitChannels) do
		if (Clockwork.radio:HasPlayerChannel(player, channelID, channelNumber)) then
			return true;
		end;
	end;
end;

-- Called to check if a player can eavesdrop on someone speaking in a radio nearby
function PLUGIN:PlayerCanEavesdropRadioTransmit(player, info, transmitPos)
	if (player:GetPos():DistToSqr(transmitPos) <= math.pow(info.data.range, 2)) then
		return true;
	end;
end;

-- Called when the radio transmit listeners should be adjusted
function PLUGIN:AdjustRadioTransmitListeners(info, listeners) end;

-- Called when the radio transmit eavesdroppers should be adjusted
function PLUGIN:AdjustRadioTransmitEavesdroppers(info, eavesdroppers) end;

--[[
	End radio library hooks
]]

 function PLUGIN:PlayerCanUseCommand(player, commandTable, arguments)
 	if (player:GetSharedVar("tied") != 0) then
 		local tbl = {"R", "RW", "RY", "SetChannel", "SC", "Radio"};		
		if (table.HasValue(tbl, commandTable.name)) then
			Clockwork.player:Notify(player, "You cannot use this command when you are tied!");
			
			return false;
		end;
	end;
end;


-- Disable old radio
function PLUGIN:PlayerCanRadio()
	return false;
end;

-- Update old radio command
local radioCommandUpdated = false;
function PLUGIN:Think()
	if (!radioCommandUpdated) then
		self:UpdateRadioCommand();
		radioCommandUpdated = true;
	end;
end;