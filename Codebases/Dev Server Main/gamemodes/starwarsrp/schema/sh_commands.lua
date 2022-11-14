do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local radios = character:GetInventory():GetItemsByUniqueID("comlink", true)
		local item

		for k, v in ipairs(radios) do
			if (v:GetData("enabled", false)) then
				item = v
				break
			end
		end

		if (item) then
			if (!client:IsRestricted()) then
				ix.chat.Send(client, "comlink", message)
				ix.chat.Send(client, "comlink_eavesdrop", message)
			else
				return "@notNow"
			end
		elseif (#radios > 0) then
			return "@radioNotOn"
		else
			return "@radioRequired"
		end
	end

	ix.command.Add("comm", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local radios = character:GetInventory():GetItemsByUniqueID("comlink", true)
		local item

		for k, v in ipairs(radios) do
			if (v:GetData("enabled", false)) then
				item = v
				break
			end
		end

		if (item) then
			if (!client:IsRestricted()) then
				ix.chat.Send(client, "comlink", message)
				ix.chat.Send(client, "comlink_eavesdrop", message)
			else
				return "@notNow"
			end
		elseif (#radios > 0) then
			return "@radioNotOn"
		else
			return "@radioRequired"
		end
	end

	ix.command.Add("c", COMMAND)
end

do
	local COMMAND = {}

	function COMMAND:OnRun(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and target:IsRestricted()) then
			if (!client:IsRestricted()) then
				Schema:SearchPlayer(client, target)
			else
				return "@notNow"
			end
		end
	end

	ix.command.Add("CharSearch", COMMAND)
end

do
	local COMMAND = {}

	function COMMAND:OnRun(client, arguments)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsDoor()) then
			target:Fire("Lock")
		end
	end

	ix.command.Add("DoorLock", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, arguments)
		
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer()) then
			Schema:SearchPlayer(client, target)
		else
			return "@notNow"
		end
	end

	ix.command.Add("PlySearch", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.number

	function COMMAND:OnRun(client, frequency)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		local itemTable = inventory:HasItem("comlink")

		if (itemTable) then
			if (string.find(frequency, "^%d%d%d%.%d$")) then
				character:SetData("frequency", frequency)
				itemTable:SetData("frequency", frequency)

				client:Notify(string.format("You have set your comlink frequency to %s.", frequency))
			end
		end
	end

	ix.command.Add("SetFreq", COMMAND)
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

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.character

	function COMMAND:OnRun(client, target)
					
		local targetClient = target:GetPlayer()

		/*
		if (!hook.Run("CanPlayerViewData", client, targetClient)) then
			return "@cantViewData"
		end
		*/

		local data = {
			["securityAuth"] = false,
			["securityData"] = "",
			["isbAuth"] = false,
			["isbData"] = "",
			["staffAuth"] = false,
			["staffData"] = ""
		}
		
		data.securityAuth = client:GetCharacter():GetClass() == CLASS_NAVYTROOPER or client:GetCharacter():GetFaction() == FACTION_ISB
		data.isbAuth = client:GetCharacter():GetFaction() == FACTION_ISB

		if (!data.securityAuth and !data.isbAuth) then
			return "You do not have access to viewing data!"
		end

		if (data.securityAuth) then
			data.securityData = target:GetData("securityData", "")
		end

		if (data.isbAuth) then
			data.isbData = target:GetData("isbData", "")
		end

		netstream.Start(client, "OpenViewData", targetClient, data)

	end

	ix.command.Add("ViewData", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, message)
		if SERVER then
			if (client:IsAdmin()) then
				local ent = client:GetEyeTrace().Entity
				if IsValid(ent) then
					client:ChatPrint("Map Creation ID: "..tostring(ent:MapCreationID()))
				else
					return "That's not a valid entity!"
				end
			else
				return "This is a developer command!"
			end
		end
	end

	ix.command.Add("GetMapCreationID", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client)
		if (client:SteamID64() == "76561198066461105") then
			for k, v in ipairs(player.GetAll()) do
				v:SetNetVar("ShowBlackScreen", true)
			end
		else
			return "@notNow"
		end
	end

	ix.command.Add("DrawBlackScreen", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, message)
		if (client:SteamID64() == "76561198066461105") then
			for k, v in ipairs(player.GetAll()) do
				v:SetNetVar("ShowBlackScreen", true)
				v:SetNetVar("ScreenText", message)
			end
		else
			return "@notNow"
		end
	end

	ix.command.Add("SetScreenText", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, message)
		if (client:SteamID64() == "76561198066461105") then
			for k, v in ipairs(player.GetAll()) do
				v:SetNetVar("TopText", message)
			end
		else
			return "@notNow"
		end
	end

	ix.command.Add("SetTopText", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client)
		if (client:SteamID64() == "76561198066461105") then
			for k, v in ipairs(player.GetAll()) do
				v:SetNetVar("DrawLoading", true)
			end
		else
			return "@notNow"
		end
	end

	ix.command.Add("DrawLoading", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, message)
		if (client:SteamID64() == "76561198066461105") then
			for k, v in ipairs(player.GetAll()) do
				v:SetNetVar("ScreenText", nil)
				v:SetNetVar("ShowBlackScreen", nil)
				v:SetNetVar("TopText", nil)
				v:SetNetVar("DrawLoading", nil)
			end
		else
			return "@notNow"
		end
	end

	ix.command.Add("ClearScreenDraws", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.adminOnly = true

	function COMMAND:OnRun(client, message)
		if (client:SteamID64() == "76561198066461105") then
			for k, v in ipairs(player.GetAll()) do
				v:Notify(message)
			end
		else
			return "@notNow"
		end
	end

	ix.command.Add("NotifyAll", COMMAND)
end