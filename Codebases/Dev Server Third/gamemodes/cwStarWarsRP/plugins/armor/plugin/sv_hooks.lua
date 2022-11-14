
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;

-- Called when a player's character data should be saved.
function PLUGIN:PlayerSaveCharacterData(player, data)
	if (data["paTraining"]) then
		data["paTraining"] = data["paTraining"];
	else
		data["paTraining"] = 0;
	end;
	if (data["filterQuality"]) then
		data["filterQuality"] = math.Round(data["filterQuality"]);
	else
		data["filterQuality"] = 0;
	end;
end;

-- Called when a player's character data should be restored.
function PLUGIN:PlayerRestoreCharacterData(player, data)
	data["paTraining"] = data["paTraining"] or 0;
	data["filterQuality"] = data["filterQuality"] or 0;
end;

-- Called when a player's shared variables should be set.
function PLUGIN:PlayerSetSharedVars(player, curTime)
	player:SetSharedVar("paTraining", player:GetCharacterData("paTraining"), 0, 3);
	
	local clothes = player:GetClothesItem();
	if (clothes and (clothes("hasRebreather") or clothes("hasGasmask"))) then
		player:SetSharedVar("hasGasmask", true);
	else
		player:SetSharedVar("hasGasmask", false);
	end;

	player:SetSharedVar("filterQuality", math.Round(player:GetCharacterData("filterQuality")));
end;

function PLUGIN:PlayerThink(player, curTime, infoTable)
	local clothes = player:GetClothesItem()
	if (clothes and clothes("isPA")) then
		local paTraining = player:GetCharacterData("paTraining");
		if (!paTraining or paTraining == 0) then
			player:SetWalkSpeed(Clockwork.config:Get("walk_speed"):Get() * 0.25);
			player:SetRunSpeed(math.min(Clockwork.config:Get("run_speed"):Get() * 0.25, player.cwWalkSpeed));
		elseif (paTraining == 1) then
			player:SetWalkSpeed(Clockwork.config:Get("walk_speed"):Get() * 0.70);
			player:SetRunSpeed(math.min(Clockwork.config:Get("run_speed"):Get() * 0.65, player.cwWalkSpeed));
		elseif (paTraining == 2) then
			player:SetWalkSpeed(Clockwork.config:Get("walk_speed"):Get() * 0.85);
			player:SetRunSpeed(math.min(Clockwork.config:Get("run_speed"):Get() * 0.75, player.cwWalkSpeed));
		elseif (paTraining == 3) then
			player:SetWalkSpeed(Clockwork.config:Get("walk_speed"):Get());
			player:SetRunSpeed(math.min(Clockwork.config:Get("run_speed"):Get() * 0.95, player.cwWalkSpeed));
		end;	
	end;
end;

-- Called when the player takes damage
function PLUGIN:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	if (attacker:IsPlayer() or attacker:IsNPC()) then
		local clothes = player:GetClothesItem();
		if (clothes and clothes("protection") and clothes("protection") > 0) then
			damageInfo:ScaleDamage(1 - math.Clamp(clothes("protection"), 0, 1));
		end;
	end;
end;

function PLUGIN:EntityHandleMenuOption(player, entity, option, arguments)
	if (entity:GetClass() == "cw_item" and option == "Customize" and player:IsSuperAdmin()) then
		local itemTable = entity:GetItemTable();
		
		for field, data in pairs (arguments) do
			itemTable:SetData(field, data);
		end;

		return true;
	end;
end;