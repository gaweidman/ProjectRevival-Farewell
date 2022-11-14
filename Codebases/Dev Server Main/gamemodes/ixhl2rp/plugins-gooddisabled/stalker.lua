PLUGIN.name = "Stalker Faction"
PLUGIN.author = "QIncarnate"
PLUGIN.description = "Adds playable Cremator faction."

ALWAYS_RAISED["weapon_crem_immolator"] = true
ALWAYS_RAISED["weapon_bp_flamethrower_edited"] = true
ALWAYS_RAISED["weapon_bp_immolator_edited"] = true

local CHAR = ix.meta.character

function CHAR:IsStalker()
	local faction = self:GetFaction()
	return faction == FACTION_STALKER
end


function PLUGIN:PlayerDeath(client)

	if client:GetCharacter():IsStalker() then
		//client:StopSound("npc/cremator/amb_loop.wav")
	end
	
end

function PLUGIN:GetPlayerPainSound(client)
	/*
	if (client:GetCharacter():IsStalker()) then
		local PainCremator = {
			"npc/cremator/amb1.wav",
			"npc/cremator/amb2.wav",
			"npc/cremator/amb3.wav",
		}
		local crem_pain = table.Random(PainCremator)
		return crem_pain
	end
	*/
end

function PLUGIN:GetPlayerDeathSound(client)
/*
	if (client:GetCharacter():IsStalker()) then
		local crem_die = "npc/cremator/crem_die.wav"

		for k, v in ipairs(player.GetAll()) do
			if (v:HasBiosignal()) then
				v:EmitSound(crem_die)
			end
		end

		return crem_die
	end
*/
end

function PLUGIN:PostPlayerLoadout(client) 	

end

function PLUGIN:PlayerSpawn( client )
/*
    if (client:GetCharacter():IsCremator()) then
    	client:EmitSound( "npc/cremator/amb_loop.wav", 70, 100, 0.6, CHAN_AUTO )
    else
		client:StopSound("npc/cremator/amb_loop.wav")
	end
*/
end


function PLUGIN:PlayerUseDoor(client, door)
	if (client:GetCharacter():IsCremator()) then
		if (!door:HasSpawnFlags(256) and !door:HasSpawnFlags(1024)) then
			door:Fire("open")
		end
	end
end

