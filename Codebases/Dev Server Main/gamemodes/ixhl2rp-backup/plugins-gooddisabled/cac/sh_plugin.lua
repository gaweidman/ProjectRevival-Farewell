PLUGIN.name = "Combine Ancillary Commission"
PLUGIN.author = "QIncarnate & JohnnyRepaer"
PLUGIN.description = "Adds a faction for stalkers and cremators."


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

	if client:GetCharacter():GetClass() == CLASS_CREMATOR then
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
	if (client:GetCharacter():GetClass() == CLASS_CREMATOR) then
		local crem_die = "npc/cremator/crem_die.wav"
		
		client:EmitSound(crem_die, 70, 100, 0.3)

		Schema:AddCombineDisplayMessage("Life functions ceased for cremator unit "..client:GetName(), Color(255, 0, 0))

		--[[
		I don't like the idea of just hearing it die,
		replacing it with a visor notification instead.

		We really need a way to make the visor more
		visible without taking up too much of the
		screen.

		for k, v in ipairs(player.GetAll()) do
			if (v:HasBiosignal()) then
				v:EmitSound(crem_die)
			end
		end

		]]--

		for k, v in ipairs(player.GetAll()) do
			if (v:HasBiosignal()) then
				v:AddCombineDisplayMessage("Life functions ceased for cremator unit "..client:GetName(), Color(255, 0, 0))
			end
		end

		return crem_die
	end
end

function PLUGIN:PostPlayerLoadout(client) 
	if client:GetCharacter():GetClass() == CLASS_CREMATOR then

		client:SetMaxHealth(75)
		client:SetHealth(75)
		client:SetArmor(0)
		client:Give("weapon_vfirethrower")

        client:SetWalkSpeed(91)
        client:SetRunSpeed(104)
		client:SetBloodColor(DONT_BLEED)
		client:SetLadderClimbSpeed(0)

	elseif (client:GetWalkSpeed() == 91) then -- Cremator class isn't mentioned, because getting to this elseif means that the player isn't in the cremator class.

        client:SetWalkSpeed(ix.config.Get("walkSpeed"))
		client:SetRunSpeed(ix.config.Get("runSpeed") + character:GetAttribute("agi", 0) * ix.config.Get("agilityMultiplier"))
		client:SetLadderClimbSpeed(200)

	end

end

function PLUGIN:PlayerSpawn( client )

	if client:GetCharacter() != nil then
		-- Makes it so cremator breathing stops when the player changes class.
		-- I don't know why it's in PlayerSpawn() and I don't care enough to find out.
		if client:GetCharacter():GetClass() == CLASS_CREMATOR then
			client:EmitSound("npc/cremator/amb_loop.wav", 70, 100, 0.3)
		else
			client:StopSound("npc/cremator/amb_loop.wav")
		end
	end

end

