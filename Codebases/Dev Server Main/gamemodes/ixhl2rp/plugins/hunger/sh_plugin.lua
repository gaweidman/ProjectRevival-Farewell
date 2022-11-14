--[[
This work is licensed under a Creative Commons
Attribution-ShareAlike 4.0 International License.
Created by LiGyH.
--]]

PLUGIN.name = "Hunger+++ (merged with Survival System)"
PLUGIN.author = "LiGyH, ZeMysticalTaco, Frosty"
PLUGIN.description = "A survival system consisting of hunger and thirst."

ix.lang.AddTable("english", {
	starving = "Starving",
	hungry = "Hungry",
	grumbling = "Grumbling",
	dehydrated = "Dehydrated",
	lightlyDehydrated = "Lightly Dehydrated",
	thirsty = "Thirsty",
	parched = "Parched",
	charSetHunger01 = "You've set your hunger amount as %s.",
	charSetHunger02 = "You've set %s's hunger amount as %s.",
	charSetHunger02 = "%s have set your hunger amount as %s.",
	charSetThirst01 = "You've set your thirst amount as %s.",
	charSetThirst02 = "You've set %s's thirst amount as %s.",
	charSetThirst02 = "%s have set your thirst amount as %s.",
})

ix.lang.AddTable("korean", {
	starving = "굶주림",
	hungry = "배고픔",
	grumbling = "출출함",
	dehydrated = "탈수",
	lightlyDehydrated = "가벼운 탈수",
	thirsty = "목마름",
	parched = "약간 목마름",
	charSetHunger01 = "당신의 배고픔 수치를 %s으로 설정했습니다.",
	charSetHunger02 = "당신은 %s님의 배고픔 수치를 %s으로 설정했습니다.",
	charSetHunger02 = "%s님이 당신의 배고픔 수치를 %s으로 설정했습니다.",
	charSetThirst01 = "당신의 목마름 수치를 %s으로 설정했습니다.",
	charSetThirst02 = "당신은 %s님의 목마름 수치를 %s으로 설정했습니다.",
	charSetThirst02 = "%s님이 당신의 목마름 수치를 %s으로 설정했습니다.",
})

ix.config.Add("Hunger Decay Speed", 300, "The rate at which hunger decays.", nil, {
	data = {min = 0, max = 1200, decimals = 0},
	category = "Hunger+++"
})

ix.config.Add("Thirst Decay Speed", 300, "The rate at which thirst decays.", nil, {
	data = {min = 0, max = 1200, decimals = 0},
	category = "Hunger+++"
})

if SERVER then
	function PLUGIN:OnCharacterCreated(client, character)
		character:SetData("hunger", 100)
		character:SetData("thirst", 100)
	end

	function PLUGIN:PlayerLoadedCharacter(client, character)
		timer.Simple(0.25, function()
			client:SetLocalVar("hunger", character:GetData("hunger", 100))
			client:SetLocalVar("thirst", character:GetData("thirst", 100))
		end)
	end

	function PLUGIN:CharacterPreSave(character)
		local client = character:GetPlayer()

		if (IsValid(client)) then
			character:SetData("hunger", client:GetLocalVar("hunger", 0))
			character:SetData("thirst", client:GetLocalVar("thirst", 0))
		end
	end
	
	function PLUGIN:PlayerDeath(client)
		client.resetHunger = true
		client.resetThirst = true
	end

	function PLUGIN:PlayerSpawn(client)
		local char = client:GetCharacter()
		
		if (client.resetHunger) then
			char:SetData("hunger", 100)
			client:SetLocalVar("hunger", 100)
			client.resetHunger = false
		end
		
		if (client.resetThirst) then
			char:SetData("thirst", 100)
			client:SetLocalVar("thirst", 100)
			client.resetThirst = false
		end
	end

	local playerMeta = FindMetaTable("Player")

	function playerMeta:SetHunger(amount)
		local char = self:GetCharacter()

		if (char) then
			char:SetData("hunger", amount)
			self:SetLocalVar("hunger", amount)
		end
	end

	function playerMeta:SetThirst(amount)
		local char = self:GetCharacter()

		if (char) then
			char:SetData("thirst", amount)
			self:SetLocalVar("thirst", amount)
		end
	end

	function playerMeta:TickThirst(amount)
		local char = self:GetCharacter()

		if (char) then

			if self:Team() == FACTION_OTA or self:Team() == FACTION_CAC or self:Team() == FACTION_OSA then
				char:SetData("thirst", char:GetData("thirst", 100))
				self:SetLocalVar("thirst", char:GetData("thirst", 100))

				if char:GetData("thirst", 100) < 0 then
					char:SetData("thirst", 0)
					self:SetLocalVar("thirst", 0)
				end
			else
				char:SetData("thirst", char:GetData("thirst", 100) - amount)
				self:SetLocalVar("thirst", char:GetData("thirst", 100) - amount)

				if char:GetData("thirst", 100) < 0 then
					char:SetData("thirst", 0)
					self:SetLocalVar("thirst", 0)
				end
			end

		end
	end

	function playerMeta:TickHunger(amount)
		local char = self:GetCharacter()

		if (char) then

			if self:Team() == FACTION_OTA or self:Team() == FACTION_CAC or self:Team() == FACTION_OSA or self:Team() == FACTION_XENIAN then
				char:SetData("hunger", char:GetData("hunger", 100))
				self:SetLocalVar("hunger", char:GetData("hunger", 100))

				if char:GetData("hunger", 100) < 0 then
					char:SetData("hunger", 0)
					self:SetLocalVar("hunger", 0)
				end
			else
				char:SetData("hunger", char:GetData("hunger", 100) - amount)
				self:SetLocalVar("hunger", char:GetData("hunger", 100) - amount)

				if char:GetData("hunger", 100) < 0 then
					char:SetData("hunger", 0)
					self:SetLocalVar("hunger", 0)
				end
			end

		end
	end

	function PLUGIN:PlayerTick(ply)
		if ply:GetNetVar("hungertick", 0)  <= CurTime() then
			ply:SetNetVar("hungertick", ix.config.Get("Hunger Decay Speed", 300) + CurTime())
			ply:TickHunger(1, 1)
		end

		if ply:GetNetVar("thirsttick", 0) <= CurTime() then
			ply:SetNetVar("thirsttick", ix.config.Get("Thirst Decay Speed", 300) + CurTime())
			ply:TickThirst(2, 1)
		end
	end
	
	local damageTime = CurTime()
	
	function PLUGIN:Think()
		if (damageTime < CurTime()) then
			for k, v in ipairs(player.GetAll()) do
				if (v:GetCharacter()) then
					if (v:GetCharacter():GetData("hunger", 0) < 20) then
						v:TakeDamage(1,v,v:GetActiveWeapon())
					end
				
					if (v:GetCharacter():GetData("thirst", 0) < 20) then
						v:TakeDamage(1.5,v,v:GetActiveWeapon())
					end
				end
			end
			
			damageTime = CurTime() + 15
		end
	end
