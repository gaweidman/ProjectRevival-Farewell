function Schema:LoadData()
	self:LoadRationDispensers()
	self:LoadVendingMachines()
	self:LoadCombineLocks()
	self:LoadForceFields()
	self:LoadPadlocks()

	local actors = ix.data.Get("ActorGeneric", {})

    for k, v in ipairs(actors) do
        local actor = ents.Create("ix_actorgeneric")
        actor:SetModel(v.model)
        actor:SetPos(v.pos)
        actor:SetAngles(v.ang)
        actor:Spawn()
        actor:Activate()
        actor:SetModel(v.model)
        actor:SetSkin(v.skin)
        actor:SetNetVar("name", v.name)
        actor:SetNetVar("description", v.description)
        actor.CryMessages = v.cryMessages
        actor.UseMessages = v.useMessages

        for id, value in ipairs(v.bodygroups) do
            actor:SetBodygroup(id, value)
        end

        actor:SetupVisuals(v.model, v.sequence)
    end

	local posters = ix.data.Get("Posters", {})
	for k, v in ipairs(posters) do
		local poster = ents.Create("ix_poster")
		poster:SetPos(v.pos)
		poster:SetAngles(v.ang)
		poster:Spawn()
		poster:SetImage(v.img)
	end

	Schema.CombineObjectives = ix.data.Get("combineObjectives", {}, false, true)

	local placedEnts = ix.data.Get("PlacedProps", {})
	for k, v in ipairs(posters) do
		local placedEnt = ents.Create("prop_physics")
		placedEnt:SetPos(v.pos)
		placedEnt:SetAngles(v.ang)
		lacedEnt:SetModel(v.model)
		placedEnt:Spawn()
		placedEnt:SetVar("PlacedInHelix", true)
		placedEnt:GetPhysicsObject():EnableMotion(false)
	end

	
end

