PLUGIN.name = "Cremator Faction"
PLUGIN.author = "JohnyReaper"
PLUGIN.description = "Adds playable Cremator faction."

-- Animations, yay!
ix.anim.cremator = {
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_RUN] = {ACT_WALK, ACT_WALK},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_FIRE_START] = {ACT_RANGE_ATTACK1, ACT_RANGE_ATTACK1},
		[ACT_FIRE_LOOP] = {ACT_RANGE_ATTACK2, ACT_RANGE_ATTACK2},
		[ACT_FIRE_END] = {ACT_RANGE_ATTACK1_LOW, ACT_RANGE_ATTACK1_LOW}
	},
	smg = { -- hold type for immolator
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_RUN] = {ACT_WALK, ACT_WALK},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_FIRE_START] = {ACT_RANGE_ATTACK1, ACT_RANGE_ATTACK1},
		[ACT_FIRE_LOOP] = {ACT_RANGE_ATTACK2, ACT_RANGE_ATTACK2},
		[ACT_FIRE_END] = {ACT_RANGE_ATTACK1_LOW, ACT_RANGE_ATTACK1_LOW},
		attack = ACT_RANGE_ATTACK2
	},
	physgun = { 
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_RUN] = {ACT_WALK, ACT_WALK},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		attack = ACT_RANGE_ATTACK1_LOW,
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_RUN] = {ACT_WALK, ACT_WALK},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		attack = ACT_RANGE_ATTACK1_LOW,
	},
}

ix.anim.SetModelClass("models/cremator.mdl", "cremator")
ix.anim.SetModelClass("models/orion_hl2_beta/cremator.mdl", "cremator")
ix.anim.SetModelClass("models/cdpmator.mdl", "cremator")
ALWAYS_RAISED["weapon_crem_immolator"] = true
ALWAYS_RAISED["weapon_bp_flamethrower_edited"] = true
ALWAYS_RAISED["weapon_bp_immolator_edited"] = true

local CHAR = ix.meta.character

function CHAR:IsCremator()
	local faction = self:GetFaction()
	return faction == FACTION_CREMATOR
end

function PLUGIN:PlayerDeath(client)

	if client:GetModel() == "models/cdpmator.mdl" then
		client:StopSound("npc/cremator/amb_loop.wav")
	end
	
end

function PLUGIN:GetPlayerPainSound(client)
	if (client:GetModel() == "npc/cremator/amb_loop.wav") then
		local PainCremator = {
			"npc/cremator/amb1.wav",
			"npc/cremator/amb2.wav",
			"npc/cremator/amb3.wav",
		}
		local crem_pain = table.Random(PainCremator)
		return crem_pain
	end
end

function PLUGIN:GetPlayerDeathSound(client)
	if (client:GetModel() == "models/cdpmator.mdl") then
		local crem_die = "npc/cremator/crem_die.wav"

		client:EmitSound(crem_die, 70, 100, 0.6, CHAN_AUTO)

		/*

		for k, v in ipairs(player.GetAll()) do
			if (v:HasBiosignal()) then
				v:EmitSound(crem_die)
			end
		end

		*/

		return crem_die
	end
end

function PLUGIN:PostPlayerLoadout(client) 

	if (client:GetModel() == "models/cdpmator.mdl") then
		client:SetMaxHealth(150)
		client:SetHealth(150)
		client:SetArmor(150)
		client:Give("weapon_vfirethrower")
	end		

	

	if client:GetModel() == "models/cdpmator.mdl" then

		client:SetWalkSpeed(91)

	elseif (client:GetWalkSpeed() == 91) then

		client:SetWalkSpeed(130)

	end

end

function PLUGIN:PlayerSpawn( client )

    if client:GetModel() == "models/cdpmator.mdl" then
    	client:EmitSound("npc/cremator/amb_loop.wav", 70, 100, 0.6, CHAN_AUTO)
	end	

end

function PLUGIN:PlayerLoadedCharacter(client, newChar, oldChar)
	if IsValid(oldChar) and oldChar:GetModel() == "models/cdpmator.mdl" then
		client:StopSound("npc/cremator/amb_loop.wav")
	end
end