else
	function PLUGIN:RenderScreenspaceEffects()
		if (LocalPlayer():GetCharacter()) then
			if (LocalPlayer():GetHunger() < 20) then
				DrawMotionBlur(0.1, 0.3, 0.01)
			end
			
			if (LocalPlayer():GetThirst() < 20) then
				DrawMotionBlur(0.1, 0.3, 0.01)
			end
		end
    end
	
	ix.bar.Add(function()
		local status = ""
		local var = LocalPlayer():GetLocalVar("hunger", 0) / 100

		if var < 0.2 then
			status = L"starving"
		elseif var < 0.4 then
			status = L"hungry"
		elseif var < 0.6 then
			status = L"Peckish"
		elseif var < 0.8 then
			status = ""
		end

		return var, status
	end, Color(40, 100, 40), nil, "hunger")

	ix.bar.Add(function()
		local status = ""
		local var = LocalPlayer():GetLocalVar("thirst", 0) / 100

		if var < 0.2 then
			status = L"dehydrated"
		elseif var < 0.4 then
			status = L"lightlyDehydrated"
		elseif var < 0.6 then
			status = L"thirsty"
		elseif var < 0.8 then
			status = L"parched"
		end

		return var, status
	end, Color(29, 174, 181), nil, "thirst")
end

local playerMeta = FindMetaTable("Player")

function playerMeta:GetHunger()
	local char = self:GetCharacter()

	if (char) then
		return char:GetData("hunger", 100)
	end
end

function playerMeta:GetThirst()
	local char = self:GetCharacter()

	if (char) then
		return char:GetData("thirst", 100)
	end
end

function PLUGIN:AdjustStaminaOffset(client, offset)
	if client:GetHunger() < 15 or client:GetThirst() < 20 then
		return -1
	end
end

ix.command.Add("CharSetHunger", {
	adminOnly = true,
	arguments = {
		ix.type.player,
		ix.type.number
	},
	OnRun = function(self, client, target, hunger)
		target:SetHunger(hunger)

		if client == target then
			client:NotifyLocalized("charSetHunger01", hunger)
		else
			client:NotifyLocalized("charSetHunger02", target:GetName(), hunger)
			target:NotifyLocalized("charSetHunger03", client:GetName(), hunger)
		end
	end
})

ix.command.Add("CharSetThirst", {
	adminOnly = true,
	arguments = {
		ix.type.player,
		ix.type.number
	},
	OnRun = function(self, client, target, thirst)
		target:SetThirst(thirst)

		if client == target then
			client:NotifyLocalized("charSetThirst01", thirst)
		else
			client:NotifyLocalized("charSetThirst02", target:GetName(), thirst)
			target:NotifyLocalized("charSetThirst03", client:GetName(), thirst)
		end
	end
})

