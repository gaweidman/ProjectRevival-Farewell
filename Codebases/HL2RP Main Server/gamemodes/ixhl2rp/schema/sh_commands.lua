do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (!client:IsRestricted()) then
			ix.chat.Send(client, "dispatch", message)
			
		else
			return "@notNow"
		end
	end

	ix.command.Add("Dispatch", COMMAND)
end

do
	local COMMAND = {}

	function COMMAND:OnRun(client)
		local charName = client:GetCharacter():GetName()
		local cid = client:GetCharacter():GetData("cid")

		if !cid then
			return "You do not have a CID number!"
		else
			ix.chat.Send(client, "ic", charName..", #"..cid..".")
		end
	end

	ix.command.Add("Apply", COMMAND)
end

do
	local COMMAND = {}

	function COMMAND:OnRun(client)
		local charName = client:GetCharacter():GetName()
		local cid = client:GetCharacter():GetData("cid")

		if !cid then
			return "You do not have a CID number!"
		else
			ix.chat.Send(client, "ic", "My name is "..charName..", and my CID number is "..cid..".")
		end
	end

	ix.command.Add("ApplySay", COMMAND)
end

ix.command.Add("ToggleRaise", {
	description = "@cmdToggleRaise",
	OnRun = function(self, client, arguments)
		if (!timer.Exists("ixToggleRaise" .. client:SteamID())) then
			timer.Create("ixToggleRaise" .. client:SteamID(), client:GetCharacter():GetWepRaiseTime(), 1, function()
				client:ToggleWepRaised()
			end)
		end
	end
})


do
	local COMMAND = {}
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client)
			for k, v in ipairs(player.GetAll()) do
				v:SetNetVar("ShowBlackScreen", true)
			end
	end

	ix.command.Add("DrawBlackScreen", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, message)
		for k, v in ipairs(player.GetAll()) do
			v:SetNetVar("ShowBlackScreen", true)
			v:SetNetVar("ScreenText", message)
		end
	end

	ix.command.Add("SetScreenText", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, message)
		for k, v in ipairs(player.GetAll()) do
			v:SetNetVar("TopText", message)
		end
	end

	ix.command.Add("SetTopText", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client)
		for k, v in ipairs(player.GetAll()) do
			v:SetNetVar("ShowBlackScreen", true)
			v:SetNetVar("DrawLoading", true)
		end
	end

	ix.command.Add("DrawLoading", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, message)
		for k, v in ipairs(player.GetAll()) do
			v:SetNetVar("ScreenText", nil)
			v:SetNetVar("ShowBlackScreen", nil)
			v:SetNetVar("TopText", nil)
			v:SetNetVar("DrawLoading", nil)
			v:SetNetVar("CenterSubtitle", nil)
		end
	end

	ix.command.Add("ClearScreenDraws", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, message)
		for k, v in ipairs(player.GetAll()) do
			v:SetNetVar("ShowBlackScreen", true)
			v:SetNetVar("ScreenText", "In Loving Memory of Roxi")
			v:SetNetVar("CenterSubtitle", message)
		end
	end

	ix.command.Add("SetMemoriamText", COMMAND)
end


