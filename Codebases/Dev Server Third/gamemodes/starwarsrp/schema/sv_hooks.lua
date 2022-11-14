SIGNAL_DEATH = 1
SIGNAL_CHAR = 2
SIGNAL_CLASS = 3

-- This hook restricts oneself from using a weapon that configured by the sh_config.lua file.
function SCHEMA:CanPlayerInteractItem(client, action, item)
	local char = client:getChar()

	if (action == "drop" or action == "take") then
		return
	end

	local itemTable
	if (type(item) == "Entity") then
		if (IsValid(item)) then
			itemTable = nut.item.instances[item.nutItemID]
		end
	else
		itemTable = nut.item.instances[item]
	end

	if (itemTable and itemTable.isWeapon) then
		local reqattribs = WEAPON_REQSKILLS[itemTable.uniqueID]
		
		if (reqattribs) then
			for k, v in pairs(reqattribs) do
				local attrib = char:getAttrib(k, 0)
				if (attrib < v) then
					client:notify(L("requireAttrib", client, L(nut.attribs.list[k].name, client), attrib, v))

					return false
				end
			end
		end
	end
end

function SCHEMA:OnPlayerDropWeapon(client, item, entity)
	local physObject = entity:GetPhysicsObject()
	
	if (physObject) then
		physObject:EnableMotion()
	end

	timer.Simple(30, function()
		if (entity and entity:IsValid()) then
			entity:Remove()
		end
	end)
end

local function item2world(inv, item, pos)
	item.invID = 0

	inv:remove(item.id, false, true)
	
	nut.db.query("UPDATE nut_items SET _invID = 0 WHERE _itemID = "..item.id)

	local ent = item:spawn(pos)	
	
	if (IsValid(ent)) then
		timer.Simple(0, function()
			local phys = ent:GetPhysicsObject()
			
			if (IsValid(phys)) then
				phys:EnableMotion(true)
				phys:Wake()
			end
		end)
	end

	return ent
end

-- This hook enforces death penalty for dead players.
function SCHEMA:PlayerDeath(client, inflicter, attacker)
	local char = client:getChar()

	if (char) then
		hook.Run("ResetVariables", client, SIGNAL_DEATH)

		-- weapon penalty
		local inv = char:getInv()
		local items = inv:getItems()

		for k, v in pairs(items) do
			-- BE CAREFUL!
			-- If you want to create something like this, You need to be careful with this.
			-- Wrong inventory allocation will cause item verification issue.

			inv = nut.item.inventories[v.invID]

			if (DROPITEM[v.uniqueID]) then
				local ent = item2world(inv, v, client:GetPos() + Vector(0, 0, 10))

				hook.Run("OnPlayerDropItem", client, v, ent)
			end

			if (v.isWeapon) then
				if (v:getData("equip")) then
					v:setData("ammo", nil)
					v:setData("equip", nil)

					if (nut.config.get("deathWeapon", false)) then
						local ent = item2world(inv, v, client:GetPos() + Vector(0, 0, 10))

						hook.Run("OnPlayerDropWeapon", client, v, ent)
					end
				end
			end
		end
	end
end


function SCHEMA:OnPlayerDropWeapon(client, item, entity)
	timer.Simple(30, function()
		if (entity and entity:IsValid()) then
			entity:Remove()
		end
	end)
end

-- On character is created, Give him some money and items. 
function SCHEMA:OnCharCreated(client, char)
	if (char) then
		local inv = char:getInv()

		if (inv) then
			local stItems = self.startItems or {}
			for _, item in ipairs(stItems) do
				if (item[1] and item[2]) then
					inv:add(item[1], item[2], item[3])
				end
			end
		end

		char:giveMoney(nut.config.get("startMoney", 0))
	end
end

function SCHEMA:OnPlayerJoinClass(client, class, oldclass, silent)
	hook.Run("ResetVariables", client, SIGNAL_CLASS)
end

-- The code below restricts any admins to edit confing of the server
/*
local yay = {
	["STEAM_0:0:00000000"] = true,
	["STEAM_0:1:00000000"] = true,
	["STEAM_0:0:00000000"] = true,
}
function SCHEMA:CanPlayerModifyConfig(client)
	local steamid = client:SteamID()

	if (yay[steamid]) then
		return true
	end

	return false
end
*/

function SCHEMA:ResetVariables(client, signal)
	local char = client:getChar()
	if (signal == SIGNAL_DEATH) then
		print("player dead, resetting player related variables")
	end

	if (signal == SIGNAL_CLASS) then
		print("player changed class, resetting class related variables")
	end

	if (signal == SIGNAL_CHAR) then
		print("switched char, resetting character related variables")
	end
end