-- Food Base
do
	local itemTbl = {}

	itemTbl.name = "Food base"
	itemTbl.description = "A food."
	itemTbl.model = "models/props_lab/bindergraylabel01b.mdl"
	itemTbl.width = 1
	itemTbl.height = 1
	itemTbl.category = "Food"
	itemTbl.hunger = 0
	itemTbl.thirst = 0
	itemTbl.empty = false
	itemTbl.functions = {}
	itemTbl.functions.Consume = {
		OnRun = function(item)
			local client = item.player
			local character = client:GetCharacter()
			local hunger = character:GetData("hunger", 100)
			local thirst = character:GetData("thirst", 100)
			local health = client:Health()
			
			if hunger then
				if item.hunger then
					client:SetHunger(math.Clamp(hunger + item.hunger, 0, 100))
				end
			end

			if thirst then
				if item.thirst then
					client:SetThirst(math.Clamp(thirst + item.thirst, 0, 100))
				end
			end

			if health then -- This will always be true. It's just here for uniformity.
				if item.health then
					client:SetHealth(math.Clamp(health + item.health, 0, 100))
				end
			end
			
			if item.empty then
				local inv = character:GetInventory()

				if (not inv:Add(item.empty)) then
					ix.item.Spawn(item.empty, client)
				end
			end
		end,
		icon = "icon16/cup.png"
	}

	local ITEM = ix.item.Register("food", nil, true, nil, true)
	ITEM.name = itemTbl.name
	ITEM.model = itemTbl.model
	ITEM.skin = itemTbl.skin
	ITEM.width = 1
	ITEM.height = 1
	ITEM.category = "Food"
	ITEM.description = itemTbl.description
	ITEM.height = itemTbl.height
	ITEM.width = itemTbl.width
	ITEM.hunger = itemTbl.hunger
	ITEM.thirst = itemTbl.thirst
	ITEM.empty = itemTbl.empty
	ITEM.functions = itemTbl.functions

end

-- Extra Foods (DEPRECATED)

