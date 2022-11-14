ITEM.name = "Rebel Trooper Uniform"
ITEM.desc = "The uniform of a rebel trooper."
ITEM.category = "Outfit"
ITEM.model = "models/props_c17/BriefCase001a.mdl"
ITEM.width = 2
ITEM.height = 4
ITEM.outfitCategory = "model"
ITEM.replacements = "models/props_c17/oildrum001.mdl"

if (CLIENT) then
	-- Draw camo if it is available.
	function ITEM:paintOver(item, w, h)
		if (item:getData("equip")) then
			surface.SetDrawColor(110, 255, 110, 100)
			surface.DrawRect(w - 14, h - 14, 8, 8)
		end
	end
end

function ITEM:removeOutfit(client)
	local character = client:getChar()
	
	self:setData("equip", false)

	if (character:getData("oldMdl")) then
		character:setModel(character:getData("oldMdl"))
		character:setData("oldMdl", nil)
	end
	
	if (self.newSkin) then
		if (character:getData("oldSkin")) then
			client:SetSkin(character:getData("oldSkin"))
			character:setData("oldSkin", nil)
		else
			client:SetSkin(0)
		end
	end

	for k, v in pairs(self.bodyGroups or {}) do
		local index = client:FindBodygroupByName(k)

		if (index > -1) then
			client:SetBodygroup(index, 0)

			local groups = character:getData("groups", {})

			if (groups[index]) then
				groups[index] = nil
				character:setData("groups", groups)
			end
		end
	end

	if (self.attribBoosts) then
		for k, _ in pairs(self.attribBoosts) do
			character:removeBoost(self.uniqueID, k)
		end
	end
end

-- On item is dropped, Remove a weapon from the player and keep the ammo in the item.
ITEM:hook("drop", function(item)
	if (item:getData("equip")) then
		item:removeOutfit(item.player)
	end
end)

-- On player uneqipped the item, Removes a weapon from the player and keep the ammo in the item.
ITEM.functions.EquipUn = { -- sorry, for name order.
	name = "Unequip",
	tip = "equipTip",
	icon = "icon16/cross.png",
	onRun = function(item)
		item:removeOutfit(item.player)
		
		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") == true)
	end
}

