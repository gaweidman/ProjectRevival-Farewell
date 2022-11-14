function PLUGIN:SetupDrugTimer(client, character, drug, drugtimer)
	local steamID = client:SteamID64()
	local drugtimer = drugtimer or 100
	character:SetDrug(drug)
	character:SetDrugTimer(drugtimer)
	timer.Create("ixDrug" .. steamID, 1, 0, function()
		if (IsValid(client) and character) then
			self:DrugTick(client, character, drug, 1)
		else
			timer.Remove("ixDrug" .. steamID)
		end
	end)
end

function PLUGIN:PlayerDeath(client)
	local character = client:GetCharacter()
	if (character) then
		character:SetDrugTimer(0)
	end
end

function PLUGIN:DrugTick(client, character, drug, delta)
	if (!client:Alive() or client:GetMoveType() == MOVETYPE_NOCLIP) then
		return
	end

	local scale = 1

	-- update character drug timer
	local drugtimer = character:GetDrugTimer()
	local newTimer = math.Clamp(drugtimer - scale * (delta / 1), 0, 100)

	character:SetDrugTimer(newTimer)

	if (character:GetDrugTimer() < 1) then
		local boosts = character:GetBoosts()

		for attribID, v in pairs(boosts) do
			for boostID, _ in pairs(v) do
				character:RemoveBoost(boostID, attribID)
			end
		end
		character:SetDrugTimer(100)
		timer.Remove("ixDrug" .. client:SteamID64())
	end
end