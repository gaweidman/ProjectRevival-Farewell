--[[
	© 2012 CloudSixteen.com do not share, re-distribute or modify
	without permission of its author (kurozael@gmail.com).
--]]

-- Called when Clockwork has loaded all of the entities.
function Schema:ClockworkInitPostEntity()
end;

-- Called just after data should be saved.
function Schema:PostSaveData()
end;

-- Called when a player's default inventory is needed.
function Schema:GetPlayerDefaultInventory(player, character, inventory)
	if (character.faction == FACTION_EXAMPLE) then
		Clockwork.inventory:AddInstance(
			inventory, Clockwork.item:CreateInstance("example")
		);
	end;
end;