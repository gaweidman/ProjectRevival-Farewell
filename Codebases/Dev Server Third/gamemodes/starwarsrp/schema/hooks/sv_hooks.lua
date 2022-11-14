--[[
	Purpose: Called to allow items to be added to a character during
	character creation. The inventory table is passed which contains
	an inventory:Add(uniqueID, quantity, data) method which is similar
	to client:UpdateInv(), the player who created the character is passed
	as the 2nd argument, and the character creation data is passed as the
	3rd argument.
--]]
function SCHEMA:GetDefaultInv(inventory, client, data)
	-- PrintTable(data) to see what information it contains.
	
	if (data.faction == FACTION_CITIZEN) then
		inventory:Add("cid", 1, {
			Digits = math.random(11111, 99999),
			Owner = data.charname
		})
	end
end

--[[
	Purpose: Called when the player has spawned with a valid character.
--]]
function SCHEMA:PlayerSpawn(client)
	print("Just like regular gamemodes, except we replace GM with SCHEMA.")
end
