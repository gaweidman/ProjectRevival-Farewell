if SERVER then
    hook.Add( "EntityTakeDamage", "NewArmor", function( ply, dmginfo )
        local baseDmg = dmginfo:GetDamage()
        local dmgType = dmginfo:GetDamageType()
        local inflictor = dmginfo:GetInflictor()
        local attacker = dmginfo:GetAttacker()
    
        
        if dmginfo:IsDamageType(DMG_DIRECT) then return end
    
    
    
    
        local isPulse = inflictor and inflictor:GetClass() == "weapon_ar2" or false
    
        local singleDmgType = math.log(dmgType, 2)%1 == 0
        
        if dmgType > 512 then
            dmgType = ix.util.GetMainDmgType(dmgType)
        end

        if attacker.GetCharacter and attacker:GetCharacter() and dmgType == DMG_SLASH or dmgType == DMG_CLUB then
            baseDmg = baseDmg*Lerp(attacker:GetCharacter():GetSkill("handtohand")/100, 1.4, 0.6)
        end
    
        local newDmg, armorAbsorbed = ix.util.CalcDamage(ply, baseDmg, dmgType, isPulse)
        
        if !armorAbsorbed and (dmgType == DMG_BULLET or dmgType == DMG_SLASH) and !isPulse then
            --ply:GetCharacter():StartBleeding()
        end
    
        dmginfo:SetDamage(newDmg)
    
        if ply.GetCharacter == nil then return end
        local char = ply:GetCharacter()
    
        
    
        local limb = ply:LastHitGroup()
        local limbDmg = baseDmg*0.2
    
        
        -- I originally wanted a limb DT system, but the damage loss in that is too low, it makes all damage
        -- completely insignificant.
    
        local char = ply:GetCharacter()
    
        if dmginfo:IsFallDamage() then
            char:TakeLimbDamage(HITGROUP_LEFTLEG, newDmg*1.25)
            char:TakeLimbDamage(HITGROUP_RIGHTLEG, newDmg*1.25)
        elseif dmginfo:IsExplosionDamage() then
            char:TakeLimbDamage(HITGROUP_LEFTLEG, newDmg*0.2)
            char:TakeLimbDamage(HITGROUP_RIGHTLEG, newDmg*0.2)
            char:TakeLimbDamage(HITGROUP_HEAD, newDmg*0.2)
            char:TakeLimbDamage(HITGROUP_STOMACH, newDmg*0.2)
            char:TakeLimbDamage(HITGROUP_CHEST, newDmg*0.2)
            char:TakeLimbDamage(HITGROUP_LEFTARM, newDmg*0.2)
            char:TakeLimbDamage(HITGROUP_RIGHTARM, newDmg*0.2)
        elseif limb == HITGROUP_GENERIC then
            
        else
            char:TakeLimbDamage(limb, limbDmg)
        end
        
    
        if dmginfo:IsFallDamage() or dmginfo:IsExplosionDamage() or limb == HITGROUP_RIGHTLEG or limb == HITGROUP_LEFTLEG then
            -- we're doing a constitution check when the player tries to get up
            -- i think it's a good way to use constitution for something other than health and natural DT
            local constitution = char:GetAttribute("constitution", 5)
    
            local roll = math.random(1, 13)
    
            --dmginfo:SetDamage(0)
    
            if roll > constitution + 3 then
                -- setting this to zero so people can roleplay being too weak to get up if they want.
                -- we can factor in get up time when the player tries to get up.
                local acrobatics = char:GetSkill("acrobatics")
                local getUpTime = Lerp(acrobatics/100, 3, 1.5)
    
                ply:SetRagdolled(true, getUpTime, 0)
                local physObj = ply.ixRagdoll:GetPhysicsObject()
                local massCenter = physObj:LocalToWorld(physObj:GetMassCenter())
    
                local dmgPos = dmginfo:GetDamagePosition()
    
                physObj:ApplyForceCenter(dmginfo:GetDamageForce())
    
                --physObj:ApplyForceCenter(Vector force)
            end
        end	
    end)
end

local entityMeta = FindMetaTable("Entity")