do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, message)
		for k, v in ipairs(player.GetAll()) do
			v:Notify(message)
		end
	end

	ix.command.Add("NotifyAll", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (client:HasBiosignal() or client:IsDispatch()) then
			for k, v in ipairs(player.GetAll()) do

				if v:HasBiosignal() then
					v:AddCombineDisplayMessage(client:GetName()..": "..message, Color(60, 60, 255), 15)
				end

				local sounds = {"buttons/combine_button2.wav"}

				for k, v in ipairs(player.GetAll()) do
					if (v:HasBiosignal()) then
						ix.util.EmitQueuedSounds(v, sounds, 0, nil, v == client and 100 or 80)
					end
				end
	
			end 
		else
			return "You're not a member of the combine!"
		end
	end

	ix.command.Add("VisorNotify", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (client:HasBiosignal() or client:IsDispatch()) then
			for k, v in ipairs(player.GetAll()) do

				local sounds = {"buttons/blip1.wav", "buttons/blip1.wav", "buttons/blip1.wav", "npc/overwatch/radiovoice/allteamsrespondcode3.wav"}

				for k, v in ipairs(player.GetAll()) do
					if (v:HasBiosignal()) then
						ix.util.EmitQueuedSounds(v, sounds, 0, 0.3, v == client and 100 or 80)
					end
				end

				if v:HasBiosignal() then
					v:AddCombineDisplayMessage(client:GetName().." is in danger!", Color(255, 40, 40), 25)
					v:AddCombineDisplayMessage("Message: "..message, Color(255, 40, 40), 25)
				end

			end
		else
			return "You're not a member of the combine!"
		end
	end

	ix.command.Add("VisorDanger", COMMAND)
end


do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local radios = character:GetInventory():GetItemsByUniqueID("hybridradio", true)
		local item

		local traceEnt = client:GetEyeTrace().Entity
		print("DEBUG",  client:GetPos():Distance(traceEnt:GetPos()))
		traceEnt = (IsValid(traceEnt) and traceEnt:GetClass() == "ix_testent5" and client:GetPos():Distance(traceEnt:GetPos()) <= 96) and traceEnt or nil
		local canStationaryRadio = traceEnt != nil and traceEnt:GetNetVar("On", false)

		if !canStationaryRadio then
			for k, v in ipairs(radios) do
				if (v:GetData("enabled", false)) then
					item = v
					break
				end
			end
		end
		
		if !canStationaryRadio then
			if item then
				if (!client:IsRestricted()) then
					ix.chat.Send(client, "radio", message)
					ix.chat.Send(client, "radio_eavesdrop", message)
				else
					return "You cannot do that while bound!"
				end
			elseif (#radios > 0) then
				return "@radioNotOn"
			else
				return "@radioRequired"
			end
		else
			if client:IsRestricted() then
				return "You cannot do that while bound!"
			end

			if traceEnt:GetNetVar("On", false)then
				ix.chat.Send(client, "radio", message)
				ix.chat.Send(client, "radio_eavesdrop", message)
			else
				return "@radioNotOn"
			end
		end
	end

	ix.command.Add("R", COMMAND)
	ix.command.Add("Radio", COMMAND)
	
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local radios = character:GetInventory():GetItemsByUniqueID("hybridradio", true)
		local item

		local traceEnt = client:GetEyeTrace().Entity
		print("DEBUG",  client:GetPos():Distance(traceEnt:GetPos()))
		traceEnt = (IsValid(traceEnt) and traceEnt:GetClass() == "ix_testent5" and client:GetPos():Distance(traceEnt:GetPos()) <= 96) and traceEnt or nil
		local canStationaryRadio = traceEnt != nil and traceEnt:GetNetVar("On", false)

		if !canStationaryRadio then
			for k, v in ipairs(radios) do
				if (v:GetData("enabled", false)) then
					item = v
					break
				end
			end
		end
		
		if !canStationaryRadio then
			if item then
				if (!client:IsRestricted()) then
					ix.chat.Send(client, "oocradio", message)
				else
					return "You cannot do that while bound!"
				end
			elseif (#radios > 0) then
				return "@radioNotOn"
			else
				return "@radioRequired"
			end
		else
			if client:IsRestricted() then
				return "You cannot do that while bound!"
			end
			
			if traceEnt:GetNetVar("On", false)then
				ix.chat.Send(client, "oocradio", message)
			else
				return "@radioNotOn"
			end
		end
	end

	ix.command.Add("oocradio", COMMAND)
	ix.command.Add("rooc", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.number

	function COMMAND:OnRun(client, frequency)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		local itemTable = inventory:HasItem("hybridradio")

		if (itemTable) then
			if (string.find(frequency, "^%d%d%d%.%d$")) then
				character:SetData("frequency", frequency)
				itemTable:SetData("frequency", frequency)

				client:Notify(string.format("You have set your radio frequency to %s.", frequency))
			end
		end
	end

	ix.command.Add("SetFreq", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()

		if (inventory:HasItem("request_device") or client:HasBiosignal() or client:Team() == FACTION_ADMIN) then
			if (!client:IsRestricted()) then
				Schema:AddCombineDisplayMessage("@cRequest")

				ix.chat.Send(client, "request", message)
				ix.chat.Send(client, "request_eavesdrop", message)
			else
				return "@notNow"
			end
		else
			return "@needRequestDevice"
		end
	end

	ix.command.Add("Request", COMMAND)
end

ix.command.Add("Event", {
	description = "@cmdEvent",
	arguments = ix.type.text,
	superAdminOnly = true,
	OnRun = function(self, client, text)
		ix.chat.Send(client, "event", text)
	end
})

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (!client:IsRestricted()) then
			ix.chat.Send(client, "broadcast", message)
		else
			return "@notNow"
		end
	end

	ix.command.Add("Broadcast", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.adminOnly = true
	COMMAND.arguments = {
		ix.type.character,
		ix.type.text
	}

	function COMMAND:OnRun(client, target, permit)
		local itemTable = ix.item.Get("permit_" .. permit:lower())

		if (itemTable) then
			target:GetInventory():Add(itemTable.uniqueID)
		end
	end

	ix.command.Add("PermitGive", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.adminOnly = true
	COMMAND.arguments = {
		ix.type.character,
		ix.type.text
	}
	COMMAND.syntax = "<string name> <string permit>"

	function COMMAND:OnRun(client, target, permit)
		local inventory = target:GetInventory()
		local itemTable = inventory:HasItem("permit_" .. permit:lower())

		if (itemTable) then
			inventory:Remove(itemTable.id)
		end
	end

	ix.command.Add("PermitTake", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.character

	function COMMAND:OnRun(client, target)
		local targetClient = target:GetPlayer()

		if (!hook.Run("CanPlayerViewData", client, targetClient)) then
			return "@cantViewData"
		end

		local emptyTbl = {}
		local dataLocal = target:GetData("civdata", {
			["loyalacts"] = emptyTbl,
			["violations"] = emptyTbl,
			["textData"] = target:GetData("combineData", {
				["text"] = "",
				["editor"] = "UNDEFINED"
			}).text,
			["checkboxes"] = {
				["wanted"] = false,
				["bol"] = false,
				["sus"] = false,
				["violencehist"] = false,
				["freqoff"] = false,
				["poss104m"] = false,
				["poss104p"] = false,
			},
			["cid"] = target:GetData("cid", "UNDEFINED"),
			["changes"] = {}
		})

		for k, v in ipairs(dataLocal.changes) do
			if v.changer or v.change then
				table.remove(dataLocal.changes, k)
			end
		end

		local defaultText = "Civil Status: Citizen\nCWU [Y/N]: N\nCWU Dept. (If Applicable): N/A\nHousing Block:\nFlat No.:\n---------------\nDOB (MM/DD/YYYY):\nSex:\nBlood Type:\nMedical Condition: Good\nMental Condition: Good\n---------------\nNotes:"

		dataLocal.textData = target:GetData("combineData", {
			["text"] = defaultText,
			["editor"] = "UNDEFINED"
		}).text

		if dataLocal.textData == "//UNDEFINED DATA TEXT, PLEASE TELL A STAFF MEMBER ABOUT THIS ISSUE" then
			dataLocal.textData = defaultText
		end

		dataLocal.cid = target:GetData("cid", "UNDEFINED")
		if (dataLocal.checkboxes == nil) then
			dataLocal.checkboxes = {}
			dataLocal.checkboxes.wanted = false
			dataLocal.checkboxes.bol = false
			dataLocal.checkboxes.sus = false
			dataLocal.checkboxes.violencehist = false
			dataLocal.checkboxes.freqoff = false
			dataLocal.checkboxes.poss104m = false
			dataLocal.checkboxes.poss104p = false
		end

		netstream.Start(client, "OpenImprovedViewData", targetClient, dataLocal)
	end

	ix.command.Add("ViewData", COMMAND)
end

do
	local COMMAND = {}

	function COMMAND:OnRun(client, arguments)
		if (!hook.Run("CanPlayerViewObjectives", client)) then
			return "@noPerm"
		end

		netstream.Start(client, "ViewObjectives", Schema.CombineObjectives)
	end

	ix.command.Add("ViewObjectives", COMMAND)
end

do
	local COMMAND = {}

	function COMMAND:OnRun(client, arguments)
		local faction = client:GetCharacter():GetFaction()

		if faction == FACTION_MPF then
			net.Start("ixViewQuotas")
				net.WriteInt(Schema.NumRations, 32)
				net.WriteInt(Schema.NumWorkCycles, 32)
			net.Send(client)
		else
			return "You are not a member of the CCA!"
		end
		
	end

	ix.command.Add("ViewQuotas", COMMAND)
end

do
	local COMMAND = {}

	function COMMAND:OnRun(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if !IsValid(target) or !target:IsPlayer() then
			return "That is not a valid target!"
		end

		if (IsValid(target) and target:IsPlayer() and target:IsRestricted()) then
			Schema:SearchPlayer(client, target)
		else
			Schema:TrySearchPlayer(client, target)
		end
	end

	ix.command.Add("CharSearch", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.adminOnly = true
	COMMAND.arguments = ix.type.character

	function COMMAND:OnRun(client, target)
		Schema:SearchPlayer(client, target:GetPlayer())
	end

	ix.command.Add("PlySearch", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, arguments)
		for k, v in pairs(ents.FindByClass("prop_*")) do
			if (!util.IsValidModel(v:GetModel())) then
				v:Remove()
			end
		end
		return "Models deleted."
	end

	ix.command.Add("DeleteErrorModels", COMMAND)
end

ix.command.Add("PlyClassWhitelist", {
	description = "@cmdPlyWhitelist",
	privilege = "Manage Character Whitelist",
	superAdminOnly = true,
	arguments = {
		ix.type.player,
		ix.type.text
	},
	OnRun = function(self, client, target, name)
		if (name == "") then
			return "@invalidArg", 2
		end

		local class = ix.class.list[name]

		if (!class) then
			for _, v in pairs(ix.class.list) do
				print(v.name)
				if (ix.util.StringMatches(L(v.name, client), name) or ix.util.StringMatches(v.uniqueID, name)) then
					class = v

					break
				end
			end
		end

		if (class) then
			if (target:SetClassWhitelisted(class.index, true)) then
				for _, v in ipairs(player.GetAll()) do
					if (self:OnCheckAccess(v) or v == target) then
						v:Notify(string.format("%s has whitelisted %s for the %s class.", client:GetName(), target:GetName(), L(class.name, v)))
					end
				end
			end
		else
			return "@invalidClass"
		end
	end
})

ix.command.Add("RollAttribute", {
	description = "@cmdRoll",
	arguments = ix.type.string,
	OnRun = function(self, client, attribute)

		local value = math.random(1, 100)
		local isVolatile = client:GetCharacter():HasPerk("volatile")

		local attributeTable
		local attributeIndex

		for k, v in pairs(ix.attributes.list) do
			if string.lower(v.name) == string.lower(attribute) then
				attributeTable = v
				attributeIndex = k
			elseif k == string.lower(attribute) then
				attributeTable = v
				attributeIndex = k
			elseif v.aliases and table.HasValue(v.aliases, string.lower(attribute)) then
				attributeTable = v
				attributeIndex = k
			end
		end

		if attributeTable == nil then
			return "That is not a valid attribute!"
		end

		local critVal = 0

		if (!isVolatile and value == 1) or (isVolatile and value <= 5) then
			critVal = -1
		elseif (!isVolatile and value == 100) or (isVolatile and value >= 95) then
			critVal = 1
		end

		local attrVal = client:GetCharacter():GetAttribute(attributeIndex, 5)


		ix.chat.Send(client, "rollattribute", tostring(value), nil, nil, {
			attrName = attributeTable.name,
			attrVal = attrVal,
			critVal = critVal
		})

		ix.log.Add(client, "rollattribute", value, attributeTable.name, attrVal, critVal)
	end
})

ix.command.Add("RollSkill", {
	description = "@cmdRoll",
	arguments = ix.type.string,
	OnRun = function(self, client, skill)

		local value = math.random(1, 100)
		local isVolatile = client:GetCharacter():HasPerk("volatile")

		local skillTable
		local skillIndex

		for k, v in pairs(ix.skills.list) do
			if string.lower(v.name) == string.lower(skill) then
				skillTable = v
				skillIndex = k
			elseif k == string.lower(skill) then
				skillTable = v
				skillIndex = k
			elseif v.aliases and table.HasValue(v.aliases, string.lower(skill)) then
				skillTable = v
				skillIndex = k
			end
		end

		if skillTable == nil then
			return "That is not a valid skill!"
		end

		local critVal = 0

		if (!isVolatile and value == 1) or (isVolatile and value <= 5) then
			critVal = -1
		elseif (!isVolatile and value == 100) or (isVolatile and value >= 95) then
			critVal = 1
		end

		local sklVal = math.floor(client:GetCharacter():GetSkill(skillIndex)/4)


		ix.chat.Send(client, "rollskill", tostring(value), nil, nil, {
			sklName = skillTable.name,
			sklVal = sklVal,
			critVal = critVal
		})

		ix.log.Add(client, "rollskill", value, skillTable.name, sklVal, critVal)
	end
})

ix.command.Add("FlipToken", {
	description = "@cmdRoll",
	OnRun = function(self, client)
		local value = math.random(0, 1) == 0 and "Tails" or "Heads"

		ix.chat.Send(client, "fliptoken", value)

		ix.log.Add(client, "fliptoken", value)
	end
})

do
	local COMMAND = {}
	COMMAND.adminOnly = true
	COMMAND.arguments = {
		ix.type.text
	}

	function COMMAND:OnRun(client, text)
		local entity = client:GetEyeTrace().Entity
		if IsValid(entity) then
			entity.buildingName = text
		else
			client:Notify("That is not a valid entity!")
		end
	end

	ix.command.Add("SetBuildingName", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.adminOnly = true
	COMMAND.arguments = {
		ix.type.text
	}

	function COMMAND:OnRun(client, text)
		local viewEnt = client:GetEyeTrace().Entity
		print(viewEnt:GetClass())
		if viewEnt:GetClass() != "gmod_cameraprop" then return "That is not a valid entity!" end
		for k, v in ipairs(player.GetAll()) do
			v:SetViewEntity(client:GetEyeTrace().Entity)
		end
	end

	ix.command.Add("SetViewEntity", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.adminOnly = true
	COMMAND.arguments = {
		ix.type.text
	}

	function COMMAND:OnRun(client, text)
		for k, v in ipairs(player.GetAll()) do
			local angles = v:EyeAngles()
			v:SetEyeAngles(Angle(angles.x, angles.y, 0))
			v:SetViewEntity(v)
		end

	end

	ix.command.Add("ResetViewEntity", COMMAND)
end
