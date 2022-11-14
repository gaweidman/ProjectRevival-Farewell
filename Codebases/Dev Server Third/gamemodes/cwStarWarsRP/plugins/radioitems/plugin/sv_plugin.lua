
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- A function to load the radios.
function PLUGIN:LoadRadios()
	local radios = Clockwork.kernel:RestoreSchemaData( "plugins/radioitems/"..game.GetMap() );
	
	for k, v in pairs(radios) do
		local entity = ents.Create("cw_itemradio");
		
		Clockwork.player:GivePropertyOffline(v.key, v.uniqueID, entity);
		
		entity:SetAngles(v.angles);
		entity:SetPos(v.position);
		entity:Spawn();
		
		if (IsValid(entity)) then
			entity:SetFrequency(v.frequency);
			entity:SetDisableChannelTuning(v.tuningDisabled);
			entity:SetOff(v.off);
		end;
		
		if (!v.moveable) then
			local physicsObject = entity:GetPhysicsObject();
			
			if (IsValid(physicsObject)) then
				physicsObject:EnableMotion(false);
			end;
		end;
	end;
end;

-- A function to save the radios.
function PLUGIN:SaveRadios()
	local radios = {};
	
	for k, v in pairs(ents.FindByClass("cw_itemradio")) do
		local physicsObject = v:GetPhysicsObject();
		local moveable;
		
		if (IsValid(physicsObject)) then
			moveable = physicsObject:IsMoveable();
		end;
		
		radios[#radios + 1] = {
			off = v:IsOff(),
			key = Clockwork.entity:QueryProperty(v, "key"),
			angles = v:GetAngles(),
			moveable = moveable,
			uniqueID = Clockwork.entity:QueryProperty(v, "uniqueID"),
			position = v:GetPos(),
			frequency = v:GetFrequency(),
			tuningDisabled = v:IsChannelTuningDisabled()
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/radioitems/"..game.GetMap(), radios);
end;

function PLUGIN:CreateItemChannel(frequency, frequencyID, priority, color, sound, stationaryCanAccess)
	local CHANNEL = Clockwork.radio:New();
	CHANNEL.name = frequency;
	CHANNEL.uniqueID = frequencyID;
	CHANNEL.subChannels = 1;
	CHANNEL.global = false;
	CHANNEL.defaultPriority = priority or 5;
	CHANNEL.stationaryCanAccess = stationaryCanAccess;

	if (color) then
		CHANNEL.color = color;
	end;

	if (sound) then
		CHANNEL.sound = sound;
	end;

	CHANNEL:Register();
end;

function PLUGIN:FreqToFreqID(frequency)
	local freqID = "radioitem_"..string.lower(frequency);
	freqID = string.gsub(freqID, "%s", "_");
	freqID = string.gsub(freqID, "%p", "");

	return freqID;
end;

function PLUGIN:AddItemChannelToPlayer(player, itemTable)
	local frequency = itemTable("frequency");
	if (!frequency or frequency == "") then
		return;
	end;

	local frequencyID = itemTable("frequencyID", nil);
	if (!frequencyID) then
		frequencyID = self:FreqToFreqID(frequency);
	end;

	if (!Clockwork.radio:IsActualChannel(frequencyID)) then
		self:CreateItemChannel(frequency, frequencyID, itemTable("frequencyPriority"),
			itemTable("frequencyColor"), itemTable("frequencySound"), itemTable("stationaryCanAccess"));
	end;
	-- Always network the channel in case another player created it
	Clockwork.datastream:Start(player, "create_item_channel", {frequency, frequencyID});

	Clockwork.radio:AddChannelToPlayer(player, frequencyID);

	return frequencyID;
end;