function entityMeta:GetBaseDT()
	
    if self:IsPlayer() then
        local char = self:GetCharacter()
        local model = self:GetModel()
        local faction = char:GetFaction()
        local class = char:GetClass()

		local armorResist = {}

        if self:WearingFactionArmor(FACTION_MPF) and self:GetModel() == "models/police_nemez.mdl" then
            return {
                ["Sharp"] = 3,
                ["Blunt"] = 2, 
                ["Bullet"] = 3,
                ["Pulse"] = 1,
                ["Shock"] = 1,
                ["Blast"] = 3
            }
        elseif self:WearingFactionArmor(FACTION_OTA) then
			local armorTables = {
				["models/romka/romka_combine_soldier.mdl"] = {
					-- Regular Soldier
					["Sharp"] = 3,
					["Blunt"] = 4, 
					["Bullet"] = 5,
					["Pulse"] = 6,
					["Shock"] = 3,
					["Blast"] = 4
				},
				["models/hlvr/characters/combine/grunt/combine_grunt_hlvr_npc.mdl"] = {
					-- Grunt
					["Sharp"] = 1,
					["Blunt"] = 2, 
					["Bullet"] = 3,
					["Pulse"] = 4,
					["Shock"] = 7,
					["Blast"] = 2
				},
				["models/hlvr/characters/combine/heavy/combine_heavy_hlvr_npc.mdl"] = {
					-- Wallhammer
					["Sharp"] = 6,
					["Blunt"] = 5, 
					["Bullet"] = 8,
					["Pulse"] = 7,
					["Shock"] = 5,
					["Blast"] = 7
				},
				["models/hlvr/characters/combine_captain/combine_captain_hlvr_npc.mdl"] = {
					-- Ordinal
					["Sharp"] = 4,
					["Blunt"] = 3, 
					["Bullet"] = 6,
					["Pulse"] = 5,
					["Shock"] = 4,
					["Blast"] = 5
				},
				["models/hlvr/characters/combine/suppressor/combine_suppressor_hlvr_npc.mdl"] = {
					-- Suppressor
					["Sharp"] = 5,
					["Blunt"] = 4, 
					["Bullet"] = 7,
					["Pulse"] = 6,
					["Shock"] = 6,
					["Blast"] = 6
				},
				["models/romka/rtb_elite.mdl"] = {
					-- Elite
					["Sharp"] = 4,
					["Blunt"] = 3, 
					["Bullet"] = 6,
					["Pulse"] = 7,
					["Shock"] = 6,
					["Blast"] = 5
				}
			}

			return armorTables[model]
        elseif self:WearingFactionArmor(FACTION_CONSCRIPT) then
            local model = self:GetModel()
			local wearingFlak = false

            if self:IsFemale() then
				-- if the player is wearing a flak jacket
                if self:GetBodygroup(1) == 1 then 
					wearingFlak = true 
				end
            else
				-- if the player is wearing a flak jacket
                if !string.find(model, "novest", 1, true) then 
                    wearingFlak = true
                end 

				-- if the player is wearing a helmet
                if self:GetBodygroup(1) == 1 then 
					totalDT = totalDT + 1
				end
            end

			return totalDT
        elseif faction == FACTION_OSA then

            if class == IXCLASS_HUNTER then return 8
            elseif class == IXCLASS_STALKER then return 0
            elseif class == IXCLASS_CMBGUARD then return 18
            elseif class == IXCLASS_ASSASSIN then return 5 end

        elseif self:HasAlienModel() then

			local armorTables = {

			}
            
        elseif faction == FACTION_CAC then
            local armorTables = {
				[IXCLASS_CREMATOR] = {}
			}

            if class == IXCLASS_CREMATOR then return 3
            elseif class == IXCLASS_VORTSLAVE then return 7
			end

		else
			return DTTable()
		end
    else
        local class = self:GetClass()

        if class == 0 then end
    end
end

function entityMeta:IsTwoHanded()
    return !self:IsOneHanded()
end