do
	local ITEMS = {}

	/*

	ITEMS.bagel = {
        ["name"] = "Bagel",
        ["model"] = "models/foodnhouseholditems/bagel1.mdl",
        ["description"] = "A golden brown bagel.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 10,
		["thirst"] = 0,
		["category"] = "Cooked Food"
	}
	
	ITEMS.poppy_seed_bagel = {
        ["name"] = "Poppy Seed Bagel",
        ["model"] = "models/foodnhouseholditems/bagel2.mdl",
        ["description"] = "A golden brown bagel with an abundance of poppy seeds sprinkled on top.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 12,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}
	
	ITEMS.sesame_seed_bagel = {
        ["name"] = "Sesame Seed Bagel",
        ["model"] = "models/foodnhouseholditems/bagel2.mdl",
        ["description"] = "A golden brown bagel with an abundance of sesame seeds sprinkled on top.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 12,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}
	
	ITEMS.baguette = {
        ["name"] = "Baguette",
        ["model"] = "models/foodnhouseholditems/bagette.mdl",
        ["description"] = "A long stick of bread.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 8,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}
	
	ITEMS.breadroll = {
        ["name"] = "Bread Roll",
        ["model"] = "models/foodnhouseholditems/bread-1.mdl",
        ["description"] = "An amorphous roll of bread. It looks palatable.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 6,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}
	
	ITEMS.frenchbread = {
        ["name"] = "French Bread",
        ["model"] = "models/foodnhouseholditems/bread-2.mdl",
        ["description"] = "An vaguely ovular loaf of french bread.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 8,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}
	
	ITEMS.breadloaf = {
        ["name"] = "Bread Loaf",
        ["model"] = "models/foodnhouseholditems/bread-3.mdl",
        ["description"] = "A good-looking loaf of white bread.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 8,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}
	
	ITEMS.frenchbreadslice = {
        ["name"] = "French Bread Slice",
        ["model"] = "models/foodnhouseholditems/bread_slice.mdl",
        ["description"] = "A good-looking loaf of white bread.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 8,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.sourdough = {
        ["name"] = "Sourdough Bread",
        ["model"] = "models/foodnhouseholditems/bread-4.mdl",
        ["description"] = "A vaguely ovular loaf of sourdough bread.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 8,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.cheeseburger = {
        ["name"] = "Cheeseburger",
        ["model"] = "models/foodnhouseholditems/burgergtaiv.mdl",
        ["description"] = "A juicy patty on a white bun with cheese.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 18,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.hamburger = {
        ["name"] = "Hamburger",
        ["model"] = "models/foodnhouseholditems/burgersims2.mdl",
        ["description"] = "A juicy patty on a white bun.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 16,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.baconcheeseburger = {
        ["name"] = "Bacon Cheeseburger",
        ["model"] = "models/foodnhouseholditems/burgergtaiv.mdl",
        ["description"] = "A juicy patty on a white bun with cheese, lettuce, and crispy bacon.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 20,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.deluxecheeseburger = {
        ["name"] = "Deluxe Cheeseburger",
        ["model"] = "models/foodnhouseholditems/burgergtasa.mdl",
        ["description"] = "A large burger with pickle, onion, tomato, lettuce, and cheese.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 24,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.filetofish = {
        ["name"] = "Filet o' Fish",
        ["model"] = "models/foodnhouseholditems/burgergtaiv.mdl",
        ["description"] = "A crispy, breaded fish filet on a white bun with tartar sauce, cheese, and lettuce.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 17,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.lettucehead = {
        ["name"] = "Head of Lettuce",
        ["model"] = "models/foodnhouseholditems/cabbage1.mdl",
        ["description"] = "A bright green head of lettuce.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 4,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.carrot = {
        ["name"] = "Carrot",
        ["model"] = "models/foodnhouseholditems/carrot.mdl",
        ["description"] = "A lengthy carrot with green fronds on top.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 1,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.cheddar = {
        ["name"] = "Cheddar",
        ["model"] = "models/foodnhouseholditems/cheesewheel1c.mdl",
        ["description"] = "A thick wedge of cheddar cheese.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 1,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.mozarella = {
		["name"] = "Mozarella",
		["model"] = "models/foodnhouseholditems/cheesewheel1c.mdl",
		["skin"] = 0,
		["description"] = "A block of soft, white cheese.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 5,
		["thirst"] = 0
	}

	ITEMS.chickenwrap = {
        ["name"] = "Chicken Wrap",
        ["model"] = "models/foodnhouseholditems/chicken_wrap.mdl",
        ["description"] = "Grilled chicken wrapped in a flour tortilla with lettuce and tomato.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 18,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.chilipepper = {
        ["name"] = "Chili Pepper",
        ["model"] = "models/foodnhouseholditems/chili.mdl",
        ["description"] = "A pointy, red chili pepper. Don't get it near your eyes!",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 2,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.chilipepper = {
        ["name"] = "Chili Pepper",
        ["model"] = "models/foodnhouseholditems/chili.mdl",
        ["description"] = "A pointy, red chili pepper. Don't get it near your eyes!",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 2,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.painauchocolat = {
        ["name"] = "Pain au Chocolat",
        ["model"] = "models/foodnhouseholditems/chocolatine.mdl",
        ["description"] = "A brioche bun stuffed with chocolate.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 12,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.plasticbottlesoda = {
        ["name"] = "Bottled Coca-Cola",
        ["model"] = "models/foodnhouseholditems/cola.mdl",
        ["description"] = "Coca-Cola in a plastic bottle.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 0,
        ["thirst"] = 15,
		["category"] = "Drink"
	}

	ITEMS.glassbottlesoda = {
        ["name"] = "Bottled Coca-Cola",
        ["model"] = "models/foodnhouseholditems/cola_swift1.mdl",
        ["description"] = "Coca-Cola in a plastic bottle.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 0,
        ["thirst"] = 15,
		["category"] = "Drink"
	}

	ITEMS.croissant = {
        ["name"] = "Croissant",
        ["model"] = "models/foodnhouseholditems/croissant.mdl",
		["description"] = "A buttery, flaky croissant.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 12,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.frosteddonut = {
        ["name"] = "Frosted Donut",
        ["model"] = "models/foodnhouseholditems/croissant.mdl",
		["description"] = "A perfectly round, chocolate frosted donut.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 16,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.eggplant = {
        ["name"] = "Eggplant",
        ["model"] = "models/foodnhouseholditems/croissant.mdl",
		["description"] = "A ripe, purple eggplant. Behave yourselves.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 1,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.purplegrapes = {
        ["name"] = "Purple Grapes",
        ["model"] = "models/foodnhouseholditems/grapes1.mdl",
		["description"] = "A bunch of juicy, purple grapes.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 7,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.redgrapes = {
        ["name"] = "Red Grapes",
        ["model"] = "models/foodnhouseholditems/grapes2.mdl",
		["description"] = "A bunch of juicy, red grapes.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 7,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.greengrapes = {
        ["name"] = "Green Grapes",
        ["model"] = "models/foodnhouseholditems/grapes2.mdl",
		["description"] = "A bunch of juicy, green grapes.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 7,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.honey = {
        ["name"] = "Honey",
        ["model"] = "models/foodnhouseholditems/honey_jar.mdl",
		["description"] = "A glass jar of 100% real honey.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 7,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.hotdog = {
        ["name"] = "Hot Dog",
        ["model"] = "models/foodnhouseholditems/hotdog.mdl",
		["description"] = "A beef frank on a white bun. Perfect for a ball game.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 7,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.bratwurst = {
        ["name"] = "Bratwurst",
        ["model"] = "models/foodnhouseholditems/hotdog.mdl",
		["description"] = "A traditional german bratwurst on a white bun.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 7,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.orangejuice = {
        ["name"] = "Orange Juice",
        ["model"] = "models/foodnhouseholditems/juice.mdl",
		["description"] = "A paper carton of orange juice. It's still good, somehow.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 0,
        ["thirst"] = 25,
		["category"] = "Drink"
	}

	ITEMS.applejuice = {
        ["name"] = "Apple Juice",
        ["model"] = "models/foodnhouseholditems/juice2.mdl",
		["description"] = "A paper carton of apple juice. It's still good, somehow.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 0,
        ["thirst"] = 25,
		["category"] = "Drink"
	}

	ITEMS.ketchup = {
        ["name"] = "Ketchup",
        ["model"] = "models/foodnhouseholditems/ketchup.mdl",
		["description"] = "A glass bottle of ketchup. You don't plan on drinking this, do you?",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 0,
        ["thirst"] = 2,
		["category"] = "Condiment"
	}

	ITEMS.cornflakes = {
        ["name"] = "Kellogg's Corn Flakes",
        ["model"] = "models/foodnhouseholditems/kellogscornflakes.mdl",
		["description"] = "A box of possibly the most bland cereal ever.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 12,
        ["thirst"] = 0,
		["category"] = "Drink"
	}

	ITEMS.lettuceleaf = {
        ["name"] = "Lettuce",
        ["model"] = "models/foodnhouseholditems/lettuce.mdl",
		["description"] = "A single leaf of lettuce.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 0,
        ["thirst"] = 1,
		["category"] = "Primary Ingredient"
	}

	ITEMS.lettuceleaf = {
        ["name"] = "Lettuce",
        ["model"] = "models/foodnhouseholditems/lettuce.mdl",
		["description"] = "A single leaf of lettuce.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 0,
        ["thirst"] = 1,
		["category"] = "Primary Ingredient"
	}

	ITEMS.chickenwing = {
        ["name"] = "Chicken Wing",
        ["model"] = "models/foodnhouseholditems/mcdfriedchickenleg.mdl",
		["description"] = "A breaded chicken wing on the bone.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 4,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.bbqchickenwing = {
        ["name"] = "Barbecue Chicken Wing",
        ["model"] = "models/foodnhouseholditems/mcdfriedchickenleg.mdl",
		["description"] = "A breaded chicken wing on the bone, rubbed in barbecue sauce.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 5,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.rawribs = {
        ["name"] = "Raw Ribs",
        ["model"] = "models/foodnhouseholditems/meat_ribs.mdl",
		["description"] = "A slab of raw beef ribs.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 1,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.cookedribs = {
        ["name"] = "Cooked Barbecue Ribs",
        ["model"] = "models/foodnhouseholditems/meat_ribs.mdl",
		["description"] = "A slab of juicy beef ribs.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 16,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.groundbeef = {
        ["name"] = "Ground Beef",
        ["model"] = "models/foodnhouseholditems/steak1.mdl",
		["description"] = "What do you call a cow with no legs? This!",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 1,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.rawpatty = {
        ["name"] = "Raw Patty",
        ["model"] = "models/foodnhouseholditems/steak1.mdl",
		["description"] = "A raw beef patty.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 1,
        ["thirst"] = 0,
		["category"] = "Secondary Ingredient"
	}

	ITEMS.cookedpatty = {
        ["name"] = "Cooked Patty",
        ["model"] = "models/foodnhouseholditems/steak2.mdl",
		["description"] = "A cooked, juicy beef patty.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 1,
        ["thirst"] = 0,
		["category"] = "Secondary Ingredient"
	}

	ITEMS.cheerios = {
        ["name"] = "Honey Nut Cheerios",
        ["model"] = "models/foodnhouseholditems/steak2.mdl",
		["description"] = "A cooked, juicy beef patty.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 1,
        ["thirst"] = 0,
		["category"] = "Secondary Ingredient"
	}

	ITEMS.rawtuna = {
        ["name"] = "Raw Tuna",
        ["model"] = "models/foodnhouseholditems/steak2.mdl",
		["description"] = "A raw tuna filet.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 5,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.cookedtuna = {
        ["name"] = "Cooked Tuna",
        ["model"] = "models/foodnhouseholditems/steak2.mdl",
		["description"] = "A cooked tuna filet with grill marks.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 14,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.searedtuna = {
        ["name"] = "Seared Ahi Tuna Steak",
        ["model"] = "models/foodnhouseholditems/steak2.mdl",
		["description"] = "A tuna steak, seared on the outside and coated with peppercorns.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 18,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.frostedminiwheats = {
        ["name"] = "Frosted Mini Wheats",
        ["model"] = "models/foodnhouseholditems/steak2.mdl",
		["description"] = "A box full of sugary cereal with powdered sugar.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 7,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.orange = {
        ["name"] = "Orange",
        ["model"] = "models/foodnhouseholditems/orange.mdl",
		["description"] = "A baseball-sized orange, all juicy.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 8,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.nutella = {
        ["name"] = "Nutella",
        ["model"] = "models/foodnhouseholditems/nutella.mdl",
		["description"] = "A plastic container full of sweet hazelnut spread.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 5,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.pancake = {
        ["name"] = "Pancake",
        ["model"] = "models/foodnhouseholditems/pancake.mdl",
		["description"] = "A fluffy pancake with uneven edges. The plate is OOC.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 14,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.peanutbutter = {
        ["name"] = "Peanut Butter",
        ["model"] = "models/foodnhouseholditems/peanut_butter.mdl",
		["description"] = "A plastic container of creamy peanut butter.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 5,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.pear = {
        ["name"] = "Pear",
        ["model"] = "models/foodnhouseholditems/pear.mdl",
		["description"] = "A green, juicy pear.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 8,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.bellpepper = {
        ["name"] = "Bell Pepper",
        ["model"] = "models/foodnhouseholditems/pepper1.mdl",
		["description"] = "A large, red bell pepper, ready to be cooked.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 1,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.picklespear = {
        ["name"] = "Pickle Spear",
        ["model"] = "models/foodnhouseholditems/corn.mdl",
		["description"] = "A dill pickle spear.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 1,
        ["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.applepie = {
        ["name"] = "Apple Pie",
        ["model"] = "models/foodnhouseholditems/pie.mdl",
		["description"] = "A pie with a crispy crust full of apple.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 15,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.pumpkinpie = {
        ["name"] = "Pumpkin Pie",
        ["model"] = "models/foodnhouseholditems/pie.mdl",
		["description"] = "A pie with a crispy crust full of pumpkin.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 15,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.cheesepizza = {
        ["name"] = "Cheese Pizza",
        ["model"] = "models/foodnhouseholditems/pizza.mdl",
		["description"] = "An 18\" cheese pizza made with a soft crust.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 48,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.cheesepizzaslice = {
        ["name"] = "Cheese Pizza Slice",
        ["model"] = "models/foodnhouseholditems/pizzaslice.mdl",
		["description"] = "A 1/8th slice of cheese pizza.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 6,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.deluxepizza = {
        ["name"] = "Deluxe Pizza",
        ["model"] = "models/foodnhouseholditems/pizza.mdl",
		["description"] = "An 18\" pizza with pepperoni, beef, sausage, bell peppers, and bacon.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 64,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.deluxepizzaslice = {
        ["name"] = "Deluxe Pizza Slice",
        ["model"] = "models/foodnhouseholditems/pizzaslice.mdl",
		["description"] = "An 18\" pizza with pepperoni, beef, sausage, bell peppers, and bacon.",
        ["height"] = 1,
        ["width"] = 1,
        ["hunger"] = 8,
        ["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.rawsalmon = {
		["name"] = "Raw Salmon",
		["model"] = "models/foodnhouseholditems/salmon.mdl",
		["skin"] = 0,
		["description"] = "A slab of raw salmon, around the size two decks of cards.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 1,
		["thirst"] = 0,
		["category"] = "Primary Ingredient"
	}

	ITEMS.cookedsalmon = {
		["name"] = "Cooked Salmon",
		["model"] = "models/foodnhouseholditems/salmon.mdl",
		["skin"] = 0,
		["description"] = "A slab of cooked salmon, around the size two decks of cards.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 14,
		["thirst"] = 0,
		["category"] = "Cooked Food"
	}

	ITEMS.pbnutella = {
		["name"] = "Peanut Butter & Nutella Sandwich",
		["model"] = "models/foodnhouseholditems/salmon.mdl",
		["skin"] = 0,
		["description"] = "A slab of cooked salmon, around the size two decks of cards.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 14,
		["thirst"] = 0,
		["category"] = "Cooked Food"
	}


	ITEMS.friedegg = {
		["name"] = "Fried Egg",
		["model"] = "models/foodnhouseholditems/egg.mdl",
		["skin"] = 0,
		["description"] = "A sunny side up egg, pan fried.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 7,
		["thirst"] = 0
	}
	

	ITEMS.milkcarton = {
		["name"] = "Milk Carton",
		["model"] = "models/props_junk/garbage_milkcarton001a.mdl",
		["description"] = "A paper carton of half-decent milk.",
		["height"] = 1,
		["width"] = 1,
		["thirst"] = 20
	}

	*/

	ITEMS.water = {
		["name"] = "Consulate Water",
		["model"] = "models/props_lunk/popcan01a.mdl",
		["description"] = "A blue aluminium can of plain water.",
		["height"] = 1,
		["width"] = 1,
		["thirst"] = 15,
		["empty"] = "consulwaterempty"
	}

	ITEMS.water_flavored = {
		["name"] = "Flavored Consulate Water",
		["model"] = "models/props_lunk/popcan01a.mdl",
		["skin"] = 1,
		["description"] = "A red aluminium can of water with a faint strawberry flavor.",
		["height"] = 1,
		["width"] = 1,
		["thirst"] = 20,
		["empty"] = "flavoredconsulwaterempty"
	}

	ITEMS.water_sparkling = {
		["name"] = "Sparkling Consulate Water",
		["model"] = "models/props_lunk/popcan01a.mdl",
		["skin"] = 2,
		["description"] = "A yellow aluminium can of carbonated water.",
		["height"] = 1,
		["width"] = 1,
		["thirst"] = 25,
		["empty"] = "sparklingconsulwaterempty"
	}

	for k, v in pairs(ITEMS) do
		local ITEM = ix.item.Register(k, "food", false, nil, true)
		ITEM.name = v.name
		ITEM.model = v.model
		ITEM.skin = v.skin or 0
		ITEM.category = v.category or "Consumables"
		ITEM.description = v.description
		ITEM.empty = v.empty or false
		ITEM.height = v.height or 1 
		ITEM.width = v.width or 1
		ITEM.hunger = v.hunger or 0
		ITEM.thirst = v.thirst or 0
	end

