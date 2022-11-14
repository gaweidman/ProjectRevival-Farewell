
--[[
Copyright 2018 - 2019 Igor Radovanovic
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]


local PLUGIN = PLUGIN

PLUGIN.name = "Persistent Corpses"
PLUGIN.author = "`impulse, Frosty"
PLUGIN.description = "Makes player corpses stay on the map after the player has respawned."
PLUGIN.hardCorpseMax = 64

ix.config.Add("persistentCorpses", true, "Whether or not corpses remain on the map after a player dies and respawns.", nil, {
	category = "Persistent Corpses"
})

ix.config.Add("corpseMax", 8, "Maximum number of corpses that are allowed to be spawned.", nil, {
	data = {min = 0, max = PLUGIN.hardCorpseMax},
	category = "Persistent Corpses"
})

ix.config.Add("corpseDecayTime", 60, "How long it takes for a corpse to decay in seconds. Set to 0 to never decay.", nil, {
	data = {min = 0, max = 1800},
	category = "Persistent Corpses"
})

ix.config.Add("dropItemsOnDeath", true, "Whether or not to drop specific items on death.", nil, {
	category = "Persistent Corpses"
})

ix.config.Add("deathWeaponDura", true, "If true weapons will take damage.", nil, {
	category = "Persistent Corpses"
})

ix.config.Add("deathWeaponDuraDmg", 4, "How much damage a weapon will take from a playerdeath.", nil, {
	data = {min = 0, max = 10},
	category = "Persistent Corpses"
})

ix.config.Add("deathItemMaxDrop", 5, "How many items that can drop from one death.", nil, {
	data = {min = 0, max = 50},
	category = "Persistent Corpses"
})

ix.config.Add("deathItemDropChance", 75, "How big the chance to drop items is.", nil, {
	data = {min = 1, max = 100},
	category = "Persistent Corpses"
})

ix.config.Add("dropMoneyOnDeath", true, "Whether or not to drop money on death.", nil, {
	category = "Persistent Corpses"
})

do
	ix.lang.AddTable("english", {
		itemLost = "You've lost item %s.",
		moneyLost = "You've lost %s.",
	})

	ix.lang.AddTable("korean", {
		itemLost = "당신은 아이템 %s을(를) 잃었습니다.",
		moneyLost = "당신은 %s을(를) 잃었습니다.",
	})
end

if (SERVER) then
	PLUGIN.corpses = {}

	-- disable the regular hl2 ragdolls
	function PLUGIN:ShouldSpawnClientRagdoll(client)
		return false
	end

	function PLUGIN:PlayerSpawn(client)
		client:SetLocalVar("ragdoll", nil)
	end

	function PLUGIN:ShouldRemoveRagdollOnDeath(client)
		return false
	end

	function PLUGIN:PlayerInitialSpawn(client)
		self:CleanupCorpses()
	end

	function PLUGIN:CleanupCorpses(maxCorpses)
		maxCorpses = maxCorpses or ix.config.Get("corpseMax", 8)
		local toRemove = {}

		if (#self.corpses > maxCorpses) then
			for k, v in ipairs(self.corpses) do
				if (!IsValid(v)) then
					toRemove[#toRemove + 1] = k
				elseif (#self.corpses - #toRemove > maxCorpses) then
					v:Remove()
					toRemove[#toRemove + 1] = k
				end
			end
		end

		for k, _ in ipairs(toRemove) do
			table.remove(self.corpses, k)
		end
	end

	function PLUGIN:DoPlayerDeath(client, attacker, damageinfo)
		if (!ix.config.Get("persistentCorpses", true)) then
			return
		end

		if (hook.Run("ShouldSpawnPlayerCorpse") == false) then
			return
		end

		-- remove old corpse if we've hit the limit
		local maxCorpses = ix.config.Get("corpseMax", 8)

		if (maxCorpses == 0) then
			return
		end

		local entity = IsValid(client.ixRagdoll) and client.ixRagdoll or client:CreateServerRagdoll()
		local decayTime = ix.config.Get("corpseDecayTime", 60)
		local uniqueID = "ixCorpseDecay" .. entity:EntIndex()

		entity:RemoveCallOnRemove("fixer")
		entity:CallOnRemove("ixPersistentCorpse", function(ragdoll)

			if (IsValid(client) and !client:Alive()) then
				client:SetLocalVar("ragdoll", nil)
			end

			local index

			for k, v in ipairs(PLUGIN.corpses) do
				if (v == ragdoll) then
					index = k
					break
				end
			end

			if (index) then
				table.remove(PLUGIN.corpses, index)
			end

			if (timer.Exists(uniqueID)) then
				timer.Remove(uniqueID)
			end
		end)

		-- start decay process only if we have a time set
		if (decayTime > 0) then
			timer.Create(uniqueID, decayTime, 1, function()
				if (IsValid(entity)) then
					entity:Remove()
				else
					timer.Remove(uniqueID)
				end
			end)
		end

		-- remove reference to ragdoll so it isn't removed on spawn when SetRagdolled is called
		client.ixRagdoll = nil
		-- remove reference to the player so no more damage can be dealt
		entity.ixPlayer = nil

		self.corpses[#self.corpses + 1] = entity

		-- clean up old corpses after we've added this one
		if (#self.corpses >= maxCorpses) then
			self:CleanupCorpses(maxCorpses)
		end

		hook.Run("OnPlayerCorpseCreated", client, entity)
	end

	function PLUGIN:OnPlayerCorpseCreated(client, entity)
		if (!client:GetCharacter()) then
			return
		end
		
		if (ix.config.Get("dropItemsOnDeath", false)) then
			local items = client:GetCharacter():GetInventory():GetItems(false)
			local itemNames = {}
			local counter = 0

			for k, item in pairs( items ) do
				if (item:GetData("equip", false) and item.base == ("base_armor" or "base_outfit" or "base_pacoutfit")) then
					if item:GetData("Durability", false) then
						if ix.config.Get("deathWeaponDura") then
							item:SetData("Durability", math.max( item:GetData("Durability") - math.random(ix.config.Get("deathWeaponDuraDmg", 4) * item.maxDurability * 0.1), 0))
						end
					end
				else
					if (item:GetData("equip", false)) then
						item:SetData("equip", nil)
					end
					
					if item:GetData("Durability", false) then
						if ix.config.Get("deathWeaponDura") then
							item:SetData("Durability", math.max( item:GetData("Durability") - math.random(ix.config.Get("deathWeaponDuraDmg",4) * item.maxDurability * 0.1), 0))
						end
					end
					
					if (item.noDeathDrop != true) then
						if (counter < ix.config.Get("deathItemMaxDrop", 1)) then
							if math.random(100) < ix.config.Get("deathItemDropChance", 50) then
								if (ix.config.Get("dropItemsOnDeath")) then
									item:Transfer()
									if item:GetEntity() then
										item:GetEntity():SetPos(client:GetPos() + Vector( math.Rand(-8,8), math.Rand(-8,8), counter * 5 ))
									end
								else
									item:remove()
								end
								table.Add(itemNames, {item.name})
								counter = counter + 1
							end
						end
					end
				end
			end
			
			if client:Alive() then
				for j, name in pairs(itemNames) do
					client:NotifyLocalized("itemLost", name)
				end
			else
				-- timer.Simple(ix.config.Get("spawnTime", 5) + 1, function()
					for j, name in pairs(itemNames) do
						client:NotifyLocalized("itemLost", name)
					end
				-- end)
			end
		end
		
		if (ix.config.Get("dropMoneyOnDeath", false) and !client:IsAdmin()) then
			local amount = math.random(client:GetCharacter():GetMoney()/2)
			
			if (amout > 0) then
				client:GetCharacter():TakeMoney(amount)
				ix.currency.Spawn(client:GetPos() + Vector( math.Rand(-8,8), math.Rand(-8,8), 5), amount)
				
					-- timer.Simple(ix.config.Get("spawnTime", 5) + 1, function()
						client:NotifyLocalized( "moneyLost", ix.currency.Get(amount) )
					-- end)
				--end
			end
		end
	end
end