function entityMeta:WearingFactionArmor(faction)
	local modelSearches = {
		[FACTION_CONSCRIPT] = function(model)
			return string.find(model, "wichacks") != nil
		end,

		[FACTION_OTA] = function(model)
			return (string.find(model, "hlvr/characters/combine") != nil) or model == "models/romka/romka_combine_soldier.mdl" or model == "models/romka/rtb_elite.mdl"
		end,

		[FACTION_MPF] = function(model)
			return model == "models/police_nemez.mdl"
		end
	}

	if modelSearches[faction] then
		local checkFunc = modelSearches[faction]
		return checkFunc(self:GetModel())
	else
		return false
	end
	
end

function entityMeta:IsOneHanded()
    if !self:IsWeapon() then return nil end

    local holdType = self:GetHoldType()

    return holdType == "pistol" or holdType == "grenade" or holdType == "revolver"
end

function DTTable(sharp, blunt, bullet, pulse, shock, blast)
	local thisTable = {
		["Sharp"] = sharp or 0,
		["Blunt"] = blunt or 0, 
		["Bullet"] = bullet or 0,
		["Pulse"] = pulse or 0,
		["Shock"] = shock or 0,
		["Blast"] = blast or 0
	}

	return thisTable
end	

local dmgConvTbl = {
	[DMG_BULLET] = "Bullet",
	[DMG_BLAST] = "Blast",
	[DMG_SLASH] = "Sharp",
	[DMG_CLUB] = "Blunt",
	[DMG_SHOCK] = "Shock",
	[DMG_SONIC] = "Blunt"
}

-- Takes a damage type and damage and calculates the amount of damage taken based on the resistance to that damage.
-- Args: Player ply, number bitDmgType, number dmgAmt, boolean isPulse
-- Returns: number damage, boolean  armorAbsorbed
function ix.util.CalcDamage(ent, dmgAmt, bitDmgType, isPulse)

	local char
	if !ent.GetCharacter then
        print("not a characet")
		return dmgAmt
	else
		char = ent:GetCharacter()
	end

	local armorTable = ent:GetBaseDT()
	armorTable = ix.util.AddDT(armorTable, char:GetEquipmentDT())
	armorTable = ix.util.AddDT(armorTable, char:GetPerkDT())

	
	-- Pulse weapons are a bit different, it doesn't have a straight conversion.

	local dmgType = dmgConvTbl[bitDmgType]

	if dmgType then
		local calcDT = armorTable[dmgType]
		return math.max(dmgAmt - calcDT, dmgAmt*0.2), calcDT >= dmgAmt
	else
		return dmgAmt
	end

	
end

function ix.util.CalcDamageEx(ent, dmgAmt, bitDmgType, isPulse, targetDTTable)

	if !ent.GetCharacter then
		return dmgAmt
	else
		char = ent:GetCharacter()
	end
	
	-- Pulse weapons are a bit different, it doesn't have a straight conversion.

	local dmgType = dmgConvTbl[bitDmgType]

	if dmgType then
		local calcDT = targetDTTable[dmgType]
		return math.max(dmgAmt - calcDT, dmgAmt*0.2), calcDT >= dmgAmt
	else
		return dmgAmt
	end

	
end

function ix.util.GetStrDmgType(dmgType, isPulse)
	if isPulse then 
		return "Pulse"
	else
		return dmgConvTbl[dmgType]
	end
end

function ix.util.GetMainDmgType(dmgType)
	local bin = math.IntToBin(dmgType)
	bin = string.sub(bin, 1, 10)

	local bitPos = string.find(bin, "1")
	return math.pow(2, bitPos/3)
end

-- Adds two DTTables together and returns the result.
function ix.util.AddDT(tbl1, tbl2)
	local result = DTTable()

	for k, v in pairs(tbl1) do
		result[k] = v + tbl2[k]
	end

	return result
end

local CHAR = ix.meta.character

function CHAR:GetDT()
	return self:GetEquipmentDT()
end

function CHAR:GetEquipmentDT()
	local inv = self:GetInventory()
	local items = inv:GetItems(true)


    print("CHECKING EQUOIP")

	local totalDT = DTTable()

	for _, item in pairs(items) do
		if item:GetData("equip") then
            print("iuqneif", item.uniqueID)
			local itemDT = ix.item.list[item.uniqueID].dt or DTTable()

			totalDT = ix.util.AddDT(totalDT, itemDT)
		end
	end

    print("checked eiuqipem")


	return totalDT
end