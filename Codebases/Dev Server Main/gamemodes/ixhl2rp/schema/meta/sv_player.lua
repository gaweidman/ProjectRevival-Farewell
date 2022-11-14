local playerMeta = FindMetaTable("Player")

VORTIGAUNT_BLUE_FADE_TIME = 2.25

function playerMeta:IsScanner()
	return IsValid(self.ixScanner)
end

function playerMeta:AddCombineDisplayMessage(text, color, ...)
	if (self:IsCombine()) then
		netstream.Start(self, "CombineDisplayMessage", text, color or false, {...})
	end
end

function playerMeta:CanHearFreq(speakerFreq)
	local pos = self:GetPos()
	local listenerFreq = self:GetData("frequency", nil)

	if listenerFreq == nil then return false end
	
	for k, v in ipairs(ents.FindInSphere(pos, ix.config.Get("chatRange", 280))) do
		if v:GetClass() != "ix_transrecradio" then continue end
		local reqDistance = Lerp(v.volume/100, 45, 280)

		if speakerFreq == v.frequency and v:GetNetVar("On", false) and pos:Distance(v:GetPos()) <= reqDistance then
			return true
		end
	end

	for k, v in pairs(inventory:GetItemsByUniqueID("hybridradio", true)) do
		if (v:GetData("enabled", false) and speakerFreq == listenerFreq) then
			return true
		end
	end
end

function playerMeta:TurnBlue()
    self:SetNetVar("IsBlue", true)
    self:SetNetVar("fadeBlueEndTime", CurTime() + VORTIGAUNT_BLUE_FADE_TIME)
end

function playerMeta:EndBlue()
    self:SetNetVar("IsBlue", false)
    self:SetNetVar("fadeBlueEndTime", CurTime() + VORTIGAUNT_BLUE_FADE_TIME)
end

function playerMeta:Transcend()
	self:TurnBlue()
	self:SetNetVar("IsTranscendant", true)
end

function playerMeta:UnTranscend()
	self:EndBlue()
	self:SetNetVar("IsTranscendant", false)
end

function playerMeta:IsTranscendant()
	return self:GetNetVar("IsTranscendant", false)
end

function playerMeta:SetClassWhitelisted(class, whitelisted)
	if (!whitelisted) then
		whitelisted = nil
	end

	local data = ix.class.list[class]

	

	if (data) then
		local whitelists = self:GetData("classwhitelists", {})
		whitelists[Schema.folder] = whitelists[Schema.folder] or {}
		whitelists[Schema.folder][ix.faction.Get(data.faction).uniqueID] = whitelists[Schema.folder][ix.faction.Get(data.faction).uniqueID] or {}
		PrintTable(ix.faction.Get(data.faction))
		print("faction", data.uniqueID)
		whitelists[Schema.folder][ix.faction.Get(data.faction).uniqueID][data.uniqueID] = whitelisted and true or nil

		self:SetData("classwhitelists", whitelists)
		self:SaveData()

		return true
	end

	return false
end



function playerMeta:StartGruntFire(inflictor, attacker)
	local ply = self
	local char = ply:GetCharacter()

	--ply:EmitSound("gastank_fire_start_0"..math.random(1, 3)..".wav")
	--self:EmitSound("ambient/gas/steam2.wav")
	local gruntExplData = {
		inflictor = inflictor,
		attacker = attacker
	}

	ply:SetNetVar("GruntExplData", gruntExplData)

	timer.Create("GruntExplode_"..self:SteamID64(), 1, 1, function()
		local newChar = ply:GetCharacter()
		if IsValid(ply) and newChar and newChar:GetID() == char:GetID() then
			ply:GruntExplode()
		end

		timer.Remove("GruntExplode_"..ply:SteamID64())
	end)
end

function playerMeta:GruntExplode()
	local pos = self:GetPos() - self:GetForward()*math.random(-5, 5) + self:GetUp()*60 + self:GetRight()*math.random(-5, 5)
	

	self:SetBodygroup(5, 1)
	local gruntExplData = self:GetNetVar("GruntExplData", {})

	--self:StopSound("ambient/gas/steam2.wav")

	util.BlastDamage(gruntExplData.inflictor, gruntExplData.attacker, pos, 100, 50)
	self:Kill()
	local effectData = EffectData()
	effectData:SetOrigin(pos)
	effectData:SetMagnitude(100)
	effectData:SetScale(1)
	effectData:SetFlags(0)

	util.Effect("Explosion", effectData)
end

function playerMeta:SetPassiveEmitTimer()
	local timerName = "ixPassiveEmit"..self:SteamID64()
	local ply = self

	if timer.Exists(timerName) then
		timer.Remove(timerName)
	end

	timer.Simple(0, function()
		timer.Create(timerName, math.random(60, 240), 1, function()
			if ply:GetCharacter():GetFaction() == FACTION_MPF then
				local sentence = table.Random(ix.sentences.passivedispatch.sentences)
				ix.util.EmitSentence(ply, "passivedispatch", sentence)
				ply:SetPassiveEmitTimer()
			end
		end)
	end)
end

concommand.Add("TurnBlue", function(ply, cmd, args, argStr)
    ply:Transcend()
	ply:GetViewModel():SetNetVar("IsBlue", true)
end)

concommand.Add("EndBlue", function(ply, cmd, args, argStr)
    ply:UnTranscend()
end)
