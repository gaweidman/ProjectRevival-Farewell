local playerMeta = FindMetaTable("Player")

function playerMeta:IsCombine()
	local faction = self:Team()
	return faction == FACTION_MPF or faction == FACTION_OTA or faction == FACTION_CONSCRIPT or faction == FACTION_OSA
end

function playerMeta:HasBiosignal()
	local faction = self:Team()
	return faction == FACTION_MPF or faction == FACTION_OTA or faction == FACTION_CONSCRIPT or faction == FACTION_OSA
end

function playerMeta:IsVocoded()
	return self:IsCombine()
end

function playerMeta:IsDispatch()
	local name = self:Name()
	local faction = self:Team()
	local bStatus = faction == FACTION_OTA

	if (!bStatus) then
		for k, v in ipairs({ "SCN", "DvL", "SeC", "SqL", "OfC", "EpU" }) do
			if (Schema:IsCombineRank(name, v)) then
				bStatus = true

				break
			end
		end
	end

	return bStatus
end

function playerMeta:DoStaredAction(entity, callback, time, onCancel, distance)
	local uniqueID = "ixStare"..self:UniqueID()
	local data = {}
	data.filter = self

	local modifiedTime = Lerp(self:GetCharacter():GetSkill("sleightofhand")/100, time*1.25, time*0.75)

	timer.Create(uniqueID, 0.1, modifiedTime/0.1, function()
		if (IsValid(self) and IsValid(entity)) then
			data.start = self:GetShootPos()
			data.endpos = data.start + self:GetAimVector()*(distance or 96)

			if (util.TraceLine(data).Entity != entity) then
				timer.Remove(uniqueID)

				if (onCancel) then
					onCancel()
				end
			elseif (callback and timer.RepsLeft(uniqueID) == 0) then
				callback()
			end
		else
			timer.Remove(uniqueID)

			if (onCancel) then
				onCancel()
			end
		end
	end)
end

function playerMeta:DoStaredActionFlat(entity, callback, time, onCancel, distance)
	local uniqueID = "ixStare"..self:UniqueID()
	local data = {}
	data.filter = self

	timer.Create(uniqueID, 0.1, time / 0.1, function()
		if (IsValid(self) and IsValid(entity)) then
			data.start = self:GetShootPos()
			data.endpos = data.start + self:GetAimVector()*(distance or 96)

			if (util.TraceLine(data).Entity != entity) then
				timer.Remove(uniqueID)

				if (onCancel) then
					onCancel()
				end
			elseif (callback and timer.RepsLeft(uniqueID) == 0) then
				callback()
			end
		else
			timer.Remove(uniqueID)

			if (onCancel) then
				onCancel()
			end
		end
	end)
end

function playerMeta:SetActionWeighted(text, time, callback, startTime, finishTime)
if (time and time <= 0) then
		if (callback) then
			callback(self)
		end

		return
	end

	-- Default the time to five seconds.
	time = time or 5
	startTime = startTime or CurTime()
	finishTime = finishTime or (startTime + time)

	if (text == false) then
		timer.Remove("ixAct"..self:UniqueID())

		net.Start("ixActionBarReset")
		net.Send(self)

		return
	end

	if (!text) then
		net.Start("ixActionBarReset")
		net.Send(self)
	else
		net.Start("ixActionBar")
			net.WriteFloat(startTime)
			net.WriteFloat(finishTime)
			net.WriteString(text)
		net.Send(self)
	end

	-- If we have provided a callback, run it delayed.
	if (callback) then
		-- Create a timer that runs once with a delay.
		timer.Create("ixAct"..self:UniqueID(), time, 1, function()
			-- Call the callback if the player is still valid.
			if (IsValid(self)) then
				callback(self)
			end
		end)
	end
end

function playerMeta:SetAction(text, time, callback, startTime, finishTime)
	if (time and time <= 0) then
		if (callback) then
			callback(self)
		end

		return
	end

	-- Default the time to five seconds.
	time = time or 5
	startTime = startTime or CurTime()
	finishTime = finishTime or (startTime + time)

	if (text == false) then
		timer.Remove("ixAct"..self:UniqueID())

		net.Start("ixActionBarReset")
		net.Send(self)

		return
	end

	if (!text) then
		net.Start("ixActionBarReset")
		net.Send(self)
	else
		net.Start("ixActionBar")
			net.WriteFloat(startTime)
			net.WriteFloat(finishTime)
			net.WriteString(text)
		net.Send(self)
	end

	-- If we have provided a callback, run it delayed.
	if (callback) then
		-- Create a timer that runs once with a delay.
		timer.Create("ixAct"..self:UniqueID(), time, 1, function()
			-- Call the callback if the player is still valid.
			if (IsValid(self)) then
				callback(self)
			end
		end)
	end
