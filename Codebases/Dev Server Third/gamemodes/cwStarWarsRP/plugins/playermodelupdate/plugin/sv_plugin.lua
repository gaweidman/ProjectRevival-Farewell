
local PLUGIN = PLUGIN;
local Clockwork = Clockwork;
local playerMeta = FindMetaTable("Player");

function playerMeta:SetBodyGroups()
	-- Reset all bodygroups
	for i = 0, (self:GetNumBodyGroups() - 1) do
		self:SetBodygroup(i, 0);
	end;

	local toggleList = self:GetCharacterData("toggle_bodygroup", {});
	local bodyGroupsList = self:GetCharacterData("bodygroups");
	local class = Clockwork.class:FindByID(self:Team());
	local faction = Clockwork.faction:FindByID(self:GetFaction());

	-- Set faction bodygroups
	if (faction.bodyGroupsList) then
		PLUGIN:SetBodyGroupsFromTable(self, faction.bodyGroupsList)
	end;
	-- Set class bodygroups, overwrite faction bodygroups if needed
	if (class.bodyGroupsList) then
		PLUGIN:SetBodyGroupsFromTable(self, class.bodyGroupsList)
	end;
	-- Set 'permanent' personal bodygroups, overwrite previous bodygroups
	if (bodyGroupsList) then
		PLUGIN:SetBodyGroupsFromTable(self, bodyGroupsList)
	end;
	-- Set the player-adjustable bodygroups
	if (toggleList) then
		PLUGIN:SetBodyGroupsFromTable(self, toggleList);
	end;
end;

function playerMeta:SetPlayerScale()
	self:SetModelScale(self:GetCharacterData("model_scale", 1), 0);
end;


function PLUGIN:SetBodyGroupsFromTable(player, tbl)
	-- Get the table with bodygroups for the player's current model
	local bodyGroups = tbl[player:GetModel()];
	-- Maximum amount of bodygroups (-1 because bodygroups start at 0)
	local maxBodygroup = player:GetNumBodyGroups() - 1;
	-- Check if we actually got a table for ipairs
	if (bodyGroups and type(bodyGroups) == "table") then
		-- Loop over the bodygroups in order
		for bodyGroup, bodyGroupState in pairs(bodyGroups) do
			-- If we go past the max bodygroup or the state is too high, skip to next one
			if (tonumber(bodyGroup) > maxBodygroup or bodyGroupState > player:GetBodygroupCount(tonumber(bodyGroup)) - 1) then
				continue;
			end;
			-- Set bodygroup
			player:SetBodygroup(tonumber(bodyGroup), bodyGroupState);
		end;
	end;
end;
