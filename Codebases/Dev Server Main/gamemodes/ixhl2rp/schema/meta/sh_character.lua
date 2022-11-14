
local CHAR = ix.meta.character

function CHAR:IsCombine()
	local faction = self:GetFaction()
	return faction == FACTION_MPF or faction == FACTION_OTA or faction == FACTION_ADMIN
end

function CHAR:HasBiosignal()
	local faction = self:GetFaction()
	return faction == FACTION_MPF or faction == FACTION_OTA or faction == FACTION_ADMIN
end


function CHAR:GetCombineDivision()
	local name = self:GetName()
	local nameSplit = string.Split(name, "-")
	local division = string.Split(nameSplit[2], ".")[1]
	return division
end

function CHAR:GetRank()
	local name = self:GetName()
	local nameSplit = string.Split(name, "-")
	local rankStr = string.Split(nameSplit[2], ".")[2]

	return rankStr	
end

function CHAR:GetDisplayEffects()
	ErrorNoHalt("GetDisplayEffects is obfuscated! Use GetEffects instead!")
	return self:GetEffects()
end

function CHAR:GetEffects()
	return self:GetData("Effects", {})
end

function CHAR:GetPerks()
	return self:GetData("Perks", {})
end

function CHAR:HasPerk(perk)
	return table.HasValue(self:GetData("Perks", {}), perk)
end

function CHAR:GetRankVal()
	local name = self:GetName()
	local rankStr = string.match(name, "i[1-5]")

	if rankStr == nil then
		rankStr = string.match(name, "%u%l%u")
	end

	if rankStr == nil then
		rankStr = string.match(name, "RCT")
	end

	print("RANK", rankStr)

	if self:GetFaction() == FACTION_MPF then

		return ix.ranks.CCA[rankStr] or -1

	end
end

function CHAR:IsVortigaunt()
	return (self:GetFaction() == FACTION_ALIEN and self:GetClass() == CLASS_FREEVORT) or (self:GetFaction() == FACTION_CAC and self:GetClass() == CLASS_VORTSLAVE)
end

function CHAR:IsFreeVortigaunt()
	return self:GetFaction() == FACTION_ALIEN and self:GetClass() == CLASS_FREEVORT
end

function CHAR:IsEnslavedVortigaunt()
	return self:GetFaction() == FACTION_CAC and self:GetClass() == CLASS_VORTSLAVE
end

function CHAR:GetLimbHealth(limb)
	local limbHealth = self:GetData("LimbHealth", {
		[HITGROUP_CHEST] = 100,
		[HITGROUP_HEAD] = 100,
		[HITGROUP_LEFTLEG] = 100,
		[HITGROUP_RIGHTLEG] = 100,
		[HITGROUP_LEFTARM] = 100,
		[HITGROUP_RIGHTARM] = 100,
		[HITGROUP_CHEST] = 100,
		[HITGROUP_STOMACH] = 100,
	})

	return limbHealth[limb]
end

function CHAR:GetAllLimbHealth()
	local limbHealth = self:GetData("LimbHealth", {
		[HITGROUP_CHEST] = 100,
		[HITGROUP_HEAD] = 100,
		[HITGROUP_LEFTLEG] = 100,
		[HITGROUP_RIGHTLEG] = 100,
		[HITGROUP_LEFTARM] = 100,
		[HITGROUP_RIGHTARM] = 100,
		[HITGROUP_CHEST] = 100,
		[HITGROUP_STOMACH] = 100,
	})

	return limbHealth
end

