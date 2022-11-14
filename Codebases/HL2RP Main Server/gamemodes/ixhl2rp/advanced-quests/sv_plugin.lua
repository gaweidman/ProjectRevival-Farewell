local L = Format

ix.log.AddType("addquests", function(client, ...)
	local arg = {...}
	return L("LOG Quests : %s got the '%s' quest (Unique ID : '%s').", client:GetCharacter():GetName(), arg[1], arg[2])
end, FLAG_SUCCESS)

ix.log.AddType("removequests", function(client, ...)
	local arg = {...}
	return L("LOG Quests : %s finished the '%s' quest (Unique ID : '%s').", client:GetCharacter():GetName(), arg[1], arg[2])
end, FLAG_SUCCESS)

ix.log.AddType("cancelquests", function(client, ...)
	local arg = {...}
	return L("LOG Quests : %s to give up the '%s' quest (Unique ID : '%s').", client:GetCharacter():GetName(), arg[1], arg[2])
end, FLAG_WARNING)

local playerMeta = FindMetaTable("Player") 

function playerMeta:AddQuest(quest)

	if quest then 
		for k, v in pairs(GLOBAL_Quests) do  
			local client = self
			local char = client:GetCharacter()
			local data = char:GetData("quests", {})

			if quest == k then 
				data[#data + 1] = k

				char:SetData("quests", data) 
				ix.log.Add(client, "addquests", v.name, k) 
			end 
		end 
	end  
end

function playerMeta:RemoveQuest(quest)

	local client = self
	local character = client:GetCharacter()
	local data = character:GetData("quests", {})
	local finishdata = character:GetData("finishquests", {})

	for k, v in pairs(data) do
		if v == quest then

			for k2, v2 in pairs(GLOBAL_Quests) do
				if v == k2 then

					ix.log.Add(client, "removequests", v2.name, v) 

					finishdata[#data + 1] = v
					table.RemoveByValue( data, v )

					character:SetData("finishquests", finishdata)
					character:SetData("quests", data)
				end
			end
		end
	end
end 

function playerMeta:CancelQuest(quest) 

	local client = self
	local character = client:GetCharacter()
	local data = character:GetData("quests", {})

	for k, v in pairs(data) do
		if v == quest then

			for k2, v2 in pairs(GLOBAL_Quests) do
				if v == k2 then

					ix.log.Add(client, "cancelquests", v2.name, v) 

					table.RemoveByValue( data, v )

					character:SetData("quests", data)
				end
			end
		end
	end
end 


netstream.Hook("GetQuest", function(ply, data)
	if ply:GetCharacter():GetData("quests", {}) == false then
		ply:Notify("A problem has occurred, please contact a developer.")

		return
	else
		local ent = data[1]
		local quests = ent:GetNetVar("quests", {})

		if table.Count(quests) > 0 then
			ply:AddQuest(data[2])

			for k, v in pairs(GLOBAL_Quests) do
				if k == data[2] then
					ply:Notify("You have started a quest : " .. v.name)
				end
			end
		else
			ply:Notify("This NPC has no quests available, but the dialog option has appeared anyway, contact a developer.")

			return
		end
	end
end)

netstream.Hook("DialogueOptionAdd", function(ply, data)
	local dialogue_key = data[1]
	local dialogue_table = data[2]
	local ent = data[3]

	if ent then
		local curdata = ent:GetNetVar("dialogue", {})
		table.insert(curdata, dialogue_key)
		ent:SetNetVar("dialogue", curdata)
	else
		print("You tried to add a dialog to a non-existing NPC!")
	end
end)

netstream.Hook("DialogueOptionRemove", function(ply, data)
	local dialogue_key = data[1]
	local dialogue_table = data[2]
	local ent = data[3]

	if ent then
		local curdata = ent:GetNetVar("dialogue", {})
		table.RemoveByValue(curdata, dialogue_key)
		ent:SetNetVar("dialogue", curdata)
	else
		print("You tried to delete a dialog to a non-existing NPC!")
	end
end)

netstream.Hook("QuestOptionRemove", function(ply, data)
	local dialogue_key = data[1]
	local dialogue_table = data[2]
	local ent = data[3]

	if ent then
		local curdata = ent:GetNetVar("quests", {})
		table.RemoveByValue(curdata, dialogue_key)
		ent:SetNetVar("quests", curdata)
	else
		print("You tried to delete a quest on a non-existent NPC!")
	end
end)

netstream.Hook("QuestOptionAdd", function(ply, data)
	local dialogue_key = data[1]
	local dialogue_table = data[2]
	local ent = data[3]

	if ent then
		local curdata = ent:GetNetVar("quests", {})
		table.insert(curdata, dialogue_key)
		ent:SetNetVar("quests", curdata)
	else
		print("You tried to add a quest on a non-existent NPC!")
	end
end)

netstream.Hook("QuestCompleted", function(ply, data)
	local ent = data[1]
	local quest = data[2]
	local char = ply:GetCharacter()
	local inv = char:GetInventory()

	for k, v in pairs(GLOBAL_Quests) do
		if k == quest then
			for k2, v2 in pairs(v.reward) do
				if k2 == "tokens" then
					ply:GetCharacter():GiveMoney(v2)
					ply:Notify("You have received " .. v2 .. " tokens for completing the quest : "..v.name..".")
					--inv:Add(k2)
				else
					for i = 1, v2 do
						if (not inv:Add(k2)) then
							ix.item.Spawn(k2, ply)
							ply:Notify("You were unable to include some of the reward items in your inventory.")
						end
					end
				end
			end

			for k3, v3 in pairs(v.requirements) do
				for i = 1, v3 do
					local item = inv:HasItem(k3)

					if item then
						item:Remove()
					end
				end
			end

			ply:Notify("You have completed the quest : " .. v.name)
		end
	end

	ply:RemoveQuest(quest)
end)

netstream.Hook("QuestCancel", function(ply, data)
	local quest = data

	for k, v in pairs(GLOBAL_Quests) do
		if k == quest then

			ply:Notify("You have abandoned the quest : " .. v.name)
		end
	end

	ply:CancelQuest(quest)
end)

netstream.Hook("ChangeNPCValues", function(ply, data)
	local npc = data[1]
	local name = data[2]
	local desc = data[3]
	local mdl = data[4]
	local anim = data[5]
	npc:SetNetVar("Name", name)
	npc:SetNetVar("Description", desc)
	npc:SetModel(mdl)
	npc:SetNetVar("anim", anim)
	npc:SetupAnimation(anim)
end)

function PLUGIN:SaveData()
	local data = {}
	for k, v in pairs(ents.FindByClass("ix_questgiver")) do
		data[#data + 1] = {
			pos = v:GetPos(),
			ang = v:GetAngles(),
			quests = v:GetNetVar("quests", {}),
			dialogue = v:GetNetVar("dialogue", {}),
			name = v:GetNetVar("Name", "dsfsdf"),
			desc = v:GetNetVar("Description", "dfssdf"),
			model = v:GetModel()
		}
	end
	self:SetData(data)
end

function PLUGIN:LoadData()
	local data = self:GetData()
	for k, v in pairs(data) do
		local ent = ents.Create("ix_questgiver")
		ent:SetPos(v.pos)
		ent:SetAngles(v.ang)
		ent:Spawn()
		if IsValid(ent) then
			ent:SetNetVar("quests", v.quests)
			ent:SetNetVar("dialogue", v.dialogue)
			ent:SetNetVar("Name", v.name)
			ent:SetNetVar("Description", v.desc)
			timer.Simple(1, function()
			ent:SetModel(v.model)
			ent:SetupAnimation(4)
		end)
		end
	end
end