end

function playerMeta:Heal(num)
	self:SetHealth( math.Clamp(self:Health() + num, 0, self:GetMaxHealth()) )
end

function playerMeta:MovingKeysPressed()
	return self:KeyDown(IN_FORWARD) or self:KeyDown(IN_BACK) or self:KeyDown(IN_MOVELEFT) or self:KeyDown(IN_MOVERIGHT)
end

function playerMeta:IsTranscendant()
	return self:GetNetVar("IsTranscendant", false)
end

function playerMeta:TryFreeVort(inflictor)
	local char = self:GetCharacter()
	local inflictorChar = inflictor:GetCharacter()
	local inflictorInv = inflictorChar:GetInventory()

	if char:GetFaction() == FACTION_MPF then
		hasCombineQualifs = inflictorChar:GetCombineDivision() != "HELIX" and inflictorChar:GetCombineRank() >= RANK_I3
	end
	
	if hasCombineQualifs or inflictorChar:GetAttribute("medical", 0) < 10 then
		return "Your medical knowledge is not high enough!"
	elseif !inflictorInv:HasItem("knife") then
		return "You are missing items!"
	elseif !inflictorInv:HasItemOfBase("base_medical") then
		return "You are missing items!"
	elseif self:GetNetVar("beingBound", false) or self:GetNetVar("beingFreed", false) then
		return "You cannot free this person right now!"	
	else 
		if SERVER then
			self:StartFreeVort(inflictor)
		end
	end
end

function playerMeta:StartFreeVort(inflictor)

	local inflictorChar = inflictor:GetCharacter()
	local inflictorInv = inflictorChar:GetInventory()

	local char = self:GetCharacter()

	inflictor:SetAction("Freeing Vortigaunt...", 10)
	self:SetAction("You are being freed...", 10)
	self:SetNetVar("beingFreed", true)

	timer.Simple(0.2, function()
		if self:GetNetVar("beingFreed", false) then
			self:EmitSound("weapons/usp/usp_silencer_on.wav")

			timer.Simple(2, function()
				if self:GetNetVar("beingFreed", false) then
					self:EmitSound("weapons/knife/knife_stab.wav")
		
					timer.Simple(2, function()
						if self:GetNetVar("beingFreed", false) then
							self:EmitSound("items/ammopickup.wav")
				
							timer.Simple(2, function()
								if self:GetNetVar("beingFreed", false) then
									self:EmitSound("items/ammopickup.wav")
						
									timer.Simple(2, function()
										if self:GetNetVar("beingFreed", false) then
											self:EmitSound("items/medshot4.wav")
										end
									end)
								end
							end)
						end
					end)
				end
			end)
		end
	end)

	inflictor:DoStaredAction(self, function()
		-- onSuccess
		if inflictorChar:GetAttribute("medical", 0) < 10 then
			return "Your medical knowledge is not high enough!"
		elseif !inflictorInv:HasItem("knife") then
			return "You are missing items!"
		elseif !inflictorInv:HasItemOfBase("base_medical") then
			return "You are missing items!"
		elseif !inflictorInv:HasItem("cmbhexkey") then
			return "You are missing items!"
		end

		local medicalItem = inflictorInv:HasItemOfBase("base_medical")
		medicalItem:Remove()

		self:SetAction()
		inflictor:SetAction()

		char:SetModel("models/vortigaunt_blue.mdl")
		char:SetFaction(FACTION_ALIEN)
		char:SetClass(CLASS_FREEVORT)

		self:SetNetVar("beingFreed", false)

		if char:GetData("FreeVortName", nil) == nil then
			netstream.Start(self, "RequestString")
		end
	end, 1, function()
		-- onCancel
		self:SetAction()
		inflictor:SetAction()
		
		self:SetNetVar("beingFreed", false)
	end)
end

function playerMeta:TryBindVort(inflictor)
	local char = self:GetCharacter()
	local inflictorChar = inflictor:GetCharacter()
	local inflictorInv = inflictorChar:GetInventory()

	local hasCombineQualifs = nil
	
	if char:GetFaction() == FACTION_MPF then
		hasCombineQualifs = inflictorChar:GetCombineDivision() != "HELIX" and inflictorChar:GetCombineRank() >= RANK_I3
	end

	if hasCombineQualifs or (inflictorChar:GetAttribute("medical", 0) > 10 and inflictorChar:GetAttribute("eng", 0) > 15) then
		return "Your medical knowledge is not high enough!"
	elseif !inflictorInv:HasItem("scalpel") then
		return "You are missing items!"
	elseif !inflictorInv:HasItemOfBase("base_medical") then
		return "You are missing items!"
	elseif self:GetNetVar("beingBound", false) or self:GetNetVar("beingFreed", false) then
		return "You cannot bind this person right now!"
	else
		if SERVER then
			self:StartBindVort(inflictor)
		end
	end
