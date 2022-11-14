
local PLUGIN = PLUGIN
PLUGIN.name = "Radiation"
PLUGIN.author = "Frosty"
PLUGIN.description = "Radiation System"

if (CLIENT) then
	function PLUGIN:RenderScreenspaceEffects()
		if (LocalPlayer():GetCharacter()) then
			if (LocalPlayer():GetRadiation() > 39 and LocalPlayer():GetRadiation() < 60) then
				DrawMotionBlur(0.1, 0.3, 0.01)
			elseif(LocalPlayer():GetRadiation() >= 60) then
				DrawMotionBlur(0.1, 0.7, 0.01)
			end
		end
    end
	
	ix.bar.Add(function()
		local status = ""
		local var = LocalPlayer():GetLocalVar("radiation", 0) / 100

		if var < 0.2 then
			status = ""
		elseif var < 0.4 then
			status = L"minorIrradiation"
		elseif var < 0.6 then
			status = L"criticalIrradiation"
		elseif var < 1 then
			status = L"deadlyIrradiation"
		end

		return var, status
	end, Color(39, 174, 96), nil, "radiation")
else
	local PLUGIN = PLUGIN
	
	function PLUGIN:OnCharacterCreated(client, character)
		character:SetData("radiation", 0)
	end

	function PLUGIN:PlayerLoadedCharacter(client, character)
		timer.Simple(0.25, function()
			client:SetLocalVar("radiation", character:GetData("radiation", 0))
		end)
	end

	function PLUGIN:CharacterPreSave(character)
		local savedRads = math.Clamp(character.player:GetRadiation(), 0, 100)
		character:SetData("radiation", savedRads)
	end
	
	function PLUGIN:PlayerDeath(client)
		client.resetRads = true
	end

	function PLUGIN:PlayerSpawn(client)
		local char = client:GetCharacter()
		
		if (client.resetRads) then
			char:SetData("radiation", 0)
			client:SetLocalVar("radiation", 0)
			client.resetRads = false
		end
	end

	
	local playerMeta = FindMetaTable("Player")

	function playerMeta:SetRadiation(amount)
		local char = self:GetCharacter()

		if (char) then
			char:SetData("radiation", amount)
			self:SetLocalVar("radiation", amount)
		end
	end
	
	function playerMeta:AddRadiation(amount)
		local char = self:GetCharacter()
		local curRadiation = self:GetRadiation()
		
		if (char) then
			char:SetData("radiation", math.Clamp(math.min(curRadiation) + amount, 0, 100))
			self:SetLocalVar("radiation", math.Clamp(math.min(curRadiation) + amount, 0, 100))
		end
	end
	
	local thinkTime = CurTime()
	local damageTime = CurTime()
	function PLUGIN:Think()
		if (thinkTime < CurTime()) then
			for k, v in ipairs(player.GetAll()) do
				if (v:GetCharacter()) then
					if v:GetCharacter():GetData("radiation", 0) == 100 then
						if v:Alive() then
							v:Kill()
						end
					end
				end	
			end
			
			thinkTime = CurTime() + .5
		end
		
		if (damageTime < CurTime()) then
			for k, v in ipairs(player.GetAll()) do
				if (v:GetCharacter()) then
					if (v:GetCharacter():GetData("radiation", 0) > 39 and v:GetCharacter():GetData("radiation", 0) < 60) then
						v:TakeDamage(1, v, "radiation")
					elseif (v:GetCharacter():GetData("radiation", 0) > 60) then
						v:TakeDamage(1.5, v, "radiation")
					end
				end
			end
			
			damageTime = CurTime() + 15
		end
	end
	
	-- IRRADIATED AREA
	-- gets two vector and gives min and max vector for Vector:WithinAA(min, max)
	local function sortVector(vector1, vector2)
		local minVector = Vector(0, 0, 0)
		local maxVector = Vector(0, 0, 0)

		for i = 1, 3 do
			if (vector1[i] >= vector2[i]) then
				maxVector[i] = vector1[i]
				minVector[i] = vector2[i]
			else
				maxVector[i] = vector2[i]
				minVector[i] = vector1[i]
			end
		end

		return minVector, maxVector
	end

	ix.irradiated = ix.irradiated or {}

	-- get all irradiated area.
	function ix.irradiated.GetAll()
		return PLUGIN.radAreas
	end

	-- Add irradiated area.
	function ix.irradiated.AddArea(vMin, vMax)
		vMin, vMax = sortVector(vMin, vMax)

		if (vMin and vMax) then
			table.insert(PLUGIN.radAreas, {vMin, vMax})
		end
	end

	function PLUGIN:SaveData()
		self:SetData(ix.irradiated.GetAll())
	end
	
	function PLUGIN:LoadData()
		PLUGIN.radAreas = self:GetData()
	end

	timer.Create("irradiatedTick", 1, 0, function()
		for _, client in ipairs(player.GetAll()) do
			local char = client:GetCharacter()
			local clientPos = client:GetPos() + client:OBBCenter()
			client.currentArea = nil

			for index, vec in ipairs((ix.irradiated.GetAll() or {})) do
				if (clientPos:WithinAABox(vec[1], vec[2])) then
					if (client:IsAdmin()) then
						client.currentArea = index
					end
					
					if (client:Alive() and char) then
						if (client:IsPlayer()) then
							local inventory = char:GetInventory()
							local items = inventory:GetItems()

							for k, v in pairs(items) do
								if (v:GetData("equip") == true and v.base == "base_armor") then
									local durability = v:GetData("Durability", 100)

									if (durability > 0) then
										v:SetData("Durability", math.max(durability - 0.005))
									elseif (durability == 0 or durability < 0) then
										client:RemoveOutfit(v)
										v:SetData("Durability", 0)
									end

									client:AddRadiation(math.random(0, v.damage[5]/500))
									-- client:ScreenFade(1, ColorAlpha(color_white, 10), .5, 0)
								else
									client:AddRadiation(math.random(0, 0.01))
									client:ScreenFade(1, ColorAlpha(color_white, 30), .5, 0)
								end
							end
						end
						
						local geigerSounds = {"player/geiger1.wav", "player/geiger2.wav", "player/geiger3.wav" }
						local randomsound = table.Random(geigerSounds)
						
						client:EmitSound(randomsound)
					end
				end
			end
		end
	end)

	netstream.Start("AddArea", function(client, v1, v2)
		if (!client:IsAdmin()) then
			client:NotifyLocalized("notAllowed", client)
		end

		client:NotifyLocalized("addedNewIrradiated")
		ix.irradiated.AddArea(v1, v2)
	end)