-- On player eqipped the item, Gives a weapon to player and load the ammo data from the item.
ITEM.functions.Equip = {
	name = "Equip",
	tip = "equipTip",
	icon = "icon16/tick.png",
	onRun = function(item)
		local char = item.player:getChar()
		local items = char:getInv():getItems()

		for k, v in pairs(items) do
			if (v.id != item.id) then
				local itemTable = nut.item.instances[v.id]

				if (itemTable.pacData and v.outfitCategory == item.outfitCategory and itemTable:getData("equip")) then
					item.player:notify("You're already equipping this kind of outfit")

					return false
				end
			end
		end

		item:setData("equip", true)
		
		if (type(item.onGetReplacement) == "function") then
			char:setData("oldMdl", char:getData("oldMdl", item.player:GetModel()))
			if (char:getModel() == "models/humans/group01/male_01.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_01.mdl")
			elseif (char:getModel() == "models/humans/group01/male_02.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_02.mdl")
			elseif (char:getModel() == "models/humans/group01/male_03.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_03.mdl")
			elseif (char:getModel() == "models/humans/group01/male_04.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_04.mdl")
			elseif (char:getModel() == "models/humans/group01/male_05.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_05.mdl")
			elseif (char:getModel() == "models/humans/group01/male_06.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_06.mdl")
			elseif (char:getModel() == "models/humans/group01/male_07.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_07.mdl")
			elseif (char:getModel() == "models/humans/group01/male_08.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_08.mdl")
			elseif (char:getModel() == "models/humans/group01/male_09.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_09.mdl")
			elseif (char:getModel() == "models/humans/group02/tale_01.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_01.mdl")
			elseif (char:getModel() == "models/humans/group02/tale_03.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_03.mdl")
			elseif (char:getModel() == "models/humans/group02/tale_04.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_04.mdl")
			elseif (char:getModel() == "models/humans/group02/tale_05.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_05.mdl")
			elseif (char:getModel() == "models/humans/group02/tale_06.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_06.mdl")
			elseif (char:getModel() == "models/humans/group02/tale_07.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_07.mdl")
			elseif (char:getModel() == "models/humans/group02/tale_08.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_08.mdl")
			elseif (char:getModel() == "models/humans/group02/tale_09.mdl") then
				char:setModel("models/sgg/starwars/rebels/r_trooper/male_09.mdl")
			else
				client:notifyLocalized("cantEquip")
				item:setData("equip", false)
			end
		elseif (item.replacement or item.replacements) then
			char:setData("oldMdl", char:getData("oldMdl", item.player:GetModel()))

			if (type(item.replacements) == "table") then
				if (#item.replacements == 2 and type(item.replacements[1]) == "string") then
					char:setModel(item.player:GetModel():gsub(item.replacements[1], item.replacements[2]))
				else
					for k, v in ipairs(item.replacements) do
						char:setModel(item.player:GetModel():gsub(v[1], v[2]))
					end
				end
			else
				if (char:getModel() == "models/humans/group01/male_01.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_01.mdl")
				elseif (char:getModel() == "models/humans/group01/male_02.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_02.mdl")
				elseif (char:getModel() == "models/humans/group01/male_03.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_03.mdl")
				elseif (char:getModel() == "models/humans/group01/male_04.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_04.mdl")
				elseif (char:getModel() == "models/humans/group01/male_05.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_05.mdl")
				elseif (char:getModel() == "models/humans/group01/male_06.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_06.mdl")
				elseif (char:getModel() == "models/humans/group01/male_07.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_07.mdl")
				elseif (char:getModel() == "models/humans/group01/male_08.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_08.mdl")
				elseif (char:getModel() == "models/humans/group01/male_09.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_09.mdl")
				elseif (char:getModel() == "models/humans/group02/tale_01.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_01.mdl")
				elseif (char:getModel() == "models/humans/group02/tale_03.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_03.mdl")
				elseif (char:getModel() == "models/humans/group02/tale_04.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_04.mdl")
				elseif (char:getModel() == "models/humans/group02/tale_05.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_05.mdl")
				elseif (char:getModel() == "models/humans/group02/tale_06.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_06.mdl")
				elseif (char:getModel() == "models/humans/group02/tale_07.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_07.mdl")
				elseif (char:getModel() == "models/humans/group02/tale_08.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_08.mdl")
				elseif (char:getModel() == "models/humans/group02/tale_09.mdl") then
					char:setModel("models/sgg/starwars/rebels/r_trooper/male_09.mdl")
				else
					item.player:notifyLocalized("cantEquip")
					item:setData("equip", false)
				end
			end
		end
		
		if (item.newSkin) then
			char:setData("oldSkin", item.player:GetSkin())
			item.player:SetSkin(item.newSkin)
		end
		
		if (item.bodyGroups) then
			local groups = {}

			for k, value in pairs(item.bodyGroups) do
				local index = item.player:FindBodygroupByName(k)

				if (index > -1) then
					groups[index] = value
				end
			end

			local newGroups = char:getData("groups", {})

			for index, value in pairs(groups) do
				newGroups[index] = value
				item.player:SetBodygroup(index, value)
			end

			if (table.Count(newGroups) > 0) then
				char:setData("groups", newGroups)
			end
		end

		if (item.attribBoosts) then
			for k, v in pairs(item.attribBoosts) do
				char:addBoost(item.uniqueID, k, v)
			end
		end
		
		return false
	end,
	onCanRun = function(item)
		return (!IsValid(item.entity) and item:getData("equip") != true)
	end
}

function ITEM:onCanBeTransfered(oldInventory, newInventory)
	if (newInventory and self:getData("equip")) then
		return false
	end

	return true
end

ITEM:hook("Equip", function(item) item.player:SetArmor(10) end)
ITEM:hook("EquipUn", function(item) item.player:SetArmor(0) end)