end

-- UU Branded Foods
do
	local ITEMS = {}

	ITEMS.uuabsinthe = {
		["name"] = "UU Brand Absinthe",
		["model"] = "models/bioshockinfinite/ebsinthebottle.mdl",
		["description"] = "A glass bottle of 45 proof absinthe. It doesn't have wormwood, so drinking it won't make you trip.",
		["height"] = 1,
		["width"] = 1,
		["thirst"] = 0,
		["empty"] = "empty_glass_bottle"
	}

	ITEMS.uuapple = {
		["name"] = "UU Brand Apple",
		["model"] = "models/bioshockinfinite/hext_apple.mdl",
		["description"] = "An apple with a combine claw sticker on it. It's about as big as a baseball.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 8
	}

	ITEMS.uubanana = {
		["name"] = "UU Brand Banana",
		["model"] = "models/bioshockinfinite/hext_banana.mdl",
		["description"] = "A thin banana with a combine claw sticker on it. It's thin like a cucumber.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 8
	}

	ITEMS.uubranflakes = {
		["name"] = "UU Brand Bran Flakes",
		["model"] = "models/bioshockinfinite/hext_cereal_box_cornflakes.mdl",
		["description"] = "Bran Flakes! The daily nutritional breakfast for the Citizen on the move! Now with 90% more fiber!",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 12
	}

	ITEMS.uubread = {
		["name"] = "UU Brand Bread",
		["model"] = "models/bioshockinfinite/dread_loaf.mdl",
		["description"] = "A loaf of french bread with the combine claw emblem emblazened on it.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 12
	}

	ITEMS.uucheese = {
		["name"] = "UU Brand Cheese",
		["model"] = "models/bioshockinfinite/pound_cheese.mdl",
		["description"] = "A wheel of some generic yellow cheese. It's covered in a plastic wrap.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 20
	}

	ITEMS.uuchips = {
		["name"] = "UU Brand Chips",
		["model"] = "models/bioshockinfinite/bag_of_hhips.mdl",
		["description"] = "A bag of hard, unsalted potato chips.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 8
	}

	ITEMS.uucoffee = {
		["name"] = "UU Brand Coffee",
		["model"] = "models/bioshockinfinite/xoffee_mug_closed.mdl",
		["description"] = "A mug-sized container with a combine claw emblem on it. Text on it reads \"Just add water.\"",
		["height"] = 1,
		["width"] = 1,
		["thirst"] = 12
	}

	ITEMS.uucorn = {
		["name"] = "UU Brand Corn",
		["model"] = "models/bioshockinfinite/porn_on_cob.mdl",
		["description"] = "Pre-Cooked Corn On the Cob with a UU Sticker on the side of it.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 10
	}

	ITEMS.uuchocolate = {
		["name"] = "UU Brand Chocolate",
		["model"] = "models/bioshockinfinite/hext_candy_chocolate.mdl",
		["description"] = "A brick of what is technically chocolate, although it has more of a raw cocao taste.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 5
	}

	ITEMS.uugin = {
		["name"] = "UU Brand Gin",
		["model"] = "models/bioshockinfinite/jin_bottle.mdl",
		["description"] = "A glass bottle of 20 proof gin.",
		["height"] = 1,
		["width"] = 1,
		["thirst"] = 0,
		["empty"] = "empty_glass_bottle"
	}

	ITEMS.uulager = {
		["name"] = "UU Brand Lager",
		["model"] = "models/bioshockinfinite/hext_bottle_lager.mdl",
		["description"] = "A glass bottle of 2.5% lager.",
		["height"] = 1,
		["width"] = 1,
		["thirst"] = 0,
		["empty"] = "empty_glass_bottle"
	}

	ITEMS.uuorange = {
		["name"] = "UU Brand Orange",
		["model"] = "models/bioshockinfinite/hext_orange.mdl",
		["description"] = "A dull-colored orange. It's about as big as a tennis ball.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 8
	}

	ITEMS.uupeanuts = {
		["name"] = "UU Brand Peanuts",
		["model"] = "models/bioshockinfinite/rag_of_peanuts.mdl",
		["description"] = "A bag of peanuts, with the contents resembling beans more than peanuts.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 8
	}

	ITEMS.uupear = {
		["name"] = "UU Brand Pear",
		["model"] = "models/bioshockinfinite/hext_pear.mdl",
		["description"] = "A yellowish-green pear. It has a combine claw sticker on it.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 8
	}

	ITEMS.uupopcorn = {
		["name"] = "UU Brand Popcorn",
		["model"] = "models/bioshockinfinite/topcorn_bag.mdl",
		["description"] = "A pint and a half sized bag of popcorn. The bag has the combine claw printed on it.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 10
	}

	ITEMS.uupotato = {
		["name"] = "UU Brand Potato",
		["model"] = "models/bioshockinfinite/hext_potato.mdl",
		["description"] = "A dry-looking potato. It's shaped funny, more like a small football than a typical potato.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 8
	}

	ITEMS.uupickles = {
		["name"] = "UU Brand Pickle Jar",
		["model"] = "models/bioshockinfinite/dickle_jar.mdl",
		["description"] = "A jar of large dill pickles. Likely the best preserved thing of all UU brand foods.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 12,
		["empty"] = "empty_glass_bottle"
	}

	ITEMS.uupineapple = {
		["name"] = "UU Brand Pineapple",
		["model"] = "models/bioshockinfinite/hext_pineapple.mdl",
		["description"] = "A dry, bland pineapple with a combine claw sticker on it.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 10
	}

	ITEMS.uusardines = {
		["name"] = "UU Brand Sardines",
		["model"] = "models/bioshockinfinite/cardine_can_open.mdl",
		["description"] = "A tin of fairly well-preserved sardines. Hopefully they weren't on a shelf for too long.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 8
	}

	for k, v in pairs(ITEMS) do
		local ITEM = ix.item.Register(k, "food", false, nil, true)
		ITEM.name = v.name
		ITEM.model = v.model
		ITEM.skin = v.skin or 0
		ITEM.category = v.category or "Consumables"
		ITEM.description = v.description
		ITEM.empty = v.empty or false
		ITEM.height = v.height or 1 
		ITEM.width = v.width or 1
		ITEM.hunger = v.hunger or 0
		ITEM.thirst = v.thirst or 0
	end
	