end

local playerMeta = FindMetaTable("Player")

function playerMeta:GetRadiation()
	local char = self:GetCharacter()

	if (char) then
		return char:GetData("radiation", 0)
	end
end

function PLUGIN:AdjustStaminaOffset(client, offset)
	if client:GetRadiation() >= 60 then
		return -1
	end
end

ix.command.Add("CharSetRadiation", {
	description = "Set character's radiation ammount.",
	adminOnly = true,
	arguments = {
		ix.type.player,
		ix.type.number
	},
	OnRun = function(self, client, target, radiation)
		target:SetRadiation(radiation)

		if client == target then
            client:NotifyLocalized("CharSetRadiation1", radiation)
        else
            client:NotifyLocalized("CharSetRadiation2", target:GetName(), radiation)
            target:NotifyLocalized("CharSetRadiation3", client:GetName(), radiation)
        end
	end
})

ix.command.Add("RadAreaAdd", {
	description = "Add an irradiated area.",
	adminOnly = true,
	OnRun = function(self, client, arguments)
		local pos = client:GetEyeTraceNoCursor().HitPos

		if (!client:GetNetVar("irradiatedMin")) then
			client:SetNetVar("irradiatedMin", pos, client)
			client:NotifyLocalized("irradiatedAreaCommand")
		else
			local vMin = client:GetNetVar("irradiatedMin")
			local vMax = pos
			ix.irradiated.AddArea(vMin, vMax)

			client:SetNetVar("irradiatedMin", nil, client)
			client:NotifyLocalized("addedNewIrradiated")
		end
	end
})

ix.command.Add("RadAreaRemove", {
	description = "Remove an irradiated area.",
	adminOnly = true,
	OnRun = function(self, client, arguments)
		if (client.currentArea) then
			client:NotifyLocalized("irradiatedAreaRemoved")

			table.remove(PLUGIN.radAreas, client.currentArea)	
		else
			client:NotifyLocalized("irradiatedAreaBeArea")
		end
	end
})
