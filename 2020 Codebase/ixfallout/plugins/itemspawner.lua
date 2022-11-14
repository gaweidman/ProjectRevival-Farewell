local PLUGIN = PLUGIN
PLUGIN.name = "Item Spawner"
PLUGIN.description = "An item spawning system."
PLUGIN.author = "ZeMysticalTaco"
PLUGIN.spawners = PLUGIN.spawners or {}
PLUGIN.items = PLUGIN.items or {}

ix.lang.AddTable("english", {
	itemspawner = "Item Spawner",
})

ix.lang.AddTable("korean", {
	itemspawner = "아이템 스포너",
})

ix.config.Add("ItemSpawnInterval", 300, "The font used to display titles.", nil, {
	category = "itemspawner",
	data = {min = 10, max = 999999999}
})

ix.config.Add("ItemSpawnPerWave", 5, "The font used to display titles.", nil, {
	category = "itemspawner",
	data = {min = 0, max = 1000}
})

ix.config.Add("ItemSpawnMaxItems", 75, "The font used to display titles.", nil, {
	category = "itemspawner",
	data = {min = 0, max = 1000}
})

ix.config.Add("ItemMinimumPlayers", 2, "The font used to display titles.", nil, {
	category = "itemspawner",
	data = {min = 0, max = 64}
})

ix.config.Add("ItemMaxInContainer", 2, "The font used to display titles.", nil, {
	category = "itemspawner",
	data = {min = 0, max = 64}
})
	ix.command.Add("ItemSpawnAdd", {
		description = "Add an item spawner.",
		adminOnly = true,
		OnRun = function(self, client)
			local trace = client:GetEyeTraceNoCursor()
			local hitpos = trace.HitPos
			PLUGIN:AddItemSpawn(hitpos)
		end
	})

	ix.command.Add("ItemSpawnRemove", {
		description = "Add an item spawner.",
		adminOnly = true,
		OnRun = function(self, client)
			local trace = client:GetEyeTraceNoCursor()
			local hitpos = trace.HitPos
			PLUGIN:RemoveItemSpawn(client, hitpos)
		end
	})

	ix.command.Add("ItemSpawnForce", {
		description = "Add an item spawner.",
		adminOnly = true,
		arguments = ix.type.number,
		OnRun = function(self, client, amount)
			for i = 1, amount or 1 do
				PLUGIN:SpawnRandomItem()
			end
		end
	})

	ix.command.Add("ItemSpawnRemoveItems", {
		description = "Remove all items spawned by the item spawner this cycle.",
		adminOnly = true,
		OnRun = function(self, client, amount)
			--TODO: figure out why this doesn't work.
			for k, v in pairs(ents.FindByClass("ix_item")) do
				if v.spawnedbyspawner == true then
					v:Remove()
				end
			end
		end
	})

	ix.command.Add("ItemSpawnResetTimer", {
		description = "Remove all items spawned by the item spawner this cycle.",
		adminOnly = true,
		OnRun = function(self, client, amount)
			NextItemSpawn = 0
		end
	})