end

function playerMeta:StartBindVort(inflictor)

	local inflictorChar = inflictor:GetCharacter()
	local inflictorInv = inflictorChar:GetInventory()

	local char = self:GetCharacter()

	inflictor:SetAction("Binding Vortigaunt...", 10)
	self:SetAction("You are being bound...", 10)
	self:SetNetVar("beingBound", true)

	timer.Simple(0.2, function()
		if self:GetNetVar("beingBound", false) then
			self:EmitSound("weapons/knife/knife_stab.wav")

			timer.Simple(2, function()
				if self:GetNetVar("beingBound", false) then
					self:EmitSound("items/ammopickup.wav")
		
					timer.Simple(2, function()
						if self:GetNetVar("beingBound", false) then
							self:EmitSound("weapons/usp/usp_silencer_on.wav")
				
							timer.Simple(2, function()
								if self:GetNetVar("beingBound", false) then
									self:EmitSound("items/medshot4.wav") 
						
									timer.Simple(2, function()
										if self:GetNetVar("beingBound", false) then
											self:EmitSound("buttons/combine_button5.wav")
										end
									end)
								end
							end)
						end
					end)
				end
			end)
		end
	end)

	inflictor:DoStaredAction(self, function()
		-- onSuccess

		self:SetNetVar("beingBound", false)
		self:SetAction()
		inflictor:SetAction()

		if inflictorChar:GetAttribute("medical", 0) < 10 then
			return "Your medical knowledge is not high enough!"
		elseif !inflictorInv:HasItem("knife") then
			return "You are missing items!"
		elseif !inflictorInv:HasItemOfBase("base_medical") then
			return "You are missing items!"
		elseif !inflictorInv:HasItem("vortbindings") then
			return "You are missing items!"
		end

		local medicalItem = inflictorInv:HasItemOfBase("base_medical")
		medicalItem:Remove()

		char:SetModel("models/vortigaunt_slave.mdl")
		char:SetFaction(FACTION_CAC)
		char:SetClass(CLASS_VORTSLAVE)
		char:SetName("CAC.C08-VRP."..tostring(Schema:ZeroNumber(math.random(1, 99999), 5)))

	end, 1, function()
		-- onCancel
		self:SetNetVar("beingBound", false)
		self:SetAction()
		inflictor:SetAction()
	end)
end

function playerMeta:DoVortSpeechSounds(text)
	local textBroken = string.Split(text, " ")

	local speechSound

	local vortSounds = {
		[1] = { -- Short sounds, count for 1 point
			["pointValue"] = 1,
			["sounds"] = {"vo/npc/vortigaunt/vortigese03.wav", "vo/npc/vortigaunt/vortigese04.wav", "vo/npc/vortigaunt/vortigese05.wav", "vo/npc/vortigaunt/vortigese08.wav"} 
		},
		[2] = { -- Medium sounds, count for 2 points
			["pointValue"] = 2,
			["sounds"] = {"vo/npc/vortigaunt/vortigese02.wav", "vo/npc/vortigaunt/vortigese09.wav"} 
		},
		[3] = { -- Long sounds, count for 4 points
			["pointValue"] = 4,
			["sounds"] = {"vo/npc/vortigaunt/vortigese11.wav", "vo/npc/vortigaunt/vortigese12.wav"} 
		}
	}

	if #text <= 5 then
		speechSound = vortSounds[1].sounds[math.random(1, #vortSounds[1].sounds)]
	elseif #text <= 10 then
		speechSound = vortSounds[2].sounds[math.random(1, #vortSounds[2].sounds)]
	else
		speechSound = vortSounds[3].sounds[math.random(1, #vortSounds[3].sounds)]
	end

	self:EmitSound(speechSound)

end

function playerMeta:IsStaff()
	local userGroup = self:GetUserGroup()

	return userGroup == "admin" or userGroup == "administrator" or userGroup == "superadmin" or userGroup == "founder" or userGroup == "mod" or userGroup == "moderator" or userGroup == "trialmod" or userGroup == "trialmoderator"
end