if SERVER then
	
	function CHAR:TakeLimbDamage(limb, damage)
		local limbHealth = self:GetData("LimbHealth", {
			[HITGROUP_CHEST] = 100,
			[HITGROUP_HEAD] = 100,
			[HITGROUP_LEFTLEG] = 100,
			[HITGROUP_RIGHTLEG] = 100,
			[HITGROUP_LEFTARM] = 100,
			[HITGROUP_RIGHTARM] = 100,
			[HITGROUP_STOMACH] = 100,
		})

		limbHealth[limb] = (limbHealth[limb] or 100) - damage

		if limbHealth[limb] <= 0 then limbHealth[limb] = 0 end

		local leftLegBroken, rightLegBroken = limbHealth[HITGROUP_LEFTLEG] == 0, limbHealth[HITGROUP_RIGHTLEG] == 0

		if leftLegBroken != rightLegBroken then
			self:GetPlayer():SetWalkSpeed(90)
			self:GetPlayer():SetRunSpeed(self:GetAttrRunSpeed() - 25)
		elseif leftLegBroken and rightLegBroken then
			self:GetPlayer():SetWalkSpeed(115)
			self:GetPlayer():SetRunSpeed(self:GetAttrRunSpeed() - 50)
		else
			self:GetPlayer():SetWalkSpeed(ix.config.Get("walkSpeed", 130))
			self:GetPlayer():SetRunSpeed(self:GetAttrRunSpeed())
		end

		self:SetData("LimbHealth", limbHealth)
	end

	function CHAR:SetLimbHealth(limb, health)
		local limbHealth = self:GetData("LimbHealth", {
			[HITGROUP_CHEST] = 100,
			[HITGROUP_HEAD] = 100,
			[HITGROUP_LEFTLEG] = 100,
			[HITGROUP_RIGHTLEG] = 100,
			[HITGROUP_LEFTARM] = 100,
			[HITGROUP_RIGHTARM] = 100,
			[HITGROUP_STOMACH] = 100,
		})

		limbHealth[limb] = health

		local leftLegBroken, rightLegBroken = limbHealth[HITGROUP_LEFTLEG] == 0, limbHealth[HITGROUP_RIGHTLEG] == 0

		if leftLegBroken != rightLegBroken then
			self:GetPlayer():SetWalkSpeed(90)
			self:GetPlayer():SetRunSpeed(self:GetAttrRunSpeed() - 25)
		elseif leftLegBroken and rightLegBroken then
			self:GetPlayer():SetWalkSpeed(115)
			self:GetPlayer():SetRunSpeed(self:GetAttrRunSpeed() - 50)
		else
			self:GetPlayer():SetWalkSpeed(ix.config.Get("walkSpeed", 130))
			self:GetPlayer():SetRunSpeed(self:GetAttrRunSpeed())
		end

		self:SetData("LimbHealth", limbHealth)
	end

	function CHAR:SetAllLimbHealth(healthTbl)
		self:SetData("LimbHealth", healthTbl)
	end

	function CHAR:StartBleeding()
		self:GetPlayer():Notify("[DEBUG] Bleeding")

		local ply = self:GetPlayer()
		local maxBleedTime = ix.config.Get("maxBleedTime", 30)
		local bleedTimerName = "ixBleed"..ply:SteamID()
		local bleedRate = ix.config.Get("bleedRate", 2) -- measured in seconds/health

		timer.Create(bleedTimerName, bleedRate, maxBleedTime/bleedRate, function()
			self:SetData("BleedTime", 0)
			local dmgInfo = DamageInfo()
			dmgInfo:SetDamage(1)
			dmgInfo:SetDamageType(DMG_DIRECT)
			dmgInfo:SetInflictor(ply)
			dmgInfo:SetAttacker(ply)

			ply:TakeDamageInfo(dmgInfo)

			bleedTime = self:GetData("BleedTime", 0)
			bleedTime = bleedTime + 1

			ply:Notify("[DEBUG] Bleed")

			-- we do this check in case maxBleedTime has changed while
			-- bleeding.
			if bleedTime >= ix.config.Get("maxBleedTime", 30) then
				self:SetData("BleedTime", -1)
				timer.Remove(bleedTimerName)
			else
				self:SetData("BleedTime", bleedTime)
				
				local plyPos = ply:GetPos()
				
				local tr = util.QuickTrace(plyPos + Vector(0, 0, 1), Vector(0, 0, -50), ply)

				util.Decal( "Blood", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal, ply )
				if ply:GetBloodColor() == BLOOD_COLOR_RED or true then
					
				end
			end
		end)
	end

	function CHAR:AddEffect(effect, timeOverride)
		local effList = self:GetData("Effects", {})
		-- indexing in the effectlist ensures we won't have duplicates
		-- it's all quite glorious, i assure you
		effList[effect] = {}

		if timeOverride then 
			effList[effect].endTime = CurTime() + timeOverride 
		else
			effList[effect].endTime = CurTime() + ix.effects.list[effect].length
		end 

		self:SetData("Effects", effList)
	end
	
end

function CHAR:GetIIN()
	if self:GetFaction() == FACTION_CITIZEN then
		return self:GetData("cid", "UNASSIGNED")
	elseif self:GetFaction() == FACTION_CONSCRIPT then
		return self:GetData("iin", "UNASSIGNED")
	else
		local name = self:GetName()
		return string.sub(name, #name - 4, #name)
	end
end


function CHAR:GetAttrRunSpeed()
	return 235 + (self:GetAttribute("agility", 5) - 5)*2
end 
-- not sure if i'll even use this
-- if so then i'll do it later
function CHAR:GetPerkDT()
	return DTTable()
end

function CHAR:GetWepRaiseTime()
	return Lerp(self:GetSkill("sleightofhand")/100, 0.5, 0.1)
end

function CHAR:IsFactionBreathable()
	local breatheFactions = {
		[FACTION_UU] = true,
		[FACTION_BIRD] = true,
		[FACTION_ALIEN] = true,
		[FACTION_CAC] = true,
		--i w[FACTION_OSA] = true
	}

	local immuneFaction = breatheFactions[self:GetFaction()]

	if !immuneFaction then
		immuneFaction = self:HasBiosignal()
	end

	return immuneFaction
end