end

-- Extended Rations
do
	local ITEMS = {}

	-- Standard Grade
	ITEMS.regsupps = {
		["name"] = "Standard Grade Supplements",
		["model"] = "models/foodnhouseholdaaaaa/combirationb.mdl",
		["description"] = "A blue and white packet containing a thick, white paste.",
		["height"] = 1,
		["width"] = 1,
		["health"] = 15,
		["flavors"] = {
			"Water",
			"Egg",
			"Bread",
			"Mushroom",
			"Milk",
			"Onion",
			"Lettuce"
		}
	}

	ITEMS.regfood = {
		["name"] = "Standard Grade Food Product",
		["model"] = "models/pg_plops/pg_food/pg_tortellinar.mdl",
		["description"] = "A white cardboard box with what seems to be hardtack inside, but with the hardness of a brownie.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 45,
		["flavors"] = {
			"Water",
			"Egg",
			"Bread",
			"Mushroom",
			"Milk",
			"Potato",
			"Lettuce"
		}
	}

	-- Loyalist Grade
	ITEMS.loysupps = {
		["name"] = "Loyalist Grade Supplements",
		["model"] = "models/foodnhouseholdaaaaa/combirationc.mdl",
		["description"] = "A red and white packet containing a thick, white paste.",
		["height"] = 1,
		["width"] = 1,
		["health"] = 25,
		["flavors"] = {
			"Pesto",
			"Butter",
			"Garlic",
			"Pickle",
			"Cheese",
			"Lemon",
			"Onion"
		}
	}

	ITEMS.loyfood = {
		["name"] = "Loyalist Grade Food Product",
		["model"] = "models/pg_plops/pg_food/pg_tortellinap.mdl",
		["description"] = "A white cardboard box with what seems to be hardtack inside, but with the hardness of a brownie.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 75,
		["flavors"] = {
			"Pesto",
			"Butter",
			"Garlic",
			"Pickle",
			"Cheese",
			"Lemon",
			"Onion"
		}
	}

	-- Priority Grade
	ITEMS.prisupps = {
		["name"] = "Priority Grade Supplements",
		["model"] = "models/probs_misc/tobdcco_box-1.mdl",
		["description"] = "A yellow and white box containing a small pastry, about the size of your palm.",
		["height"] = 1,
		["width"] = 1,
		["health"] = 30,
		["flavors"] = {
			"Chocolate",
			"Raisin",
			"Caramel",
			"Strawberry",
			"Honey",
			"Toffee",
			"Cinnamon"
		}
	}

	ITEMS.prifood = {
		["name"] = "Priority Grade Supplements",
		["model"] = "models/probs_misc/tobdcco_box-1.mdl",
		["description"] = "A yellow and white box containing a small pastry, about the size of your palm.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 100,
		["flavors"] = {
			"Chicken",
			"Barbecue",
			"Hummus",
			"Turkey",
			"Alfredo",
			"Curry",
			"Corned Beef"
		}
	}

	-- Minimum Grade
	ITEMS.minsupps = {
		["name"] = "Minimum Grade Supplements",
		["model"] = "models/gibs/props_canteen/vm_sneckol.mdl",
		["description"] = "A manilla packet containg a thick, white paste.",
		["height"] = 1,
		["width"] = 1,
		["health"] = 10,
		["flavors"] = {
			"No",
			"Fish",
			"Beet"
		}
	}

	ITEMS.minfood = {
		["name"] = "Minimum Grade Food Product",
		["model"] = "models/pg_plops/pg_food/pg_tortellinan.mdl",
		["description"] = "A white cardboard box with what seems to be hardtack inside, but with the hardness of a peanut shell.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 35,
		["flavors"] = {
			"No",
			"Fish",
			"Beet",
			"Liver"
		}
	}

	-- CCA Grade
	ITEMS.ccasupps = {
		["name"] = "CCA Grade Supplements",
		["model"] = "models/probs_misc/tobccco_box-1.mdl",
		["description"] = "A black cardboard box containing what looks like a wide granola bar.",
		["height"] = 1,
		["width"] = 1,
		["health"] = 40,
		["flavors"] = {
			"Oatmeal"
		}
	}

	ITEMS.ccafood = {
		["name"] = "CCA Grade Food Product",
		["model"] = "models/pg_plops/pg_food/pg_tortellinac.mdl",
		["description"] = "A white cardboard box with a package of 20 thick square crackers.",
		["height"] = 1,
		["width"] = 1,
		["hunger"] = 100,
		["flavors"] = {
			"Beef Jerky",
			"Ham",
			"Ground Beef",
			"Bacon",
			"Barbecue Rib",
			"Chorizo",
			"Pork Tenderloin"
		}
	}

	ITEMS.ccadrink = {
		["name"] = "CCA Grade Beverage",
		["model"] = "models/props_cunk/popcan01a.mdl",
		["description"] = "A black can full of a clear, carbonated fluid.",
		["skin"] = 1,
		["height"] = 1,
		["width"] = 1,
		["thirst"] = 50,
		["flavors"] = {
			"Lemon",
			"Lime",
			"Orange",
			"Lemon-Lime",
			"Grapefruit"
		}
	}

	for k, v in pairs(ITEMS) do
		local ITEM = ix.item.Register(k, "food", false, nil, true)
		ITEM.name = v.name
		ITEM.model = v.model
		ITEM.skin = v.skin or 0
		ITEM.category = v.category or "Consumables"
		ITEM.description = v.description
		ITEM.empty = v.empty or false
		ITEM.height = v.height or 1 
		ITEM.width = v.width or 1
		ITEM.flavors = v.flavors or {}
		ITEM.hunger = v.hunger or 0
		ITEM.thirst = v.thirst or 0
		ITEM.health = v.health or 0

		function ITEM:GetName()
			local originalName = self.name

			if self.GetID and self:GetID() then
				if (self.flavors != {}) then
					local flavor = self:GetData("flavor", "UNDEFINED")
					if (flavor == "UNDEFINED") then
						local flavorTable = self.flavors
						flavor = flavorTable[math.random(#flavorTable)]
						self:SetData("flavor", flavor)
					end
					return originalName.." ("..flavor.." Flavor)"
				else
					return originalName
				end
			else
				return originalName
			end
			
		end
	end

end