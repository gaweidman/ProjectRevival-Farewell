
RECIPE.name = "Combine Air Tank"
RECIPE.description = "Fill and pressurize an air tank."
RECIPE.model = "models/hlvr/characters/hazmat_worker/props/canister.mdl"
RECIPE.category = "Factory"

RECIPE.requirements = {
	["airtankempty"] = 1
}
RECIPE.results = {
	["airtank"] = 1
}

RECIPE:PostHook("OnCanCraft", function(client)
	for _, v in pairs(ents.FindByClass("ix_station_airpressurizer")) do
		if (client:GetPos():DistToSqr(v:GetPos()) < 100 * 100) then
			return true
		end
	end

	return false, "You need to be near an air pressurizer."
end)

/*
function RECIPE:OnCraft(client)
	local character = client:GetCharacter()

		stat = "gun"

		if (character and character:GetAttribute(stat, 0)) then
			local bonus = character:GetAttribute(stat, 0)
			local roll = tostring(math.random(0, 100))

			if bonus <= 3 then
				if (bonus + roll <= 85) then
					local explode = ents.Create( "env_explosion" ) //creates the explosion
						explode:SetPos(client:GetPos())
						explode:SetOwner(client) // this sets you as the person who made the explosion
						explode:Spawn() //this actually spawns the explosion
						explode:SetKeyValue( "iMagnitude", "220" ) //the magnitude
						explode:Fire( "Explode", 0, 0 )
						explode:EmitSound( "weapon_AWP.Single", 400, 400 ) //the sound for the explosion, and how far away it can be heard
					return false
				else
					return true
				end
			else
				if (bonus + roll <= 10) then
					local explode = ents.Create( "env_explosion" ) //creates the explosion
						explode:SetPos(client:GetPos())
						explode:SetOwner(client) // this sets you as the person who made the explosion
						explode:Spawn() //this actually spawns the explosion
						explode:SetKeyValue( "iMagnitude", "220" ) //the magnitude
						explode:Fire( "Explode", 0, 0 )
						explode:EmitSound( "weapon_AWP.Single", 400, 400 ) //the sound for the explosion, and how far away it can be heard
					return false
				else
					return true
				end
			end


			//ix.chat.Send(client, "roll", (roll + bonus).." ( "..roll.." + "..bonus.." )", nil, nil, { --tostring(math.random(0, 100))
				max = maximum
		end
end
*/

if (SERVER) then
	function RECIPE:OnCraft(client)
		local bCanCraft, failString, c, d, e, f = self:OnCanCraft(client)

		if (bCanCraft == false) then
			return false, failString, c, d, e, f
		end

		if (self.preHooks and self.preHooks["OnCraft"]) then
			local a, b, c, d, e, f = self.preHooks["OnCraft"](client)

			if (a != nil) then
				return a, b, c, d, e, f
			end
		end

		local character = client:GetCharacter()
		local inventory = character:GetInventory()

		if (self.requirements) then
			local removedItems = {}

			for id, itemTable in pairs(inventory:GetItems()) do
				local uniqueID = itemTable.uniqueID

				if (self.requirements[uniqueID]) then
					local amountRemoved = removedItems[uniqueID] or 0
					local amount = self.requirements[uniqueID]

					if (amountRemoved < amount) then
						inventory:Remove(id)

						removedItems[uniqueID] = amountRemoved + 1
					end
				end
			end
		end

		if (self.tools) then
			for id, itemTable in pairs(inventory:GetItems()) do
				local uniqueID = itemTable.uniqueID

				if (self.tools[uniqueID]) then
					if (itemTable.takeDurability) then
						itemTable:takeDurability(1)
					end
				end
			end
		end

		for uniqueID, amount in pairs(self.results or {}) do
			if (type(amount) == "table") then
				if (amount["min"] and amount["max"]) then
					amount = math.random(amount["min"], amount["max"])
				else
					amount = amount[math.random(1, #amount)]
				end
			end

			for i = 1, amount do
				if (!inventory:Add(uniqueID)) then
					ix.item.Spawn(uniqueID, client)
				end
			end
		end

		if (self.postHooks and self.postHooks["OnCraft"]) then
			local a, b, c, d, e, f = self.postHooks["OnCraft"](client)

			if (a != nil) then
				return a, b, c, d, e, f
			end
		end

		local character = client:GetCharacter()

		stat = "eng"

		if (character and character:GetAttribute(stat, 0)) then
			local bonus = character:GetAttribute(stat, 0)
			local roll = tostring(math.random(0, 100))

			if bonus <= 3 then
				if (bonus + roll <= 85) then
					local explode = ents.Create( "env_explosion" ) //creates the explosion
						explode:SetPos(client:GetPos())
						explode:SetOwner(client) // this sets you as the person who made the explosion
						explode:Spawn() //this actually spawns the explosion
						explode:SetKeyValue( "iMagnitude", "220" ) //the magnitude
						explode:Fire( "Explode", 0, 0 )
						explode:EmitSound( "weapon_AWP.Single", 400, 400 ) //the sound for the explosion, and how far away it can be heard
					return false
				end
			else
				if (bonus + roll <= 10) then
					local explode = ents.Create( "env_explosion" ) //creates the explosion
						explode:SetPos(client:GetPos())
						explode:SetOwner(client) // this sets you as the person who made the explosion
						explode:Spawn() //this actually spawns the explosion
						explode:SetKeyValue( "iMagnitude", "220" ) //the magnitude
						explode:Fire( "Explode", 0, 0 )
						explode:EmitSound( "weapon_AWP.Single", 400, 400 ) //the sound for the explosion, and how far away it can be heard
					return false
				end
			end


			//ix.chat.Send(client, "roll", (roll + bonus).." ( "..roll.." + "..bonus.." )", nil, nil, { --tostring(math.random(0, 100))
				max = maximum
		end

		return true, "@CraftSuccess", self.GetName and self:GetName() or self.name
	end
end