function Schema:SaveData()
	self:SaveRationDispensers()
	self:SaveVendingMachines()
	self:SaveCombineLocks()
	self:SaveForceFields()
	self:SavePadlocks()

	local actors = {}

    for k, v in pairs(ents.FindByClass("ix_actorgeneric")) do
        local actor = {}
        actor.sequence = v:GetSequenceName(v:GetSequence())
        actor.name = v:GetNetVar("name", "Generic Actor")
        actor.description = v:GetNetVar("description", "Description")
        actor.cryMessages = v.CryMessages
        actor.useMessages = v.UseMessages
        actor.model = v:GetModel()
        actor.pos = v:GetPos()
        actor.ang = v:GetAngles()
        local bodygroups = v:GetBodyGroups()

        local niceBodygroups = {}

        for _, bg in ipairs(bodygroups) do
            niceBodygroups[bg.id] = v:GetBodygroup(bg.id)
        end

        actor.bodygroups = niceBodygroups

        actor.skin = v:GetSkin()
        actors[#actors + 1] = actor
    end

	ix.data.Set("ActorGeneric", actors)

	local posters = {}
	for k, v in pairs(ents.FindByClass("ix_poster")) do
        local poster = {}
        poster.pos = v:GetPos()
        poster.ang = v:GetAngles()
		poster.img = v:GetNetVar("Image", nil)
       
        posters[#posters + 1] = poster
    end

	ix.data.Set("Posters", posters)

	local placedEnts = {}
	for k, v in pairs(ents.FindByClass("prop_physics")) do
		if v:GetVar("PlacedInHelix", false) then
			local entTable = {}

			entTable.pos = v:GetPos()
			entTable.ang = v:GetAngles()
			entTable.model = v:GetModel()

			placedEnts[#placedEnts + 1] = entTable
		end
    end

	ix.data.Set("PlacedProps", placedEnts)

    
end

hook.Add("EntityRemoved", "prRemoveGrenade", function(entity)
	-- hack to remove hl2 grenades after they've all been thrown
	local class = entity:GetClass()
	if (class == "weapon_flashbang_QI" or class == "weapon_ttt_smokegrenade" or class == "ix_manhack") then
		local client = entity:GetOwner()

		if (IsValid(client) and client:IsPlayer() and client:GetCharacter()) then
			if entity.ixItem and entity.ixItem.Unequip then
				entity.ixItem:Unequip(client, false, true)
			end
		end
	end
end)

function Schema:PlayerSwitchFlashlight(client, enabled)
	if (client:HasBiosignal()) then
		return true
	end
end

function Schema:PlayerUse(client, entity)
	print(entity:MapCreationID())
	/* City 17 bad buttons.
	local badButtons = {
		
		-- Consul Sphere Buttons
		3715, -- Checkpoint 1 Lockdown
		3717, -- Checkpoint 2 Lockdown
		3721, -- Checkpoint 3 Lockdown
		3719, -- Checkpoint 4 Lockdown
		3713, -- Judgement Waiver Activate
		3714, -- Judgement Waiver Deactivate
		3711, -- Lockdown Activate
		3712, -- Lockdown Deactivate
		3905, -- Shell Beach Gate Open
		3906, -- Shell Beach Gate Close

		-- Broadcasting Station Buttons
		2659, -- Broadcast Start/End Button
		3512, -- Letter Chute Open/Close Button

		-- Consul Room Entry Buttons
		1571, -- Death Ray Button
		1515, -- Bridge Extend/Retract Button
		1562, -- Forcefield Activate/Deactivate Button

		-- Consul Room Elevator Buttons
		1579, -- Elevator Button on Consul's Level
		1534, -- Elevator Button on the Elevator
		
	}
	*/

	local badButtons = {

	}

	if (IsValid(client.ixScanner)) then
		return false
	end

	if entity:IsDoor() and IsValid(entity.ixLock) and client:KeyDown(IN_SPEED) then
		return false
	end

	if (!client:IsRestricted() and entity:IsPlayer() and entity:IsRestricted() and !entity:GetNetVar("untying")) then
		entity:SetAction("@beingUntied", 5)
		entity:SetNetVar("untying", true)

		client:SetAction("@unTying", 5)

		client:DoStaredAction(entity, function()
			entity:SetRestricted(false)
			entity:SetNetVar("untying")
		end, 5, function()
			if (IsValid(entity)) then
				entity:SetNetVar("untying")
				entity:SetAction()
			end

			if (IsValid(client)) then
				client:SetAction()
			end
		end)
	end

	if (!client:IsAdmin() and !client:IsSuperAdmin() and client:GetCharacter():GetFaction() == FACTION_CITIZEN) then
		for k, v in ipairs(badButtons) do
			if entity:MapCreationID() == v then
				RunConsoleCommand("ulx", "banid", client:SteamID(), 0,
				"AUTOMATIC BAN: Exploiting into the Nexus to press administrator buttons.")
			end	
		end
	end
end

function Schema:PlayerUseDoor(client, door)
	local faction = client:GetCharacter():GetFaction()
	local class = client:GetCharacter():GetClass()

	if ((faction == FACTION_ALIEN and class != CLASS_FREEVORT) or faction == FACTION_BIRD) then
		return false
	end

	
	if (client:HasBiosignal() or faction == FACTION_CONSCRIPT or faction == FACTION_ADMIN) then
		if (!door:HasSpawnFlags(256) and !door:HasSpawnFlags(1024)) then
			door:Fire("open")
		end
	end
end


function Schema:PlayerLoadout(client)
	client:SetNetVar("restricted")
end

netstream.Hook("SetVortWeaponMode", function(client, weaponMode)
	if IsValid(client) and client:GetActiveWeapon():GetClass() == "weapon_vortswep" then
		client:GetActiveWeapon():SetVar("WeaponMode", weaponMode)
	end
end)

netstream.Hook("RequestStringResponse", function(client, text)
	client:GetCharacter():SetName(text)
end)

hook.Add( "Think", "VortigauntRateHandling", function()
	for k, v in ipairs(player.GetAll()) do
		local curTime = CurTime()
		local client = v
		local char = client:GetCharacter()
		if char != nil and char:GetFaction() == FACTION_ALIEN and char:GetClass() == CLASS_FREEVORT then -- This check is in case things go wrong. This should always be true as long as the code is working.
			local vortessence = char:GetVortessence()
			local lastVortessenceRegen = client:GetNetVar("LastVortessenceRegen", 0)
			local lastVortilampConsump = client:GetNetVar("LastVortilampConsump")
			local lastVortalEyeConsump = client:GetNetVar("LastVortalEyeConsump")
			local lastVortHeal = client:GetNetVar("LastVortHeal")
			local healTargetIndex = client:GetNetVar("HealTarget", -1)
			local healTarget = nil

			if healTargetIndex != nil then
				healTarget = Entity(healTargetIndex)
			end

			local stoppedConsumingVortessenceAtRate = client:GetNetVar("StoppedConsumingVortessenceAtRate")
			local isConsumingVortessence = lastVortilampConsump == nil and lastVortalEyeConsump == nil and client:GetVar("IsAttacking", false)

			if !isConsumingVortessence then
				char:AddVortessence((curTime-lastVortessenceRegen)*VORTESSENCE_REGEN_RATE)
				client:SetNetVar("LastVortessenceRegen", curTime)
			end

			--print(tostring(math.floor((curTime-lastVortalEyeConsump)*VORTALEYECONSUMPRATE)).." "..tostring(char:CanConsumeVortessence(VORTALEYECONSUMPRATE)).." "..tostring(math.floor(vortessence)))

			if client:GetNetVar("vortlight", nil) != nil then -- VortiLamp
				local consumptionAmount = (curTime-lastVortilampConsump)*VORTILAMPCONSUMPRATE
				if vortessence > 0 then
					char:ConsumeVortessence(consumptionAmount)
				else
					client:RemoveVortiLamp()
				end

				client:SetNetVar("LastVortilampConsump", curTime)
			end

			if client:GetNetVar("xrayMode", false) then -- Vortal Eye 
				local consumptionAmount = (curTime-lastVortalEyeConsump)*VORTALEYECONSUMPRATE
				if vortessence > 0 then
					char:ConsumeVortessence(consumptionAmount)
				else
					client:EndVortalEye()
				end

				client:SetNetVar("LastVortalEyeConsump", curTime)
			end



			if healTargetIndex != -1 and lastVortHeal != nil and curTime >= lastVortHeal + VORTHEALRATE then -- Health Charge
				
				healTarget = Entity(healTargetIndex)
				
				if char:CanConsumeVortessence(VORTHEALCONSUMPRATE) then
					local maxHealth = healTarget:GetMaxHealth()
					local newHealthAmount = math.Clamp(healTarget:Health() + 1, 0, maxHealth)
					healTarget:SetHealth(newHealthAmount)

					client:SetNetVar("LastVortHeal", curTime)

					if newHealthAmount == maxHealth then
						client:GetActiveWeapon():EndHealing()
					end
					
					char:ConsumeVortessence(VORTHEALCONSUMPRATE)
				end
			end

			

			if healTargetIndex != -1 and lastVortHeal != nil then
				healTarget = Entity(healTargetIndex)
				local vortHealTimeSpan = curTime - lastVortHeal
				
				if char:CanConsumeVortessence(VORTHEALCONSUMPRATE*vortHealTimeSpan) and healTarget:Health() < healTarget:GetMaxHealth() then
					local healthBuildup = healTarget:GetNetVar("healthBuildup", 0)

					healthBuildup = healthBuildup + vortHealTimeSpan*VORTHEALRATE

					if healthBuildup >= 1 then
						local healthPoints = healthBuildup - healthBuildup%1
						healthBuildup = healthBuildup - healthPoints
						healTarget:Heal(healthPoints)
					end

					healTarget:SetNetVar("healthBuildup", healthBuildup)

					client:SetNetVar("LastVortHeal", curTime)
					
					char:ConsumeVortessence(VORTHEALCONSUMPRATE*vortHealTimeSpan)
				else
					client:GetActiveWeapon():EndHealing()
				end
			end
		end
	end
end)


hook.Add( "Think", "VortNPCStunned", function()
	for k, v in pairs(ents.GetAll()) do
		if !v:IsNPC() then
			continue
		else
			if v:GetNetVar("IsStunned", false) then
				tr.Entity:SetSchedule(SCHED_IDLE_STAND)
			end
		end
	end
end)

hook.Add("Think", "point_bugbait_Backup", function()
	local point_bugbait = GetGlobalEntity("point_bugbait", NULL)

	if !GetGlobalInt("bugbaitradius", nil) then
		SetGlobalInt("bugbaitradius", 500)
	end

	if !IsValid(point_bugbait) then -- Does point_bugbait still exist?
		-- Oh shit, no it doesn't.
		MsgC(Color(255, 136, 0), "point_bugbait was not valid, recreating.\n")
		local point_bugbait_new = ents.Create("point_bugbait")
		point_bugbait_new:SetPos(Vector(0, 0, 0))
		point_bugbait_new:SetAngles(Angle(0, 0, 0))
		point_bugbait_new:SetKeyValue("radius", GetGlobalInt("bugbaitradius", 500)) -- This is the radius from the antlion that they can hear bugbait being thrown, I think.
		point_bugbait_new:SetKeyValue("enabled", 1)
		point_bugbait_new:Spawn()
		
		SetGlobalEntity("point_bugbait", point_bugbait_new)
	else
		--point_bugbait:Remove()
	end
end)

hook.Add( "WeaponEquip", "BugbaitDisposition", function( weapon, ply )
	if weapon:GetClass() == "weapon_bugbait" then
		weapon.holder = ply
		for k, v in ipairs(ents.GetAll()) do
			if v:GetClass() == "npc_antlion" or v:GetClass() == "npc_antlion_worker" then
				v:AddEntityRelationship(ply, D_LI, 99)
			end
		end
	end
end)

hook.Add("EntityRemoved", "BugbaitDisposition", function(ent)
	if ent:GetClass() == "weapon_bugbait" then
		local owner = ent.holder
		for k, v in ipairs(ents.GetAll()) do
			if v:GetClass() == "npc_antlion" or v:GetClass() == "npc_antlion_worker" then
				v:AddEntityRelationship(owner, D_HT, 99)
			end
		end
	end
end)

hook.Add("OnEntityCreated", "BugbaitDisposition", function(ent)
	if ent:GetClass() == "npc_antlion" or ent:GetClass() == "npc_antlion_worker" then
		for k, v in ipairs(player.GetAll()) do
			if v:HasWeapon("weapon_bugbait") then
				ent:AddEntityRelationship(v, D_LI, 99)
			end
		end
	end
end)

function Schema:PostPlayerLoadout(client)
	local char = client:GetCharacter()
	if (client:HasBiosignal()) then
		if (client:Team() == FACTION_OTA) then
			client:SetMaxHealth(150)
			client:SetHealth(150)
			--client:SetArmor(150)
		elseif (client:IsScanner()) then
			if (client.ixScanner:GetClass() == "npc_clawscanner") then
				client:SetHealth(200)
				client:SetMaxHealth(200)
			end

			client.ixScanner:SetHealth(client:Health())
			client.ixScanner:SetMaxHealth(client:GetMaxHealth())
			client:StripWeapons()
		else
			--client:SetArmor(self:HasBiosignalRank(client:Name(), "RCT") and 50 or 100)
		end

		local factionTable = ix.faction.Get(client:Team())

		if (factionTable.OnNameChanged) then
			factionTable:OnNameChanged(client, "", client:GetCharacter():GetName())
		end
	end

	local faction = char:GetFaction()
	local class = char:GetClass()
	if faction == FACTION_ALIEN and class != CLASS_FREEVORT and class != CLASS_CHUMTOAD then
		local pillDict = {
			["models/Zombie/Classic.mdl"] = "zombie",
			["models/Zombie/Poison.mdl"] = "zombie_poison",
			["models/Zombie/fast.mdl"] = "zombie_fast",
			["models/headcrabclassic.mdl"] = "headcrab",
			["models/headcrab.mdl"] = "headcrab_fast",
			["models/headcrabblack.mdl"] = "headcrab_poison",
			["models/antlion.mdl"] = "antlion"
		}

		local pill = pillDict[char:GetModel()]
		
		if pill then
			pk_pills.apply(client, pill)
		end
	end

	if char:GetInventory():HasItem("manhack") then
		client:Give("ix_manhack")
	end
end

concommand.Add("fixcids", function()
	local cids = {}
	local fixedCids = {}
	for _, char in pairs(ix.char.loaded) do
		if char:GetFaction() != FACTION_CITIZEN then continue end
		local cid = char:GetData("cid", nil)

		if cid == nil then
			local function giveCID()
				cid = Schema:ZeroNumber(math.random(1, 99999), 5)
				if ix.char.GetByCID(cid) != nil then
					giveCID()
					return
				else
					character:SetData("cid", cid)
				end
			end

			giveCID()
		end

		if !table.HasValue(cids, cid) then
			table.insert(cids, cid)
		else
			local function giveCID()
				cid = Schema:ZeroNumber(math.random(1, 99999), 5)
				if ix.char.GetByCID(cid) != nil then
					giveCID()
					return
				else
					character:SetData("cid", cid)
				end
			end

			giveCID()
			table.insert(cids, cid)
			table.insert(fixedCids, cid)
		end

		if !char:GetData("givenIdentiband", false) then

			local addSuccess = char:GetInventory():Add("identiband", 1, {
				cid = cid
			})

			if addSuccess then
				char:SetData("givenIdentiband", true)
			end

		end 
	end

	print("fixed "..#fixedCids.." cids")
end)

function Schema:PrePlayerLoadedCharacter(client, character, oldCharacter)
	client:SetNetVar("redBlood", false)
	client:SetNetVar("yellowBlood", false)

	if IsValid(client.pk_pill_ent) then
		client.pk_pill_ent.notDead = true
		client.pk_pill_ent:Remove()
	end
end

function Schema:PlayerLoadedCharacter(client, character, oldCharacter)

	/*

	if character:GetFaction() == FACTION_CITIZEN then
		local cid = character:GetData("cid", nil)
		if cid != nil then
			if !character:GetData("givenIdentiband", false) then

				local addSuccess = character:GetInventory():Add("identiband", 1, {
					cid = cid
				})

				if addSuccess then
					character:SetData("givenIdentiband", true)
				end
			end 
		end
	end

	*/

	if tonumber(character:GetCreateTime()) < 1651420800 and !character:GetData("HasBeenUpdated", false) then
		net.Start("prCharacterUpdate")
			net.WriteString(ix.util.GenerateIdempKey())
		net.Send(client)
	end
	

	client:SetNetVar("redBlood")
	client:SetNetVar("yellowBlood")
	/*

	if character:GetData("yellowBlood", false) then
		client:SetNetVar("yellowBlood", true)
	end

	if character:GetData("redBlood", false) then
		client:SetNetVar("redBlood", true)
	end
	*/

	local faction = character:GetFaction()
	local class = character:GetClass()

	if (faction == FACTION_CITIZEN) then -- Combine character loading notifications
		self:AddCombineDisplayMessage("@cCitizenLoaded", Color(255, 100, 255, 255))
	elseif (client:IsCombine()) then
		client:AddCombineDisplayMessage("@cCombineLoaded")
	end

	if faction == FACTION_ALIEN and class == CLASS_FREEVORT then
		client:SetNetVar("LastVortessenceRegen", CurTime()) -- Doing this makes it so there's not an immediate vortessence point given on character switch.
		client:SetVortessence(200)
	end

	local bleedTimerName = "ixBleed"..client:SteamID()

	if oldCharacter != nil then

		local oldFaction = oldCharacter:GetFaction()
		local oldClass = oldCharacter:GetClass()

		if oldFaction == FACTION_ALIEN and class == CLASS_FREEVORT then 
			client:SetNetVar("LastVortessenceRegen", nil)
		end

			
		if timer.Exists(bleedTimerName) then
			timer.Remove(bleedTimerName)
		end

	end

	local limbHealth = character:GetAllLimbHealth()

	local leftLegBroken, rightLegBroken = limbHealth[HITGROUP_LEFTLEG] == 0, limbHealth[HITGROUP_RIGHTLEG] == 0

	local defWalkSpeed = ix.config.Get("walkSpeed", 100)
	if leftLegBroken != rightLegBroken then
		client:SetWalkSpeed(80)
		client:SetRunSpeed(character:GetAttrRunSpeed() - 20)
	elseif leftLegBroken and rightLegBroken then
		client:SetWalkSpeed(90)
		client:SetRunSpeed(character:GetAttrRunSpeed() - 40)
	else
		client:SetWalkSpeed(defWalkSpeed)
		client:SetRunSpeed(character:GetAttrRunSpeed())
	end


	if character:GetFaction() == FACTION_ALIEN and character:GetClass() == CLASS_CHUMTOAD then
        client:SetJumpPower(300)
		client:SetMaxHealth(5)
		client:SetHealth(5)
	else
		client:SetJumpPower(Lerp(character:GetSkill("acrobatics")/100, 180, 200))
	end

	if faction == FACTION_MPF then
		client:SetPassiveEmitTimer()
	end

	local bleedTime = character:GetData("BleedTime", -1)
	local maxBleedTime = ix.config.Get("maxBleedTime", 30)

	-- We readd bleeding won character load in case the player
	-- changes characters while bleeding.
	if bleedTime != -1 and bleedTime < maxBleedTime then
		-- timer.Remove marks the timer to be removed in the next frame, so if
		-- we remove the past bleed timer from the previous character, we need to
		-- wait until the next frame/tick to readd the timer.
		timer.Simple(0, function()
				
		end)
	end

	local limbHealTimerName = "ixLimbHeal"..client:SteamID64()

	if timer.Exists(limbHealTimerName) then
		timer.Remove(limbHealTimerName)
	end

	timer.Simple(0, function()
		timer.Create(limbHealTimerName, 60, 0, function()
			limbHealths = character:GetAllLimbHealth()
			for limbName, health in pairs(limbHealths) do
				if health < 100 then
					limbHealths[limbName] = health + 1
				end
			end

			character:SetAllLimbHealth(limbHealths)
		end)
	end)

end

function Schema:CharacterVarChanged(character, key, oldValue, value)
	local client = character:GetPlayer()
	if (key == "name") then
		local factionTable = ix.faction.Get(client:Team())

		if (factionTable.OnNameChanged) then
			factionTable:OnNameChanged(client, oldValue, value)
		end
	end
end

function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	local factionTable = ix.faction.Get(client:Team())

	if (factionTable.runSounds and client:IsRunning()) then
		client:EmitSound(factionTable.runSounds[foot])
		return true
	end

	if (factionTable.walkSounds and !client:IsRunning()) then
		client:EmitSound(factionTable.walkSounds[foot])
		return true
	end

	client:EmitSound(soundName)
	return true
end

function Schema:PlayerSpawn(client)
	client:SetCanZoom(client:HasBiosignal())
end

hook.Add("Think", "quotaReset", function()
	-- sorry.
	if CurTime() > 5 then
		local time = os.time()
		local timeData = os.date("!*t", time)

		if timeData.hour == 23 and timeData.min == 0 and (Schema.NumRations > 0 or Schema.NumWorkCycles > 0) then
			Schema.NumRations = 0
			Schema.NumWorkCycles = 0
		end
	end
end)

function Schema:PlayerDeath(client, inflicter, attacker)
	if (client:HasBiosignal()) then
		local location = client:GetArea()
		local char = client:GetCharacter()

		local dispatchFolder = "npc/overwatch/radiovoice/"

		local facStrings = {
			[FACTION_MPF] = "Protection Team unit",
			[FACTION_OTA] = "Transhuman functionary",
			
			[FACTION_OSA] = "Synthetic functionary",
			[FACTION_ADMIN] = "Ministry member",
			[FACTION_CONSCRIPT] = "Human Military functionary"
			
		}

		local facString = facStrings[char:GetFaction()] or "functionary"

		print("location", location, type(location), location == "", location != "")

		local waypoint = ents.Create("ix_cmbwaypoint")
		waypoint:SetPos(client:GetPos() + Vector(0, 0, 51))
		waypoint:SetAngles(angle_zero)
		waypoint:Spawn()
		waypoint:SetMessage("Biosignal Lost", WP_WARNING)

		if (IsValid(client.ixScanner) and client.ixScanner:Health() > 0) then
			client.ixScanner:TakeDamage(999)
		end
		

		local sounds = {"npc/overwatch/radiovoice/on1.wav", "npc/overwatch/radiovoice/lostbiosignalforunit.wav"}
		
		local chance = math.random(1, 7)

		local designation
		local squadInfo = char:GetSquad()

		if squadInfo then
			local squadNum = 0
			for k, v in pairs(ix.squadsystem.squads[squadInfo]) do
				if istable(v) then
					if v.member == client then
						squadNum = k
					end
				end
			end
			designation = string.format("%s-%s (%s)", squadInfo, squadNum, client:GetName())
			sounds[#sounds + 1] = dispatchFolder..string.lower(squadInfo)..".wav"
			sounds[#sounds + 1] = dispatchFolder..(Schema:AlphaNum(tostring(squadNum)	))..".wav"
			sounds[#sounds + 1] = "npc/overwatch/radiovoice/remainingunitscontain.wav"
		else
			designation = client:GetName()
			local digits = string.sub(client:GetName(), string.find(client:GetName(), "%d%d%d%d%d"))
			for i = 1, #digits do
				sounds[#sounds + 1] = "npc/overwatch/radiovoice/"..Schema:AlphaNum(digits:sub(i, i))..".wav"
			end
			sounds[#sounds + 1] = "npc/overwatch/radiovoice/reinforcementteamscode3.wav"
		end

		sounds[#sounds + 1] = "npc/overwatch/radiovoice/off4.wav"

		for k, v in ipairs(player.GetAll()) do
			if (v:HasBiosignal()) then
				ix.util.EmitQueuedSounds(v, sounds, 2, nil, v == client and 100 or 80)
			end
		end

		if location != "" then
			self:AddCombineDisplayMessage(string.format("Lost biosignal for %s %s at %s.", facString , designation, location), Color(255, 0, 0, 255))
		else
			self:AddCombineDisplayMessage(string.format("Lost biosignal for %s %s.", facString, designation), Color(255, 0, 0, 255))
		end
	end
end

function Schema:PlayerNoClip(client)
	if (IsValid(client.ixScanner)) then
		return false
	end
end

function Schema:EntityTakeDamage(entity, dmgInfo)
	if (IsValid(entity.ixPlayer) and entity.ixPlayer:IsScanner()) then
		entity.ixPlayer:SetHealth( math.max(entity:Health(), 0) )

		hook.Run("PlayerHurt", entity.ixPlayer, dmgInfo:GetAttacker(), entity.ixPlayer:Health(), dmgInfo:GetDamage())
	end
end

function Schema:PlayerHurt(client, attacker, health, damage)
	if (health <= 0) then
		return
	end

	if (client:HasBiosignal() and (client.ixTraumaCooldown or 0) < CurTime()) then
		local text = "External"

		if (damage > 50) then
			text = "Severe"
		end

		client:AddCombineDisplayMessage("@cTrauma", Color(255, 0, 0, 255), text)

		if (health < 25) then
			client:AddCombineDisplayMessage("@cDroppingVitals", Color(255, 0, 0, 255))
		end

		client.ixTraumaCooldown = CurTime() + 15
	end
end

function Schema:PlayerStaminaLost(client)
	client:AddCombineDisplayMessage("@cStaminaLost", Color(255, 255, 0, 255))
end

function Schema:PlayerStaminaGained(client)
	client:AddCombineDisplayMessage("@cStaminaGained", Color(0, 255, 0, 255))
end

function Schema:GetPlayerPainSound(client)
	if (client:HasBiosignal()) then
		local sound = "NPC_MetroPolice.Pain"

		if (Schema:HasBiosignalRank(client:Name(), "SCN")) then
			sound = "NPC_CScanner.Pain"
		elseif (Schema:HasBiosignalRank(client:Name(), "SHIELD")) then
			sound = "NPC_SScanner.Pain"
		end

		return sound
	end
end

function Schema:GetPlayerDeathSound(client)
	if (client:HasBiosignal()) then
		local sound = "NPC_MetroPolice.Die"

		if (Schema:HasBiosignalRank(client:Name(), "SCN")) then
			sound = "NPC_CScanner.Die"
		elseif (Schema:HasBiosignalRank(client:Name(), "SHIELD")) then
			sound = "NPC_SScanner.Die"
		end

		for k, v in ipairs(player.GetAll()) do
			if (v:HasBiosignal()) then
				v:EmitSound(sound)
			end
		end

		return sound
	end
end

function Schema:OnNPCKilled(npc, attacker, inflictor)
	if (IsValid(npc.ixPlayer)) then
		hook.Run("PlayerDeath", npc.ixPlayer, inflictor, attacker)
	end
end

function Schema:PlayerMessageSend(speaker, chatType, text, anonymous, receivers, rawText)
	if chatType == "ic" or chatType == "w" or chatType == "y" then
		for k, v in ipairs(receivers) do
			local char = v:GetCharacter()

			if char:HasPerk("easilydistracted") then
				char:AddEffect("distracted")
			end
		end
	end

	-- here and below are changes to message contents.
	-- if you don't have aything to change in the message contents, put them ABOVE this comment block.
	if chatType == "radio" then
		for k, v in ipairs(ents.FindByClass("ix_testent7")) do
			if v:GetNetVar("On", false) and v:GetNetVar("Battery", 0) > 0 then
				local plyFreq = tostring(speaker:GetCharacter():GetData("frequency", nil))
				print(plyFreq, v.frequency, type(plyFreq), type(v.frequency))
				if v:GetPos():Distance(speaker:GetPos()) <= 5000 and plyFreq != nil and v.frequency != nil and plyFreq == v.frequency then
					v:SetNetVar("Battery", v:GetNetVar("Battery", 0) - 0.5)
					local msgText = ""
					local numIterations = math.random(4, 32)
					for i = 1, numIterations do
						if math.random(1, 5) == 1 and i != 1 and i != numIterations and msgText[i - 1] == "#" then
							msgText = msgText.." "
						else
							msgText = msgText.."#"
						end
					end
					msgText = msgText.."."

					return msgText
				end
			end
		end

		for k, v in ipairs(ents.FindByClass("ix_testent5")) do
			if v:GetNetVar("On", false) and v:GetNetVar("Battery", 0) > 0 then
				local plyFreq = tostring(speaker:GetCharacter():GetData("frequency", nil))
				print(plyFreq, v.frequency, type(plyFreq), type(v.frequency))
				if v:GetPos():Distance(speaker:GetPos()) <= 500 and plyFreq != nil and v.frequency != nil and plyFreq == v.frequency then
					v:SetNetVar("Battery", v:GetNetVar("Battery", 0) - 1)
					local msgText = ""
					local numIterations = math.random(4, 32)
					for i = 1, numIterations do
						if math.random(1, 5) == 1 and i != 1 and i != numIterations and msgText[i - 1] == "#" then
							msgText = msgText.." "
						else
							msgText = msgText.."#"
						end
					end
					msgText = msgText.."."

					return msgText
				end
			end
		end
	end

	if (chatType == "ic" or chatType == "w" or chatType == "y" or chatType == "dispatch" or chatType == "radio") then

		local class = self.voices.GetClass(speaker)

		for k, v in ipairs(class) do
			local info = self.voices.Get(v, rawText)

			if (info) then
				local volume = 80

				if (chatType == "w") then
					volume = 60
				elseif (chatType == "y") then
					volume = 150
				end


				if (info.sound) then
					if (info.global) then
						netstream.Start(nil, "PlaySound", info.sound)
					else
						local sounds = {info.sound}

						if (speaker:IsCombine()) then
							if speaker:GetCharacter():GetFaction() == FACTION_OTA then
								speaker.bTypingBeep = nil
								sounds[#sounds + 1] = "npc/combine_soldier/vo/off"..math.random(1, 3).."_episodic.wav"
							else
								speaker.bTypingBeep = nil
								sounds[#sounds + 1] = "NPC_MetroPolice.Radio.Off"
							end
						end

						ix.util.EmitQueuedSounds(speaker, sounds, nil, nil, volume)

						if chatType == "radio" then
							if speaker:GetCharacter():GetFaction() == FACTION_OTA then
								table.insert(sounds, 1, "npc/combine_soldier/vo/on"..math.random(1, 3).."_episodic.wav")
							else
								table.insert(sounds, 1, "NPC_MetroPolice.Radio.On")
							end
							
							local speakerFreq = speaker:GetCharacter():GetData("frequency")
							local traceEnt = speaker:GetEyeTrace().Entity
	
							local speakerFacingRadio = IsValid(traceEnt) and 
							traceEnt:GetClass() == "ix_transrecradio" and 
							traceEnt:GetNetVar("On", false) and 
							traceEnt.frequency != nil and 
							speaker:GetPos():Distance(traceEnt:GetPos()) <= 96
					
							if speakerFacingRadio then
								speakerFreq = traceEnt.frequency
							end

							for k, v in ipairs(player.GetAll()) do
								if v:GetCharacter():GetData("frequency") == speakerFreq and v:GetVar("enabled", false) then
									ix.util.EmitQueuedSounds(v, sounds, nil, nil, volume)
								end
							end

							for k, v in ipairs(ents.FindByClass("ix_transrecradio")) do
								if v.frequency == speakerFreq and v:GetNetVar("On", false) then
									ix.util.EmitQueuedSounds(v, sounds, nil, nil, volume)
								end
							end
						end
					end
				end

				if (speaker:IsCombine()) then
					return string.format("<:: %s ::>", info.text)
				else
					return info.text
				end
			end
		end

		if (speaker:HasBiosignal()) then
			return string.format("<:: %s ::>", text)
		end
	end

	
end

function Schema:CanPlayerJoinClass(client, class, info)
	if (client:IsRestricted()) then
		client:Notify("You cannot change classes when you are restrained!")

		return false
	end
end

local SCANNER_SOUNDS = {
	"npc/combot/cbot_battletalk1.wav",
	"npc/combot/cbot_battletalk2.wav",
	"npc/combot/cbot_battletalk3.wav",
	"npc/combot/cbot_battletalk4.wav",
	"npc/combot/cbot_servochatter2.wav",
	"npc/combot/cbot_servochatter3.wav",
	"npc/combot/cbot_servocurious.wav",
	"npc/combot/cbot_alert1.wav",
	"npc/combot/cbot_mechanism1.wav",
	"npc/scanner/cbot_servoscared.wav",
	"npc/scanner/cbot_servochatter.wav"
}

function Schema:KeyPress(client, key)
	if (IsValid(client.ixScanner) and (client.ixScannerDelay or 0) < CurTime()) then
		local source

		if (key == IN_USE) then
			source = SCANNER_SOUNDS[math.random(1, #SCANNER_SOUNDS)]
			client.ixScannerDelay = CurTime() + 1.75
		elseif (key == IN_RELOAD) then
			source = "npc/scanner/scanner_talk"..math.random(1, 2)..".wav"
			client.ixScannerDelay = CurTime() + 10
		elseif (key == IN_WALK) then
			if (client:GetViewEntity() == client.ixScanner) then
				client:SetViewEntity(NULL)
			else
				client:SetViewEntity(client.ixScanner)
			end
		end

		if (source) then
			client.ixScanner:EmitSound(source)
		end
	end
end

function Schema:PlayerSpawnObject(client)
	if (client:IsRestricted() or IsValid(client.ixScanner)) then
		return false
	end
end

hook.Add("InventoryItemAdded", "AddSerialNum", function(oldInv, inventory, item)
	if (item:GetData("serialNum", nil) == nil and item.canSerial) then
		if (item.cmbWeapon) then
			local serialChars = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "1", "1", "1", "2", "2", "2", "2", "3", "3", "3", "3", "4", "4", "4", "4", "5", "5", "5", "5", "6", "6", "6", "6", "7", "7", "7", "7", "8", "8", "8", "8", "9", "9", "9", "9", "0", "0", "0", "0"}
			local serialNum = "Serial Number: CMB-"
			for i = 1, 8 do 
				serialNum = serialNum..serialChars[math.random(1, #serialChars)]
			end

			item:SetData("serialNum", serialNum)
			return
		else
			local serialChars = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "1", "1", "1", "2", "2", "2", "2", "3", "3", "3", "3", "4", "4", "4", "4", "5", "5", "5", "5", "6", "6", "6", "6", "7", "7", "7", "7", "8", "8", "8", "8", "9", "9", "9", "9", "0", "0", "0", "0"}
			local serialNum = "Serial Number: "
			for i = 1, 10 do 
				serialNum = serialNum..serialChars[math.random(1, #serialChars)]
			end

			item:SetData("serialNum", serialNum)
			return
		end
	end
end)

function Schema:PlayerSpray(client)
	return false
end

 -- Damage scaling for different entities..
 -- I tried to find switch case stuff for lua, but I couldn't find any.
 -- If there's something I can do that's more efficient than an elseif block, let me know.

hook.Add( "EntityTakeDamage", "NoZombieDamage", function( target, dmginfo ) -- Makes it so punching zombies with the fists is balanced.
	if (dmginfo:GetAttacker():IsPlayer() and dmginfo:GetInflictor():GetClass() == "ix_hands") then -- I have no way of doing a switch case here. If you have a better solution, let me know.
		if (target:GetClass() == "npc_zombie") then
			dmginfo:ScaleDamage( 0.05 ) 
		elseif (target:GetClass() == "npc_fastzombie") then
			dmginfo:ScaleDamage( 0.1 ) 
		elseif (target:GetClass() == "npc_poisonzombie") then
			dmginfo:ScaleDamage( 0 )
		elseif (target:GetClass() == "npc_headcrab") then
			dmginfo:ScaleDamage( 0.2 ) 
		elseif (target:GetClass() == "npc_headcrab_fast") then
			dmginfo:ScaleDamage( 0.2 ) 
		elseif (target:GetClass() == "npc_headcrab_black") then
			dmginfo:ScaleDamage( 0.1 ) 
		elseif (target:GetModel() == "models/opfor/gonome.mdl") then
			dmginfo:ScaleDamage( 0 )
		end
	end
	
end )

hook.Add( "EntityTakeDamage", "NoPhysicsPropDamage", function( target, dmginfo ) -- Makes it so you can't break physics props (which includes the vents) by punching them.

	if (dmginfo:GetAttacker():IsPlayer() and target:GetClass() == "prop_physics" and dmginfo:GetAttacker():GetActiveWeapon():GetClass() == "ix_hands") then
		dmginfo:ScaleDamage( 0 )
	end

end )

local buttonTexts = {
	[5710] = "Attention, City 17, judgement waiver is now in effect. Please use discretion and return to your homes.",
	[5711] = "Attention, City 17, judgement waiver is no longer in effect. You may now leave your apartments.",
	[6075] = "Attention, City 17, the seventh gate is now unsealed. Please, use caution.",
	[6076] = "Attention, City 17, the seventh gate is once again sealed. Access is no longer permitted.",
	[5801] = "Attention, City 17, working class citizens please proceed to warehouse 3 immediately.",
	[4353] = "Attention, City 17, rations are now available at the Ration Distribution Terminal.",
	[4354] = "Attention, City 17, the Ration Distribution Terminal is now offline."
}

function Schema:KeyRelease(client, key )
	if key != IN_USE then return end
	local tr = client:GetEyeTrace()
	local ent = tr.Entity

	if !IsValid(ent) or tr.StartPos:Distance(tr.HitPos) > 96 then return end
	
	local creationID = ent:MapCreationID()
	local text = buttonTexts[creationID]
	if text then
		ix.chat.Send(client, "broadcasts", text, false)
		if creationID == 4353 then
			Schema.NumRations = Schema.NumRations + 1
		elseif creationID == 5801 then
			Schema.NumWorkCycles = Schema.NumWorkCycles + 1
		end
	end

	if ent:IsDoor() and IsValid(ent.ixLock) and client:KeyDown(IN_SPEED) then
		ent.ixLock:Use(client)
		return
	end
end

net.Receive("prTimeclock", function(len, ply)
	local char = ply:GetCharacter()
	local businessName = net.ReadString()
	
	local timeClocks = char:GetData("TimeClocks", {})
	local clockTime = timeClocks[businessName or "BUSINESS_GENERIC"]
	local timeClockHistory = char:GetData("TimeClockHistory", {})
	if !timeClockHistory[businessName] then
		timeClockHistory[businessName] = {}
	end

	local curTime = os.time()

	


	if clockTime then
		timeClocks[businessName or "BUSINESS_GENERIC"] = nil

		local businessHistory = timeClockHistory[businessName]

		local currentShift = businessHistory[#businessHistory]

		currentShift["out"] = curTime
		local uglyLen = (currentShift["out"] - currentShift["in"])/(60*60)
		currentShift["hours"] = math.floor(uglyLen*100)/100

		timeClockHistory[businessName][#businessHistory] = currentShift
	else
		timeClocks[businessName or "BUSINESS_GENERIC"] = curTime

		local currentShift = {
			["in"] = curTime,
			["date"] = os.date("%m/%d", curTime)
		}

		local businessHistory = timeClockHistory[businessName]

		timeClockHistory[businessName][#businessHistory + 1] = currentShift
	end


	
	char:SetData("TimeClocks", timeClocks)
	char:SetData("TimeClockHistory", timeClockHistory)

	net.Start("prTimeclock")
		net.WriteBool(true)
	net.Send(ply)
	
end)
	
net.Receive("ixCombatAct", function(len, ply)
	local sequence = net.ReadString()
	--ply:ForceSequence(sequence)
end)

net.Receive("prAptAction", function(len, ply)
	local char = ply:GetCharacter()
	local trEnt = ply:GetEyeTrace().Entity

	local function respond(response)
		if response == APTACT_SVSUCCESS then
			local nicerApts = table.Copy(ix.apartments.list[trEnt.buildingName])

			for k, apt in pairs(nicerApts) do
				apt.niceNames = {}
				for index, CID in ipairs(apt.tenants) do
					apt.niceNames[index] = ix.char.GetByCID(CID):GetName()
				end
			end
			
			local apartments = util.Compress(util.TableToJSON(nicerApts))

			net.Start("prAptResponse")
				net.WriteUInt(response, 32)
				net.WriteUInt(#apartments, 32)
				net.WriteData(apartments) 
			net.Send(ply)
		else
			net.Start("prAptResponse")
				net.WriteUInt(response, 32)
			net.Send(ply)
		end
	end

	if char == nil or char:GetFaction() != FACTION_MPF then
		return
	end

	local foundEnt = false
	for k, v in ipairs(ents.FindByClass("ix_testent6")) do
		if v:GetPos():Distance(ply:GetPos()) <= 96 then
			foundEnt = v
			break
		end
	end

	if !foundEnt then
		return
	end
	local action = net.ReadUInt(32)

	print("CALLING", action)

	if action == APTACT_ADDTENANT then 
		local CID = net.ReadString() 
		local aptName = net.ReadString()

		if CID == nil then
			return
		end

		local apt = ix.apartments.list[trEnt.buildingName][aptName]
		if ix.char.GetByIIN(CID) == nil then
			respond(APACT_INVALIDINDV)
		elseif apt == nil then
			respond(APTACT_INVALIDAPT)
		elseif #apt.tenants >= apt.maxTenants then
			respond(APTACT_INVALIDAPT)
		elseif ix.apartments.IsTenant(aptName, trEnt.buildingName, CID) then
			respond(APTACT_ALREADYASSIGNED)
		else
			ix.apartments.AddTenant(aptName, trEnt.buildingName, CID)
			respond(APTACT_SVSUCCESS)

		end

	elseif action == APTACT_REMOVETENANT then
		local CID = net.ReadString() 
		local aptName = net.ReadString()

		if CID == nil then
			return
		end

		local apt = ix.apartments.list[trEnt.buildingName][aptName]

		if ix.char.GetByIIN(CID) == nil then
			respond(APTACT_INVALIDINDV)
		elseif apt == nil then
			respond(APTACT_INVALIDAPT)
		elseif #apt.tenants >= apt.maxTenants then
			respond(APTACT_INVALIDAPT)
		elseif !ix.apartments.IsTenant(aptName, trEnt.buildingName, CID) then
			respond(APTACT_INVALIDTENANT)
		else
			ix.apartments.RemoveTenant(aptName, trEnt.buildingName, CID)
			respond(APTACT_SVSUCCESS)
		end
		
	elseif action == APTACT_PRINTKEY then 
		local aptName = net.ReadString()

		local apt = ix.apartments.list[trEnt.buildingName][aptName]
		if apt == nil then
			respond(APTACT_INVALIDAPT)
		else
			ix.item.Spawn("aptkey", trEnt:GetPos() + trEnt:GetForward(), nil, nil, {
				building = trEnt.buildingName,
				apartment = aptName
			})
			respond(APTACT_SVSUCCESS)
		end


	elseif action == APTACT_CALLRES then
		print("HERE", ix.ranks.CCA["EpU"])
		if (char:GetFaction() == FACTION_MPF and char:GetRankVal() >= ix.ranks.CCA["EpU"]) or char:GetFaction() == FACTION_OTA or char:GetFaction() == FACTION_ADMIN then
			ix.chat.Send(ply, "dispatch", "Attention: All residents of housing block "..trEnt.buildingName..", report to your housing block immediately.")
		else
			respond(APTACT_BADRANK)
		end
	end
end)

net.Receive("ixRadioOptSubmit", function(len, ply)
	local freqText = net.ReadString()
	local volume = net.ReadInt(32)
	local traceEnt = ply:GetEyeTrace().Entity
	local distance = ply:GetPos():Distance(traceEnt:GetPos())

	if !IsValid(traceEnt) or traceEnt:GetClass() != "ix_transrecradio" or distance > 400 then
		ply:Notify("You are not looking at the radio!")
		return
	elseif distance > 96 then 
		ply:Notify("You are not close enough to the radio")
		return
	else
		local freqNum = tonumber(freqText)
		if (string.find(freqText, "^%d%d%d%.%d$")) and freqNum != nil and freqNum <= 299.9 and freqNum >= 100.0 then
			traceEnt.frequency = freqNum
		else 
			ply:Notify("That is not a valid frequency!")
		end

		volume = math.Clamp(volume, 0, 100)
		traceEnt.volume = volume
		traceEnt:EmitSound("buttons/lever7.wav", 50, math.random(170, 180), 0.25)
		ply:Notify("You have frequently updated the radio's settings.")

	end

end)


hook.Add("OnNPCKilled", "SpawnPhysicsCorpse", function( npc, attacker, inflictor )
	
	if npc:GetClass() == "npc_headcrab" then 
	elseif npc:GetClass() == "npc_headcrab_black" then
	elseif npc:GetClass() == "npc_headcrab_fast" then
	elseif npc:GetClass() == "npc_antlion" then
	elseif npc:GetClass() == "npc_antlionguard" then
	elseif npc:GetClass() == "npc_antlionguardian" then
	elseif npc:GetClass() == "npc_antlion_worker" then
	elseif npc:GetModel() == "models/half-life/houndeye.mdl" then
	elseif npc:GetModel() == "models/half-life/controller.mdl" then
	elseif npc:GetModel() == "models/half-life/chumtoad.mdl" then
	elseif npc:GetModel() == "models/half-life/panthereye.mdl" then
	elseif npc:GetModel() == "models/opfor/pit_drone.mdl" then
	elseif npc:GetModel() == "models/opfor/shockroach.mdl" then
	elseif npc:GetModel() == "models/half-life/baby_headcrab.mdl" then
	elseif npc:GetModel() == "models/half-life/bullsquid.mdl" then
	elseif npc:GetModel() == "models/half-life/leech.mdl" then
	elseif npc:GetModel() == "models/devilsquid.mdl" then
	elseif npc:GetModel() == "models/frostsquid.mdl" then
	elseif npc:GetModel() == "models/poisonsquid.mdl" then
	elseif npc:GetModel() == "models/weapons/half-life/p_snark.mdl" then
	elseif npc:GetModel() == "models/opfor/voltigore.mdl" then
	elseif npc:GetModel() == "models/vortigaunt.mdl" then
	elseif npc:GetModel() == "models/vortigaunt_slave.mdl" then
	elseif npc:GetModel() == "models/ichthyosaur_hlr.mdl" then
	else 
		return
	end

	npc:SetShouldServerRagdoll(true)

end )

hook.Add( "PlayerUse", "AlienCarving", function( client, ent ) -- Makes it so you can't break physics props (which includes the vents) by punching them.

	if !IsFirstTimePredicted() then return end
	if ent:GetClass() == "prop_ragdoll" then

		-- Makes sure the entity is actually something carvable.
		-- "mmmmm, springs and cotton" -Mr. Chief
		if ent:GetModel() == "models/headcrabclassic.mdl" then 
		elseif ent:GetModel() == "models/headcrabblack.mdl" then
		elseif ent:GetModel() == "models/headcrab.mdl" then --Fast Headcrab
		elseif ent:GetModel() == "models/antlion.mdl" then
		elseif ent:GetModel() == "models/antlion_guard.mdl" and ent:GetSkin() == 0 then
		elseif ent:GetModel() == "models/antlion_guard.mdl" and ent:GetSkin() == 1 then
		elseif ent:GetModel() == "models/antlion_worker.mdl" then
		elseif ent:GetModel() == "models/half-life/houndeye.mdl" then
		elseif ent:GetModel() == "models/half-life/controller.mdl" then
		elseif ent:GetModel() == "models/half-life/chumtoad.mdl" then
		elseif ent:GetModel() == "models/half-life/panthereye.mdl" then
		elseif ent:GetModel() == "models/opfor/pit_drone.mdl" then
		elseif ent:GetModel() == "models/opfor/strooper.mdl" then
		elseif ent:GetModel() == "models/half-life/bullsquid.mdl" then
		elseif ent:GetModel() == "models/devilsquid.mdl" then
		elseif ent:GetModel() == "models/frostsquid.mdl" then
		elseif ent:GetModel() == "models/poisonsquid.mdl" then
		else
			return
		end

		local inv = client:GetCharacter():GetInventory()
		

		--[[ Possibly todo someday. Add in rolls for what items you get.

		local agiBonus = client:GetCharacter():GetAttribute("agi", 0)
		local safetyRoll = tostring(math.random(0, 100))

		]]--

		-- Makes sure entity hasn't already been carved.
		if ent.beenCarved != nil and ent.beenCarved then
        	client:Notify("This has already been carved!")
        	return
        end


		-- Makes sure the character has at least one of these items.
		-- Not all items listed are implemented.
		if inv:HasItem("knife") then
		elseif inv:HasItem("axe") then
		elseif inv:HasItem("hatchet") then	
		elseif inv:HasItem("empty_glass_bottle") then
		elseif inv:HasItem("kitchenknife") then
		elseif inv:HasItem("dull_kitchenknife") then
		elseif inv:HasItem("pairingknife") then
		elseif inv:HasItem("cleaver") then
		elseif inv:HasItem("ndl_pliers") then -- needle-nosed pliers
		elseif inv:HasItem("stone_hatchet") then
		else
			return
			client:Notify("You don't have a tool to carve this with!")
		end

		-- Makes sure two people can't carve at the same time.
		if ent.beingCarved then
			client:Notify("This is already being carved!")
			return
		end

		ent.beingCarved = true

		client:SetAction("Carving...", 8)
		client:DoStaredAction(ent, function()
			local loot = GetLoot()
			if (!inv:Add(loot)) then
                ix.item.Spawn(loot, client)
            end
			ent.beenCarved = true
			ent.beingCarved = false
		end, 8, function()
			ent.beingCarved = false
			client:SetAction(nil)
		end, 96)



		-- This isn't and has no reason to be referenced
		-- anywhere else, it's just for code compactness.
		function GetLoot()
			if ent:GetModel() == "models/headcrabclassic.mdl" then 
				return "raw_headcrab_meat"
	        elseif ent:GetModel() == "models/headcrabblack.mdl" then
	    		return "raw_poisonheadcrab_meat"
	        elseif ent:GetModel() == "models/headcrab.mdl" then --Fast Headcrab
	    		return "raw_fastheadcrab_meat"
	        elseif ent:GetModel() == "models/antlion.mdl" then
	    		return "raw_antlion_meat"
	        elseif ent:GetModel() == "models/antlion_guard.mdl" and ent:GetSkin() == 0 then
	        	return "raw_antlionguard_meat"
	        elseif ent:GetModel() == "models/antlion_guard.mdl" and ent:GetSkin() == 1 then
	    		return "raw_antlionguardian_meat"
	        elseif ent:GetModel() == "models/antlion_worker.mdl" then
	    		return "raw_antlionworker_meat"
	        elseif ent:GetModel() == "models/half-life/houndeye.mdl" then
	        	local lootRoll = math.random(0, 1)
	        	if lootRoll == 0 then
	    			return "raw_houndeye_meat"
	    		else
	    			return "raw_houndeye_leg"
	    		end
	        elseif ent:GetModel() == "models/half-life/controller.mdl" then
	    		return "raw_controller_meat"
	        elseif ent:GetModel() == "models/half-life/chumtoad.mdl" then
	    		return "raw_chumtoad_meat"
	        elseif ent:GetModel() == "models/half-life/panthereye.mdl" then
	    		local lootRoll = math.random(0, 1)
	        	if lootRoll == 0 then
	    			return "raw_panthereye_meat"
	    		else
	    			return "raw_panthereye_leg"
	    		end
	        elseif ent:GetModel() == "models/opfor/pit_drone.mdl" then
	    		return "raw_pitdrone_meat"
	    	elseif ent:GetModel() == "models/opfor/strooper.mdl" then
	    		local lootRoll = math.random(0, 1)
	        	if lootRoll == 0 then
	    			return "raw_strooper_meat"
	    		else
	    			return "raw_strooper_arm"
	    		end
	        elseif ent:GetModel() == "models/opfor/shockroach.mdl" then
	    		return "NOT_DONE_YET"
	        elseif ent:GetModel() == "models/half-life/baby_headcrab.mdl" then
	    		return "NOT_DONE_YET"
	        elseif ent:GetModel() == "models/half-life/bullsquid.mdl" then
	    		return "raw_bullsquid_meat"
	        elseif ent:GetModel() == "models/devilsquid.mdl" then
	    		return "raw_pyrosquid_meat"
	        elseif ent:GetModel() == "models/frostsquid.mdl" then
	    		return "raw_cryosquid_meat"
	        elseif ent:GetModel() == "models/poisonsquid.mdl" then
	    		return "raw_virosquid_meat"
	        elseif ent:GetModel() == "models/opfor/voltigore.mdl" then
	    		return "NOT_DONE_YET"
	        elseif ent:GetModel() == "models/vortigaunt.mdl" then
	    		return "NOT_DONE_YET"
	        elseif ent:GetModel() == "models/vortigaunt_slave.mdl" then
	            return "NOT_DONE_YET"
	        elseif ent:GetModel() == "models/ichthyosaur_hlr.mdl" then
	            return "NOT_DONE_YET"
	        end
		end
	end
	
end )

hook.Add("Think", "AirDamage", function()
	
	for _, ply in pairs(player.GetAll()) do
		if ply:GetCharacter() != nil then
			if not ply:Alive() then continue end

			local canBreathe = false
			local char = ply:GetCharacter()
			local faction = char:GetFaction()

			if !canBreathe then
				canBreathe = char:IsFactionBreathable()
			end

			if !canBreathe then
				if ply:GetNoDraw() == true then canBreathe = true end
			end

			if (!canBreathe) then
				for k, v in pairs(ents.FindByClass("ix_citizenairvent")) do
					if ply:GetPos():DistToSqr(v:GetPos()) < 325 * 325 then
						canBreathe = true
						break
					end
				end
			end

			if (!canBreathe) then 
				for k, v in pairs(ents.FindByClass("ix_airvent")) do
					if ply:GetPos():DistToSqr(v:GetPos()) < 325 * 325 then
						canBreathe = true
						break
					end
				end
			end

			local inv = ply:GetCharacter():GetInventory()

			if (!canBreathe and inv:HasItem("respirator", { ["equip"] = true })) then 
				canBreathe = true
			end

			if (!canbreathe and ply:GetCharacter():GetData("gasmask", nil) != nil) then
				local gasmaskItem = inv:HasItem(ply:GetCharacter():GetData("gasmask", nil), {
					["equip"] = true
				})
	
				if (gasmaskItem != false and gasmaskItem:GetData("filterDurability", -1) > 0) then
					canBreathe = true
				end
			end

			if !canBreathe then
				local curTime = CurTime()
				local timeDifference

				ply.nextGasDamage = ply.nextGasDamage or curTime
				
				if ply.nextGasDamage - curTime > 0.75 then
					ply.nextGasDamage = curTime
				end 

				if CurTime() >= ply.nextGasDamage then
					
					ply.nextGasDamage = CurTime() + 0.75
					local dmgInfo = DamageInfo()
					dmgInfo:SetAttacker(game.GetWorld())
					dmgInfo:SetInflictor(game.GetWorld())
					dmgInfo:SetDamage(1)
					dmgInfo:SetDamageType(DMG_DIRECT)
					ply:TakeDamageInfo(dmgInfo)
					ply:Notify("You are choking. You need a gas mask.")
				end

			end
		end
	end
	
end)

hook.Add("Think", "FilterDamage", function()
	for _, ply in pairs(player.GetAll()) do

		if (ply:GetCharacter() != nil) then

			local char = ply:GetCharacter()
			
			local isImmune = char:IsFactionBreathable()

			if ply:GetNoDraw() == true then isImmune = true end

			if (!isImmune) then 

				local nearVent = false

				for k, v in pairs(ents.FindByClass("ix_airvent")) do
					nearVent = ply:GetPos():DistToSqr(v:GetPos()) < 450 * 450
				end

				ply.nextGasDamage = ply.nextGasDamage or CurTime()
				
				if CurTime() >= ply.nextGasDamage and !nearVent and !ply:GetNoDraw() then
					if (ply:GetCharacter():GetData("gasmask", nil) != nil) then
						local inv = ply:GetCharacter():GetInventory()
			
						local gasmaskItem = inv:HasItem(ply:GetCharacter():GetData("gasmask", nil), {
							["equip"] = true
						})
			
						if (gasmaskItem != false and gasmaskItem:GetData("filterDurability", -1) > 0 and gasmaskItem:GetData("filterDurability", -1) != "hazmatworkeroutfit") then
							gasmaskItem:SetData("filterDurability", gasmaskItem:GetData("filterDurability", -1) - 1)
							ply.nextGasDamage = CurTime() + 60
						end
					end
				end
			end
		end
	end
end)

hook.Add("OnNPCKilled", "RemoveGenelockedWeapons", function( npc, attacker, inflictor )
	local ent = npc:GetActiveWeapon()
	if (ent:IsValid()) then
		local lockedWeps = {
			"weapon_ar2",
			"grub_combine_sniper",
			"weapon_stunstick",
			"tfa_heavyshotgun",
			"tfa_heavyshotgunshield",
			"tfa_ordinalrifle",
			"tfa_psmg",
			"tfa_suppressor",
			"weapon_vj_ar2"
		}

		for k, v in ipairs(lockedWeps) do
			if (ent:GetClass() == v) then
				ent:Remove()
			end
		end
		
	end
end)

util.AddNetworkString("ixNPCMessage")

netstream.Hook("PlayerChatTextChanged", function(client, key)
	if (client:GetCharacter():GetFaction() == FACTION_MPF and !client.bTypingBeep
	and (key == "y" or key == "w" or key == "r" or key == "t")) then
		client:EmitSound("NPC_MetroPolice.Radio.On")
		client.bTypingBeep = true
	elseif (client:GetCharacter():GetFaction() == FACTION_OTA and !client.bTypingBeep
	and (key == "y" or key == "w" or key == "r" or key == "t")) then
		client:EmitSound("npc/combine_soldier/vo/on"..tostring(math.random(1,2)).."_episodic.wav")
		client.bTypingBeep = true
	end
end)

netstream.Hook("PlayerFinishChat", function(client)
	if (client:GetCharacter() != nil and client:GetCharacter():GetFaction() != nil) then
		if (client:GetCharacter():GetFaction() == FACTION_MPF and client.bTypingBeep) then
			client:EmitSound("NPC_MetroPolice.Radio.Off")
			client.bTypingBeep = nil
		elseif (client:GetCharacter():GetFaction() == FACTION_OTA and client.bTypingBeep) then
			client:EmitSound("npc/combine_soldier/vo/off"..tostring(math.random(1,3)).."_episodic.wav")
			client.bTypingBeep = nil
		end
	end
end)

netstream.Hook("ViewDataUpdate", function(client, target, text)
	if (IsValid(target) and hook.Run("CanPlayerEditData", client, target) and client:GetCharacter() and target:GetCharacter()) then
		local data = {
			text = string.Trim(text:sub(1, 1000)),
			editor = client:GetCharacter():GetName()
		}

		target:GetCharacter():SetData("combineData", data)
		Schema:AddCombineDisplayMessage("@cViewDataFiller", nil, client)
	end
end)

netstream.Hook("ViewObjectivesUpdate", function(client, text)
	if (client:GetCharacter() and hook.Run("CanPlayerEditObjectives", client)) then
		local date = ix.date.GetSerialized()
		local data = {
			text = text:sub(1, 1000),
			lastEditPlayer = client:GetCharacter():GetName(),
			lastEditDate = date
		}

		ix.data.Set("combineObjectives", data, false, true)
		Schema.CombineObjectives = data
		Schema:AddCombineDisplayMessage("@cViewObjectivesFiller", nil, client, date:spanseconds())
	end
end)

netstream.Hook("SaveImprovedViewData", function(client, target, data)
	if (IsValid(target) and hook.Run("CanPlayerEditData", client, target) and client:GetCharacter() and target:GetCharacter() and target:GetCharacter():GetData("cid", "UNDEFINED") == data.cid) then
		local oldCivData = target:GetCharacter():GetData("civdata", {})

		local newCivData = {
			["loyalacts"] = data.loyalacts,
			["violations"] = data.violations,
			["checkboxes"] = data.checkboxes,
			["textData"] = data.textData,
			["changes"] = data.localChanges
		}

		local allChanges = {}

		if oldCivData.changes == nil then
			oldCivData.changes = {}
		end

		for k, v in ipairs(oldCivData.changes) do
			allChanges[#allChanges+1] = v
		end

		for k, v in ipairs(newCivData.changes) do
			allChanges[#allChanges+1] = v
		end

		local currentTextData = target:GetCharacter():GetData("combineData", {
			["text"] = ""
		}).text
		
		newCivData.changes = allChanges

		target:GetCharacter():SetData("combineData", {
			["text"] = data.textData,
			["editor"] = "UNDEFINED"
		})
		target:GetCharacter():SetData("civdata", newCivData)
	end
end)

net.Receive("ixCharacterCreate", function(length, client)
	if ((client.ixNextCharacterCreate or 0) > RealTime()) then
		return
	end

	local maxChars = hook.Run("GetMaxPlayerCharacter", client) or ix.config.Get("maxCharacters", 5)
	local charList = client.ixCharList
	local charCount = table.Count(charList)

	if (charCount >= maxChars) then
		net.Start("ixCharacterAuthFailed")
			net.WriteString("maxCharacters")
			net.WriteTable({})
		net.Send(client)

		return
	end

	client.ixNextCharacterCreate = RealTime() + 1

	local numDataPoints = net.ReadUInt(32)
	local payload = {}

	for i=1, numDataPoints do
		local dataType = net.ReadInt(8)
		local keyLength = net.ReadInt(32)
		local key = util.Decompress(net.ReadData(keyLength))
		local value
		if dataType == TYPE_NUMBER then
			payload[key] = net.ReadInt(32)
		else
			local valueLength = net.ReadInt(32)
			local value = util.Decompress(net.ReadData(valueLength))

			if dataType == TYPE_TABLE then
				value = util.JSONToTable(value)
			end
			payload[key] = value
		end
	end

	

	local faction = ix.faction.Get(payload.faction)
	local newPayload = {}
	local results = {hook.Run("CanPlayerCreateCharacter", client, payload)}
	if (table.remove(results, 1) == false) then
		net.Start("ixCharacterAuthFailed")
			net.WriteString(table.remove(results, 1) or "unknownError")
			net.WriteTable(results)
		net.Send(client)

		return
	end

	for k, v in SortedPairsByMemberValue(ix.char.vars, "index") do
		local value = payload[k]

		if (v.OnValidate) then
			local result = {v:OnValidate(value, payload, client)}
			if (result[1] == false) then
				local fault = result[2]

				table.remove(result, 2)
				table.remove(result, 1)

				net.Start("ixCharacterAuthFailed")
					net.WriteString(fault)
					net.WriteTable(result)
					
				net.Send(client)

				return
			else
				if (result[1] != nil) then
					payload[k] = result[1]
				end

				if (v.OnAdjust) then
					v:OnAdjust(client, payload, value, newPayload)
				end
			end
		end
	end

	payload.steamID = client:SteamID64()
		hook.Run("AdjustCreationPayload", client, payload, newPayload)
	payload = table.Merge(payload, newPayload)

	ix.char.Create(payload, function(id)
			ix.char.loaded[id]:Sync(client)

			local char = ix.char.loaded[id]

			char:SetData("perks", {})

			net.Start("ixCharacterAuthed")
			net.WriteUInt(id, 32)
			net.WriteUInt(#client.ixCharList, 6)

			for _, v in ipairs(client.ixCharList) do
				net.WriteUInt(v, 32)
			end

			net.Send(client)

			char:SetData("skin", payload.skin or 0)

			local baseSkills = {}
			local specSkills = {}
			local learnedSkills = {}
			
			for uniqueID, skillTbl in pairs(ix.skills.list) do
				baseSkills[uniqueID] = skillTbl.CalculateBase(char)
				learnedSkills[uniqueID] = 0
				if table.HasValue(payload.specSkills, uniqueID) then
					specSkills[uniqueID] = true
				else
					specSkills[uniqueID] = false
				end
			end

			char:SetData("baseSkills", baseSkills)
			char:SetData("specSkills", specSkills)
			char:SetData("learnedSkills", learnedSkills)

			for k, v in ipairs(payload.traits) do
				char:AddPerk(ix.traits.list[v].uniqueID)

				if ix.traits.list[v].uniqueID == "conscientiousobjector" then
					char:SetSkill("guns", math.max(char:GetSkill("guns") - 10, 0))
					char:SetSkill("handtohand", math.max(char:GetSkill("handtohand") - 10, 0))

					char:SetSkill("engineering", math.min(char:GetSkill("engineering") + 10, 100))
					char:SetSkill("fabrication", math.min(char:GetSkill("fabrication") + 10, 100))
					char:SetSkill("medical", math.min(char:GetSkill("medical") + 10, 100))
					char:SetSkill("cooking", math.min(char:GetSkill("cooking") + 10, 100))
				end
			end

			
			if ix.faction.Get(payload.faction).index == FACTION_CITIZEN then
				local inventory = char:GetInventory()
				local suitX, suitY, suitItem = inventory:Add(table.KeyFromValue(DEFAULT_SUITS, payload.suit))
				local filterX, filterY, filterItem = inventory:Add("citizenfilter")

				suitItem = inventory:GetItemAt(suitX, suitY)
				filterItem = inventory:GetItemAt(filterX, filterY)
				
				suitItem.player = client
				filterItem.player = client

				--these don't work
				-- idon't know why
				--fuck you
				--suitItem.functions.Equip.OnRun(suitItem)
				--filterItem.functions.equip.OnRun(filterItem)
			end

			char:SetData("groups", {[1] = 1})

			MsgN("Created character '" .. id .. "' for " .. client:SteamName() .. ".")
			hook.Run("OnCharacterCreated", client, ix.char.loaded[id])
	end)
end)

hook.Add("CanPlayerCreateCharacter", "prCharDataVerify", function(client, payload)
	local faction = ix.faction.Get(payload.faction).index

	if faction == FACTION_CITIZEN then
		if payload.suit == nil then
			return false, "You haven't chosen a suit!"
		end
	end

	if #payload.traits > 2 or #payload.traits < 0 then
		return false, "Invalid number of traits!"
	end

	for k, v in ipairs(payload.traits) do
		if ix.traits.list[v] == nil then
			return false, "You picked an invalid trait!"
		end

		local expectedTrait = ix.traits.list[v]
	end


end)

net.Receive("prSearchResponse", function(len, ply)
	local client = net.ReadEntity()
	local target = net.ReadEntity()
	local response = net.ReadBool()

	if !IsValid(client) or !IsValid(target) or !client:IsPlayer() or !target:IsPlayer() then
		
	end
	
	searcherIdempKey = client:GetVar("SearchRequestSearcher", nil)
	targetIdempKey = target:GetVar("SearchRequestTarget", nil)

	if target != ply or searcherIdempKey == nil or targetIdempKey == nil or (searcherIdempKey != targetIdempKey) then
		client:Notify("Error!")
		return
	else
		if response then
			client:Notify("Your search attempt was resisted.")
		else
			client:Notify("Your search attempt was accepted.")
			Schema:SearchPlayer(client, target)
		end

		target:SetVar("SearchRequestTarget", nil)
		client:SetVar("SearchRequestSearcher", nil)
	end
end)

net.Receive("prCharacterUpdateResponse", function(len, ply)
	local dataLength = net.ReadUInt(32)
	local compressed = net.ReadData(dataLength)
	local tableStr = util.Decompress(compressed)
	local payload = util.JSONToTable(tableStr)

	if !ply:GetCharacter() then return end
	if ply:GetCharacter():GetData("HasBeenUpdated", false) then return end
	if tonumber(ply:GetCharacter():GetCreateTime()) > 1651420800 then return end
	if #payload.specSkills > 2 or #payload.specSkills < 0 then return end
	if payload.specSkills[1] and ix.skills.list[payload.specSkills[1]] == nil then return end
	if payload.specSkills[2] and ix.skills.list[payload.specSkills[2]] == nil then return end
	if #payload.specSkills != table.Count(payload.specSkills) then return end
	if #payload.traits > 2 or #payload.traits < 0 then return end
	if payload.traits[1] and ix.traits.list[payload.traits[1]] == nil then return end
	if payload.traits[2] and ix.traits.list[payload.traits[2]] == nil then return end

	local char = ply:GetCharacter()

	local maxPoints = 20 + ix.attributes.creationPoints
	local pointsSum = 0
	for k, v in pairs(payload.attributes) do
		if ix.attributes.list[k] == nil then return end
		pointsSum = pointsSum + v

		if v == nil or v < 0 or v > 10 then return end
	end

	if pointsSum < 0 or pointsSum > maxPoints then return end

	local sanitizedAttribs = {
		strength = payload.attributes.strength,
		agility = payload.attributes.agility,
		intelligence = payload.attributes.intelligence,
		constitution = payload.attributes.constitution
	}

	for k, v in pairs(sanitizedAttribs) do
		char:SetAttrib(k, v)
	end

	local baseSkills = {}
	local specSkills = {}
	local learnedSkills = {}

	
	for uniqueID, skillTbl in pairs(ix.skills.list) do
		baseSkills[uniqueID] = skillTbl.CalculateBase(char)
		learnedSkills[uniqueID] = 0
		if table.HasValue(payload.specSkills, uniqueID) then
			specSkills[uniqueID] = true
		else
			specSkills[uniqueID] = false
		end
	end


	char:SetData("baseSkills", baseSkills)
	char:SetData("specSkills", specSkills)
	char:SetData("learnedSkills", learnedSkills)

	char:SetData("perks", {})

	for k, v in ipairs(payload.traits) do
		char:AddPerk(ix.traits.list[v].uniqueID, false)

		if ix.traits.list[v].uniqueID == "conscientiousobjector" then
			char:SetSkill("guns", math.max(char:GetSkill("guns") - 10, 0))
			char:SetSkill("handtohand", math.max(char:GetSkill("handtohand") - 10, 0))

			char:SetSkill("engineering", math.min(char:GetSkill("engineering") + 10, 100))
			char:SetSkill("fabrication", math.min(char:GetSkill("fabrication") + 10, 100))
			char:SetSkill("medical", math.min(char:GetSkill("medical") + 10, 100))
			char:SetSkill("cooking", math.min(char:GetSkill("cooking") + 10, 100))
		end
	end

	char:SetData("HasBeenUpdated", true)

	ply:Notify("Your character has been updated.")
end)

net.Receive("prMessengerAction", function(len, ply)
	local viewEnt = ply:GetEyeTrace().Entity
	local entClass = viewEnt:GetClass()

	if !IsValid(viewEnt) then return end
	
	local foundEnt = false
	for k, v in ipairs(ents.FindByClass("ix_testent3")) do
		if v:GetPos():Distance(ply:GetPos()) <= 96 then
			foundEnt = true
			break
		end
	end
	
	if !foundEnt then
		for k, v in ipairs(ents.FindByClass("ix_testent9")) do
			if v:GetPos():Distance(ply:GetPos()) <= 96 then
				foundEnt = true
				break
			end
		end
	end

	if !foundEnt then
		return
	end

	local char = ply:GetCharacter()
	local charID = char:GetID()
	local action = net.ReadUInt(32)

	local function ErrorResponse(message)
		net.Start("prMessengerResponse")
			net.WriteUInt(-1, 32)
			net.WriteBool(false)
			net.WriteString(message)
		net.Send(ply)
	end

	local function SuccessResponse(message)
		net.Start("prMessengerResponse")
			net.WriteUInt(-1, 32)
			net.WriteBool(true)
			net.WriteString(message)
		net.Send(ply)
	end

	if action == MSG_OPEN then
		local svInbox = {}
		local svOutbox = {}

		local clInbox = {}
		local clOutbox = {}

		local messages = ix.data.Get("prMessages", {})

		for k, v in ipairs(messages) do
			if v.hidden then continue end

			if v.recipient == charID then
				svInbox[#svInbox + 1] = table.Copy(v)
			end

			if v.sender == charID then
				svOutbox[#svOutbox + 1]  = table.Copy(v)
			end
		end

		local actorChar = ply:GetCharacter()
		local actorClId, actorAlias = ix.messages.GetMsgInfo(actorChar)

		for k, v in ipairs(svInbox) do
			local msgTable = {}
			local sender = v.sender

			msgTable.recipient = actorClId
			msgTable.text = util.Decompress(v.text)
			msgTable.subject = util.Decompress(v.subject)
			msgTable.time = v.time
			msgTable.read = v.read

			-- if the sender is just numbers
			-- in other words, if the sender is an individual and not an organization.
			if tonumber(sender) then
				sender = tonumber(sender)
				local senderChar = ix.char.loaded[sender]

				local faction = senderChar:GetFaction()

				local senderId, senderAlias = ix.messages.GetMsgInfo(sender)
				msgTable.sender = senderId
				msgTable.alias = senderAlias
				msgTable.isCombine = senderChar:IsCombine()
			else
				-- todo: add organizations and support for them in the messenger
			end

			clInbox[k] = msgTable
			
		end

		for k, v in ipairs(svOutbox) do
			local msgTable = {}
			local recip = v.recipient

			msgTable.sender = actorClId
			msgTable.text = util.Decompress(v.text)
			msgTable.subject = util.Decompress(v.subject)
			msgTable.time = v.time
			msgTable.read = true

			-- if the sender is just numbers
			-- in other words, if the sender is an individual and not an organization.
			if tonumber(recip) then
				recip = tonumber(recip)
				local recipChar = ix.char.loaded[recip]

				local faction = recipChar:GetFaction()

				local recipId, recipAlias = ix.messages.GetMsgInfo(recip)
				msgTable.recipient = recipId
				msgTable.alias = recipAlias
			else
				-- todo: add organizations and support for them in the messenger
			end

			clOutbox[k] = msgTable
		end

		net.Start("prMessengerResponse")

			net.WriteUInt(MSG_OPEN, 32)

			local inboxComp = util.Compress(util.TableToJSON(clInbox))

			net.WriteInt(#inboxComp, 32)
			net.WriteData(inboxComp)

			local outboxComp = util.Compress(util.TableToJSON(clOutbox))

			net.WriteInt(#outboxComp, 32)
			net.WriteData(outboxComp)

		net.Send(ply)
	elseif action == MSG_SEND then
		-- todo: add a check for who can message who
		local textSize = net.ReadInt(32)
		local text = net.ReadData(textSize)
		text = util.Decompress(text)

		print("text", text)

		local subject = net.ReadString()
		local recipient = net.ReadString()

		if tonumber(recipient) then
			if #recipient != 5 then
				ErrorResponse("That is not a valid recipient!")
				return
			end

			local recip = ix.char.GetByIIN(recipient)

			if recip == nil then
				ErrorResponse("That is not a valid recipient!")
				return
			end

			if #text > 500 then 
				ErrorResponse("Your message is "..500 - #text.." characters too long!")
				return
			end

			if #subject > 30 then 
				ErrorResponse("Your subject is "..30 - #subject.." characters too long!")
				return
			end

			if text == "" then
				ErrorResponse("You cannot send an empty message!")
				return
			end

			local messages = ix.data.Get("prMessages", {})
			messages[#messages + 1] = ServerMessage(ply:GetCharacter():GetID(), recip:GetID(), util.Compress(text), util.Compress(subject), os.time(), false)
			ix.data.Set("prMessages", messages)

			net.Start("prMessengerResponse")
				net.WriteUInt(MSG_SEND, 32)
				net.WriteBool(true)
			net.Send(ply)
		else
			-- todo: organization support
		end
	elseif action == MSG_SETNAME then
		local newName = net.ReadString()
		
		if #newName > 32 then
			ErrorResponse("Your display name must be under 32 characters in length.")
			return
		elseif #newName <= 0 or #string.Explode(" ", newName) == #newName then
			ErrorResponse("That is not a valid display name!")
			return
		end

		char:SetData("MsgDisplayName", newName)
		SuccessResponse("Your display name has been set to \""..newName.."\".")
	elseif action == MSG_SETREAD then
		local readIndex = net.ReadInt(32)
		local svInbox = {}
		local svOutbox = {}

		local clInbox = {}
		local clOutbox = {}

		local messages = ix.data.Get("prMessages", {})

		for k, v in ipairs(messages) do
			if v.hidden then continue end
			if v.recipient == charID then
				local msgAddition = table.Copy(v)
				msgAddition.universalID = k
				svInbox[#svInbox + 1] = msgAddition
			end
		end

		local actorChar = ply:GetCharacter()
		local actorClId, actorAlias = ix.messages.GetMsgInfo(actorChar)

		for k, v in ipairs(svInbox) do
			local msgTable = {}
			local sender = v.sender

			msgTable.recipient = actorClId
			msgTable.text = util.Decompress(v.text)
			msgTable.subject = util.Decompress(v.subject)
			msgTable.time = v.time
			msgTable.read = v.read
			msgTable.universalID = v.universalID

			-- if the sender is just numbers
			-- in other words, if the sender is an individual and not an organization.
			if tonumber(sender) then
				sender = tonumber(sender)
				local senderChar = ix.char.loaded[sender]

				local faction = senderChar:GetFaction()

				local senderId, senderAlias = ix.messages.GetMsgInfo(sender)
				msgTable.sender = senderId
				msgTable.alias = senderAlias
				msgTable.isCombine = senderChar:IsCombine()
			else
				-- todo: add organizations and support for them in the messenger
			end

			clInbox[k] = msgTable
			
		end

		for k, v in ipairs(svOutbox) do
			local msgTable = {}
			local recip = v.recipient

			msgTable.sender = actorClId
			msgTable.text = util.Decompress(v.text)
			msgTable.subject = util.Decompress(v.subject)
			msgTable.time = v.time
			msgTable.read = true

			-- if the sender is just numbers
			-- in other words, if the sender is an individual and not an organization.
			if tonumber(recip) then
				recip = tonumber(recip)
				local recipChar = ix.char.loaded[recip]

				local faction = recipChar:GetFaction()

				local recipId, recipAlias = ix.messages.GetMsgInfo(recip)
				msgTable.recipient = recipId
				msgTable.alias = recipAlias
			else
				-- todo: add organizations and support for them in the messenger
			end

			clOutbox[k] = msgTable
		end


		local msgUpdate = ix.data.Get("prMessages", {})
		local uniIndex = clInbox[readIndex].universalID
		print("index", uniIndex)
		if msgUpdate[uniIndex] and msgUpdate[uniIndex].read == false then
			msgUpdate[uniIndex].read = true
			ix.data.Set("prMessages", msgUpdate)
		end
		
		
	elseif action == MSG_DELETE then
		local delIndex = net.ReadInt(32)
		local svInbox = {}
		local svOutbox = {}

		local clInbox = {}
		local clOutbox = {}

		local messages = ix.data.Get("prMessages", {})

		for k, v in ipairs(messages) do
			if v.hidden then continue end
			if v.recipient == charID then
				local msgAddition = table.Copy(v)
				msgAddition.universalID = k
				svInbox[#svInbox + 1] = msgAddition
			end
		end

		local actorChar = ply:GetCharacter()
		local actorClId, actorAlias = ix.messages.GetMsgInfo(actorChar)

		for k, v in ipairs(svInbox) do
			local msgTable = {}
			local sender = v.sender

			msgTable.recipient = actorClId
			msgTable.text = util.Decompress(v.text)
			msgTable.subject = util.Decompress(v.subject)
			msgTable.time = v.time
			msgTable.read = v.read
			msgTable.universalID = v.universalID

			-- if the sender is just numbers
			-- in other words, if the sender is an individual and not an organization.
			if tonumber(sender) then
				sender = tonumber(sender)
				local senderChar = ix.char.loaded[sender]

				local faction = senderChar:GetFaction()

				local senderId, senderAlias = ix.messages.GetMsgInfo(sender)
				msgTable.sender = senderId
				msgTable.alias = senderAlias
				msgTable.isCombine = senderChar:IsCombine()
			else
				-- todo: add organizations and support for them in the messenger
			end

			clInbox[k] = msgTable
			
		end

		for k, v in ipairs(svOutbox) do
			local msgTable = {}
			local recip = v.recipient

			msgTable.sender = actorClId
			msgTable.text = util.Decompress(v.text)
			msgTable.subject = util.Decompress(v.subject)
			msgTable.time = v.time
			msgTable.read = true

			-- if the sender is just numbers
			-- in other words, if the sender is an individual and not an organization.
			if tonumber(recip) then
				recip = tonumber(recip)
				local recipChar = ix.char.loaded[recip]

				local faction = recipChar:GetFaction()

				local recipId, recipAlias = ix.messages.GetMsgInfo(recip)
				msgTable.recipient = recipId
				msgTable.alias = recipAlias
			else
				-- todo: add organizations and support for them in the messenger
			end

			clOutbox[k] = msgTable
		end

		local msgUpdate = ix.data.Get("prMessages", {})
		local uniIndex = clInbox[delIndex].universalID
		if msgUpdate[uniIndex] and (msgUpdate[uniIndex].hidden == false or msgUpdate[uniIndex].hidden == nil) then
			msgUpdate[uniIndex].hidden = true
			ix.data.Set("prMessages", msgUpdate)
		end
	end
end)

concommand.Add("givekeys", function()
	for k, v in ipairs(player.GetAll()) do
		v:Give("ix_keys")
	end
end)

net.Receive("ixPadlockSend", function(len, ply)
	local setPassword = net.ReadBool()
	local lock = Entity(net.ReadInt(32))
	local code = net.ReadString()

	if IsValid(lock) and IsValid(ply) and lock:GetClass() == "ix_padlock" and ply:GetPos():Distance(lock:GetPos()) <= 96 and IsValid(lock.door) then
		if setPassword and ply:GetVar("SettingDoorLock", false) == lock.door:MapCreationID() and lock.password == nil then
			
			if #code > 63 then
				net.Start("ixPadlockCode")
					net.WriteBool(true)
					net.WriteInt(lock:EntIndex(), 32)
					net.WriteBool(true)
				net.Send(ply)
			else
				print("got to door")
				lock.password = code
				lock:SetLocked(true)
				ply:SetVar("SettingDoorLock", false)
				local doorID = lock.door:MapCreationID()
				for k, v in pairs(ix.char.loaded) do
					local locks = v:GetData("DoorLocks", {})
					if locks[doorID] then
						locks[doorID] = nil
					end
					v:SetData("DoorLocks", {})
				end
			end
			
		elseif !setPassword then
			if lock.password != nil and lock.password == code then
				local char = ply:GetCharacter()
				local doors = char:GetData("DoorLocks", {})
				
				doors[lock.door:MapCreationID()] = code

				lock:Toggle()
				
				char:SetData("DoorLocks", doors)
			else
				ply:Notify("That is not the correct combination!")
			end
		end
	end
end)