if SERVER then
	--[[-------------------------------------------------------------------------
	How this works:
	The number is how many "tickets" in the spawn pool it gets, it's then selected completely at random.
	1 in a pool of 100 would be a 1% chance.
	1 in a pool of 1000 would be an 0.01% chance.
	You can print the size of the pool using PrintItemPoolSize()
	Use the unique ID of an item to determine what's selected.
	so, ["itemid"] = tickets
	By default, any item with the category "Crafting" or "Survival" will get added, so this will go well if you use my crafting plugin and my survival plugin, it will automatically be setup.
---------------------------------------------------------------------------]]
	PLUGIN.customitems = {
		["metal"] = 70,
		["wonderglue"] = 55,
		["fissionbattery"] = 55,
		["sensormodule"] = 55,
		["cleaner"] = 60,
		["tincan"] = 70,
		["prewarbook"] = 55,
		["pressurecooker"] = 50,
		["turpentine"] = 55,
		["lunchbox"] = 50,
		["nukacola_bottle"] = 70,
		["sunsetsarsaparilla_bottle"] = 30,
		["cigarettepack"] = 70,
		["cigarettecarton"] = 65,
		-- ["ncrmoney"] = 40,
		["fusioncore"] = 20,
		["money"] = 60,
		["bubblegum"] = 50,
		["cottoncandy"] = 50,
		["cram"] = 50,
		["cram_irradiated"] = 50,
		["dandyboyapples"] = 50,
		["dandyboyapples_irradiated"] = 50,
		["dirtywater"] = 50,
		["dogfood"] = 50,
		["fancyladcakes"] = 50,
		["fancyladcakes_irradiated"] = 50,
		["funnelcake"] = 50,
		["instamash"] = 50,
		["instamash_irradiated"] = 50,
		["irrwater"] = 50,
		["milk_carton"] = 30,
		["macandcheese"] = 50,
		["macandcheese_irradiated"] = 50,
		["nukacola"] = 50,
		["porkbeans"] = 50,
		["porkbeans_irradiated"] = 50,
		["potatocrisps_irradiated"] = 50,
		["steak"] = 50,
		["steak_irradiated"] = 50,
		["sugarbombs"] = 50,
		["sugarbombs_irradiated"] = 50,
		["sunsetsarsaparilla"] = 20,
		["yumyumdeviledeggs"] = 50,
		["yumyumdeviledeggs_irradiated"] = 50,
		["beer"] = 50,
		["bourbon"] = 50,
		["moonshine"] = 50,
		["rum"] = 50,
		["vodka"] = 50,
		["whiskey"] = 50,
		["wine"] = 50,
		["9mmpistol"] = 40,
		["357revolver"] = 40,
		["baseballbat_metal"] = 50,
		["leadpipe"] = 50,
		["machete"] = 50,
		["pipewrench"] = 50,
		["varmintrifle"] = 40,
		["stimpak"] = 30,
		["radaway"] = 30,
		["jet"] = 30,
		["radx"] = 30,
		["medx"] = 30,
		["water"] = 30,
		["flashlight"] = 40,
		["repair_tools"] = 20,
		-- ["zip_tie"] = 20,
		["5mm"] = 20,
		["9mm"] = 30,
		["10mm"] = 30,
		["12gauge"] = 20,
		["20gauge"] = 20,
		["44magnum"] = 20,
		["357magnum"] = 30,
		["556mm"] = 30,
		["9mmsmg"] = 10,
		["10mmpistol"] = 20,
		["44revolver"] = 10,
		["caravanshotgun"] = 10,
		["cowboyrepeater"] = 10,
		["huntingrifle"] = 20,
		["huntingshotgun"] = 10,
		["laserpistol"] = 10,
		["plasmapistol"] = 10,
		["policepistol"] = 10,
		["servicerifle"] = 20,
		["radio"] = 10,
		["handheld_radio"] = 5,
		["radchecker"] = 10,
		["suitcase"] = 5,
		["50mg"] = 5,
		["308"] = 10,
		["127mm"] = 5,
		["electronchargepack"] = 5,
		["energycell"] = 20,
		["microfusioncell"] = 15,
		["metal_armor"] = 10,
		["recon_armor"] = 5,
		["super_stimpak"] = 15,
		["fraggrenade"] = 15,
		["10mmsmg"] = 7,
		["combatknife"] = 15,
		["combatshotgun"] = 7,
		["huntingrifle_scope"] = 7,
		["laserrifle"] = 15,
		["plasmarifle"] = 7,
		["r91assaultrifle"] = 10,
		["servicerifle_bayonet"] = 10,
		["rechargerrifle"] = 7,
		["trailcarbine"] = 7,
		["deathclawegg"] = 5,
		["metal_armor_reinforced"] = 5,
		["t45d_power_armor"] = 3,
		["t45d_power_armor_woodland"] = 1,
		["t51b_power_armor"] = 2,
		["127mmpistol"] = 5,
		["antimaterielrifle"] = 1,
		["assaultcarbine"] = 2,
		["battlerifle"] = 1,
		["chineseassaultrifle"] = 2,
		["gatlinglaser"] = 1,
		["laer"] = 2,
		["multiplasmarifle"] = 2,
		["tribeamlaserrifle"] = 2,
		["laserrifle_scope"] = 5,
		["marksmancarbine"] = 2,
		["minigun"] = 1,
		["plasmadefender"] = 5,
		["powerfist"] = 5,
		["rechargerpistol"] = 1,
		["stealthboy"] = 5
	}

	function PLUGIN:SaveData()
		ix.data.Set("spawners", self.spawners)
	end

	function PLUGIN:LoadData()
		self.spawners = ix.data.Get("spawners", {})
		--[[-------------------------------------------------------------------------
		ONLY populate once.
	---------------------------------------------------------------------------]]
		self:PopulateItems()
	end



	function PLUGIN:AddItemSpawn(pos)
		self.spawners[#self.spawners + 1] = pos
		ply:Notify("You have added an item spawn.")
	end

	function PLUGIN:RemoveItemSpawn(ply, pos)
		local gay = {}

		for k, v in pairs(self.spawners) do
			if v:Distance(pos) <= 512 then
				self.spawners[k] = nil
				gay[#gay + 1] = v
			end
		end

		ply:Notify("You have removed " .. #gay .. " item spawn(s).")
	end

	function PLUGIN:SpawnRandomItem()
		local spawner = table.Random(self.spawners)
		ix.item.Spawn(table.Random(self.items), spawner)
	end

	--This function is used so that we don't populate items in the same spot, or near players, though it will go unused for my purposes, use it how you wish.
	function PLUGIN:SpawnRandomItemSafe()
		local spawner = table.Random(self.spawners)

		for k, v in pairs(ents.FindInSphere(spawner, 64)) do
			if v:GetClass() == "ix_item" or v:IsPlayer() then
				return false
			end
		end

		local item = ix.item.Spawn(table.Random(self.items), spawner)

		if IsValid(item) then
			item.spawnedbyspawner = true
		end

		return true
	end

	function PLUGIN:AddItemToSpawner(id)
		PLUGIN.items[#PLUGIN.items + 1] = id
	end

	function PLUGIN:PopulateItems()
		for k, v in pairs(self.customitems) do
			for i = 1, v do
				PLUGIN:AddItemToSpawner(k)
			end
		end
	end

	function PrintItemPoolSize()
		print(#PLUGIN.items)
	end

	function PrintItemPool()
		PrintTable(PLUGIN.items)
	end

	function PrintSpawnPool()
		PrintTable(PLUGIN.spawners)
	end

	--[[-------------------------------------------------------------------------
	The bread and butter.
---------------------------------------------------------------------------]]
	function PLUGIN:Think()
		local frequency = ix.config.Get("ItemSpawnInterval", 300)
		local waves = ix.config.Get("ItemSpawnPerWave", 5)
		local max_items = ix.config.Get("ItemSpawnMaxItems", 75)
		local min_players = ix.config.Get("ItemMinimumPlayers", 2)
		if #self.spawners < 1 then return end
		if not NextItemSpawn or NextItemSpawn <= CurTime() then
			if #player.GetAll() >= min_players and #ents.FindByClass("ix_item") < max_items then
				for i = 1, waves do
					local spawned = self:SpawnRandomItemSafe()

					if spawned then
						print("Item spawner(s) spawned item(s).")
					end
				end

				NextItemSpawn = CurTime() + frequency
			end
		end
	end
end