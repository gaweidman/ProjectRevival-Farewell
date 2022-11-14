-- Vortessence Definitions
VORTESSENCE_REGEN_RATE = 3 -- This is a per second rate.
MAXVORTESSENCE = 200
VORTILAMPCONSUMPRATE = 0 -- This is a per second rate.
VORTALEYECONSUMPRATE = VORTESSENCE_REGEN_RATE + 8 -- This is a per second rate.
VORTHEALCONSUMPRATE = VORTESSENCE_REGEN_RATE + 5 -- This is a per second rate.
VORTHEALRATE = 5 -- this is a per second rate
Schema.NumRations = Schema.NumRations or 0
Schema.NumWorkCycles = Schema.NumWorkCycles or 0


Schema.CombineObjectives = Schema.CombineObjectives or {}

function Schema:AddCombineDisplayMessage(text, color, exclude, ...)
	color = color or color_white

	local arguments = {...}
	local receivers = {}

	-- we assume that exclude will be part of the argument list if we're using
	-- a phrase and exclude is a non-player argument
	if (type(exclude) != "Player") then
		table.insert(arguments, 1, exclude)
	end

	for _, v in ipairs(player.GetAll()) do
		if (v:HasBiosignal() and v != exclude) then
			receivers[#receivers + 1] = v
		end
	end

	netstream.Start(receivers, "CombineDisplayMessage", text, color, arguments)
end

-- data saving
function Schema:SaveUidPrinters()
	local data = {}
	for _, v in ipairs(ents.FindByClass("ix_uidprinter")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetEnabled()}
	end

	ix.data.Set("uidPrinters", data)
end

function Schema:SaveRationDispensers()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_rationdispenser")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetEnabled()}
	end

	ix.data.Set("rationDispensers", data)
end

function Schema:SaveVendingMachines()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_vendingmachine")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetAllStock()}
	end

	ix.data.Set("vendingMachines", data)
end

function Schema:SaveCombineLocks()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_combinelock")) do
		if (IsValid(v.door)) then
			data[#data + 1] = {
				v.door:MapCreationID(),
				v.door:WorldToLocal(v:GetPos()),
				v.door:WorldToLocalAngles(v:GetAngles()),
				v:GetLocked()
			}
		end
	end

	ix.data.Set("combineLocks", data)
end

function Schema:SavePadlocks()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_padlock")) do
		if (IsValid(v.door)) then
			data[#data + 1] = {
				v.door:MapCreationID(),
				v.door:WorldToLocal(v:GetPos()),
				v.door:WorldToLocalAngles(v:GetAngles()),
				v:GetLocked(),
				v.password
			}
		end
	end

	ix.data.Set("padlocks", data)
end

function Schema:SaveForceFields()
	local data = {}

	for _, v in ipairs(ents.FindByClass("ix_forcefield")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetMode()}
	end

	ix.data.Set("forceFields", data)
end

-- data loading

function Schema:LoadUidPrinters()
	for _, v in ipairs(ix.data.Get("uidDispensers") or {}) do
		local dispenser = ents.Create("ix_uidprinter")

		dispenser:SetPos(v[1])
		dispenser:SetAngles(v[2])
		dispenser:Spawn()
		dispenser:SetEnabled(v[3])
	end
end

function Schema:LoadRationDispensers()
	for _, v in ipairs(ix.data.Get("rationDispensers") or {}) do
		local dispenser = ents.Create("ix_rationdispenser")

		dispenser:SetPos(v[1])
		dispenser:SetAngles(v[2])
		dispenser:Spawn()
		dispenser:SetEnabled(v[3])
	end
end

function Schema:LoadVendingMachines()
	for _, v in ipairs(ix.data.Get("vendingMachines") or {}) do
		local vendor = ents.Create("ix_vendingmachine")

		vendor:SetPos(v[1])
		vendor:SetAngles(v[2])
		vendor:Spawn()
		vendor:SetStock(v[3])
	end
end

function Schema:LoadCombineLocks()
	for _, v in ipairs(ix.data.Get("combineLocks") or {}) do
		local door = ents.GetMapCreatedEntity(v[1])

		if (IsValid(door) and door:IsDoor()) then
			local lock = ents.Create("ix_combinelock")

			lock:SetPos(door:GetPos())
			lock:Spawn()
			lock:SetDoor(door, door:LocalToWorld(v[2]), door:LocalToWorldAngles(v[3]))
			lock:SetLocked(v[4])
		end
	end
end

function Schema:LoadPadlocks()
	for _, v in ipairs(ix.data.Get("padlocks") or {}) do
		local door = ents.GetMapCreatedEntity(v[1])

		if (IsValid(door) and door:IsDoor()) then
			local lock = ents.Create("ix_padlock")

			lock:SetPos(door:GetPos())
			lock:Spawn()
			lock:SetDoor(door, door:LocalToWorld(v[2]), door:LocalToWorldAngles(v[3]))
			lock:SetLocked(v[4])
			lock.password = v[5]
		end
	end
end


function ix.char.GetByCID(cid)
	for _, char in pairs(ix.char.loaded) do
		print(cid)
		print(type(char:GetData("cid")))
		if char:GetData("cid") == cid then
			return char
		end
	end

	return nil
end


function ix.char.GetByIIN(iin)
	for _, char in pairs(ix.char.loaded) do
		if char:GetFaction() == FACTION_CITIZEN then
			if char:GetData("cid") == iin then
				print("FOUND")
				return char
			end
		elseif char:GetFaction() == FACTION_CONSCRIPT then
			if char:GetData("iin") == iin then
				return char
			end
		else
			local charName = char:GetName()
			print(string.sub(charName, #charName - 4, #charName))
			if string.sub(charName, #charName - 4, #charName) == iin then
				print("FOUND IT")
				return char
			end
		end
	end

	return nil
end

apartmentSetup = {
	["Collation"] = {
		["1A"] = {doorID = 2838, maxTenants = 4},
		["1B"] = {doorID = 2823, maxTenants = 2},
		["1C"] = {doorID = 2825, maxTenants = 2},
		["1D"] = {doorID = 2826, maxTenants = 4},

		["2A"] = {doorID = 2819, maxTenants = 4},
		["2B"] = {doorID = 2804, maxTenants = 2},
		["2C"] = {doorID = 2806, maxTenants = 2},
		["2D"] = {doorID = 2807, maxTenants = 4},

		["3A"] = {doorID = 2800, maxTenants = 4},
		["3B"] = {doorID = 2785, maxTenants = 2},
		["3C"] = {doorID = 2787, maxTenants = 2},
		["3D"] = {doorID = 2788	, maxTenants = 4},

		["4A"] = {doorID = 2781, maxTenants = 4},
		["4B"] = {doorID = 2779, maxTenants = 2},
		["4C"] = {doorID = 2780, maxTenants = 2},
		["4D"] = {doorID = 2782, maxTenants = 4}
	}
}

ix.apartments.LoadBaseData(apartmentSetup)

ix.log.AddType("fliptoken", function(client, value)
	return string.format("%s flipped a coin and it landed on %s.", client:Name(), value)
end)



ix.log.AddType("rollattribute", function(client, value, attr, attrVal, critVal)
	if critVal == -1 then
		return string.format("%s rolled %d (%s + %s) out of 100 on %s, a critical failure.", client:Name(), tonumber(value) + tonumber(attrVal), value, attrVal, attr)
	elseif critVal == 1 then
		return string.format("%s rolled %d (%s + %s) out of 100 on %s, a critical failure.", client:Name(), tonumber(value) + tonumber(attrVal), value, attrVal, attr)
	else
		return string.format("%s rolled %d (%s + %s) out of 100 on %s.", client:Name(), tonumber(value) + tonumber(attrVal), value, attrVal, attr)
	end
end)

ix.log.AddType("rollskill", function(client, value, skll, skllVal, critVal)
	if critVal == -1 then
		return string.format("%s rolled %d (%s + %s) out of 100 on %s, a critical failure.", client:Name(), tonumber(value) + tonumber(skllVal), value, skllVal, skll)
	elseif critVal == 1 then
		return string.format("%s rolled %d (%s + %s) out of 100 on %s, a critical failure.", client:Name(), tonumber(value) + tonumber(skllVal), value, skllVal, skll)
	else
		return string.format("%s rolled %d (%s + %s) out of 100 on %s.", client:Name(), tonumber(value) + tonumber(skllVal), value, skllVal, skll)
	end
end)

ix.log.AddType("searchplayer", function(client, target)
	return string.format("%s (%s) searched %s (%s).", client:Name(), client:GetCharacter():GetID(), target:GetName(), target:GetCharacter():GetID())
end)

function Schema:LoadForceFields()
	for _, v in ipairs(ix.data.Get("forceFields") or {}) do
		local field = ents.Create("ix_forcefield")

		field:SetPos(v[1])
		field:SetAngles(v[2])
		field:Spawn()
		field:SetMode(v[3])
	end
end

function Schema:CreateScanner(client, class)
	class = class or "npc_cscanner"

	local entity = ents.Create(class)

	if (!IsValid(entity)) then
		return
	end

	entity:SetPos(client:GetPos())
	entity:SetAngles(client:GetAngles())
	entity:SetColor(client:GetColor())
	entity:Spawn()
	entity:Activate()
	entity.ixPlayer = client
	entity:SetNetVar("player", client) -- Draw the player info when looking at the scanner.
	entity:CallOnRemove("ScannerRemove", function()
		if (IsValid(client)) then
			local position = entity.position or client:GetPos()

			client:UnSpectate()
			client:SetViewEntity(NULL)

			if (entity:Health() > 0) then
				client:Spawn()
			else
				client:KillSilent()
			end

			timer.Simple(0, function()
				client:SetPos(position)
			end)
		end
	end)

	local uniqueID = "ix_Scanner" .. client:UniqueID()
	entity.name = uniqueID
	entity.ixCharacterID = client:GetCharacter():GetID()

	local target = ents.Create("path_track")
	target:SetPos(entity:GetPos())
	target:Spawn()
	target:SetName(uniqueID)
	entity:CallOnRemove("RemoveTarget", function()
		if (IsValid(target)) then
			target:Remove()
		end
	end)

	entity:SetHealth(client:Health())
	entity:SetMaxHealth(client:GetMaxHealth())
	entity:Fire("setfollowtarget", uniqueID)
	entity:Fire("inputshouldinspect", false)
	entity:Fire("setdistanceoverride", "48")
	entity:SetKeyValue("spawnflags", 8208)

	client.ixScanner = entity
	client:Spectate(OBS_MODE_CHASE)
	client:SpectateEntity(entity)
	entity:CallOnRemove("RemoveThink", function()
		timer.Remove(uniqueID)
	end)

	timer.Create(uniqueID, 0.33, 0, function()
		if (!IsValid(client) or !IsValid(entity) or client:GetCharacter():GetID() != entity.ixCharacterID) then
			if (IsValid(entity)) then
				entity:Remove()
			end

			timer.Remove(uniqueID)
			return
		end

		local factor = 128

		if (client:KeyDown(IN_SPEED)) then
			factor = 64
		end

		if (client:KeyDown(IN_FORWARD)) then
			target:SetPos((entity:GetPos() + client:GetAimVector() * factor) - Vector(0, 0, 64))
			entity:Fire("setfollowtarget", uniqueID)
		elseif (client:KeyDown(IN_BACK)) then
			target:SetPos((entity:GetPos() + client:GetAimVector() * -factor) - Vector(0, 0, 64))
			entity:Fire("setfollowtarget", uniqueID)
		elseif (client:KeyDown(IN_JUMP)) then
			target:SetPos(entity:GetPos() + Vector(0, 0, factor))
			entity:Fire("setfollowtarget", uniqueID)
		elseif (client:KeyDown(IN_DUCK)) then
			target:SetPos(entity:GetPos() - Vector(0, 0, factor))
			entity:Fire("setfollowtarget", uniqueID)
		end

		client:SetPos(entity:GetPos())
	end)

	return entity
end

function Schema:SearchPlayer(client, target)
	if (!target:GetCharacter() or !target:GetCharacter():GetInventory()) then
		return false
	end

	local name = hook.Run("GetDisplayedName", target) or target:Name()
	local inventory = target:GetCharacter():GetInventory()

	ix.storage.Open(client, inventory, {
		entity = target,
		name = name
	})

	ix.log.Add("searchplayer", client, client:GetCharacter():GetID(), target, target:GetCharacter():GetID())

	return true
end

function Schema:TrySearchPlayer(client, target)
	if (!target:GetCharacter() or !target:GetCharacter():GetInventory()) then
		return false
	end

	local idempKey = ix.util.GenerateIdempKey()

	target:SetVar("SearchRequestTarget", nil)
	client:SetVar("SearchRequestSearcher", nil)

	if client:GetVar("SearchRequestTarget", nil) != nil then
		client:Notify("You are being searched!")
		return
	elseif client:GetVar("SearchRequestSearcher", nil) != nil then
		client:Notify("You are already searching someone else!")
		return
	elseif target:GetVar("SearchRequestTarget", nil) != nil then
		client:Notify("That person is already being searched!")
		return
	elseif target:GetVar("SearchRequestSearcher", nil) != nil then
		client:Notify("This person is already searching someone!")
		return
	end

	target:SetVar("SearchRequestTarget", idempKey)
	client:SetVar("SearchRequestSearcher", idempKey)

	client:Notify("Waiting on player response to search.")

	net.Start("prSearchAsk")
		net.WriteEntity(client)
		net.WriteEntity(target)
	net.Send(target)
end

util.AddNetworkString("prTimeclock")
util.AddNetworkString("ixCombatAct")
util.AddNetworkString("prAptAction")
util.AddNetworkString("prAptResponse")
util.AddNetworkString("ixOpenRadioMenu")
util.AddNetworkString("ixRadioOptSubmit")
util.AddNetworkString("ixObjectPlace")
util.AddNetworkString("ixStartPlacing")
util.AddNetworkString("ixStopPlacement")
util.AddNetworkString("prSearchAsk")
util.AddNetworkString("prSearchResponse")
util.AddNetworkString("prCharacterUpdate")
util.AddNetworkString("prCharacterUpdateResponse")
util.AddNetworkString("prCivTerminal")
util.AddNetworkString("prMessengerAction")
util.AddNetworkString("prMessengerResponse")
util.AddNetworkString("ixJammerOpenMenu")
util.AddNetworkString("ixPadlockCode")
util.AddNetworkString("ixPadlockSend")
util.AddNetworkString("prMusicOverride")
util.AddNetworkString("ixViewQuotas")

resource.AddFile( "resource/fonts/VCR_OSD_MONO.ttf" ) 
resource.AddFile( "resource/fonts/runescape_uf.ttf" ) 