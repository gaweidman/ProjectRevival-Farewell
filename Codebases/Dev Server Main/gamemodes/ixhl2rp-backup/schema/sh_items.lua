--To add a new item or remove an item, this is the file to do it.

local ITEMS = {}

ITEMS.scrap_metal = {
	["name"] = "Scrap Metal",
	["model"] = "models/illusion/eftcontainers/weaponparts.mdl",
	["description"] = "A small chunk of scrap metal, useless unless combined with other items.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 75 --This is used for the 'item spawner plugin' this defines how many 'tickets' the item gets to spawn.
} 

ITEMS.scrap_wood = {
	["name"] = "Scrap Wood",
	["model"] = "models/props_junk/wood_crate001a_chunk09.mdl",
	["description"] = "A fragment of wood, still usable.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 75
}

ITEMS.refined_metal = {
	["name"] = "Refined Metal",
	["model"] = "models/mosi/fallout4/props/junk/components/aluminum.mdl",
	["description"] = "A small chunk of refined metal, useless unless combined with other items.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 10
}

ITEMS.scrap_electronics = {
	["name"] = "Scrap Electronics",
	["model"] = "models/props_lab/reciever01c.mdl",
	["description"] = "A small assorted set of Electronics, useless unless broken down into individual components or combined with other items.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 45
}

ITEMS.scrap_plastic = {
	["name"] = "Scrap Plastic",
	["model"] = "models/props_c17/canisterchunk01a.mdl",
	["description"] = "A hunk of plastic, broken down from a plastic item.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 45
}

ITEMS.teflon = {
	["name"] = "Teflon",
	["model"] = "models/mosi/fallout4/props/junk/components/rubber.mdl",
	["description"] = "A glossy sheet of elastic material.",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.refined_electronics = {
	["name"] = "Refined Electronics",
	["model"] = "models/props_lab/reciever01b.mdl",
	["description"] = "A small assorted set of Electronics, it's been refined to perfection.",
	["width"] = 2,
	["height"] = 1,
	["chance"] = 3
}

ITEMS.empty_milk_gallon = {
	["name"] = "Empty Milk Gallon",
	["model"] = "models/props_junk/garbage_milkcarton002a.mdl",
	["description"] = "An empty plastic jug of milk.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 60
}

ITEMS.empty_paint_can = {
	["name"] = "Empty Paint Can",
	["model"] = "models/props_junk/metal_paintcan001b.mdl",
	["description"] = "An empty paint can.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 80
}

ITEMS.old_newspaper = {
	["name"] = "Old Newspaper",
	["model"] = "models/props_junk/garbage_newspaper001a.mdl",
	["description"] = "An old issue of The Terminal, dated a couple years ago.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 80
}

ITEMS.cardboard_scraps = {
	["name"] = "Cardboard Scraps",
	["model"] = "models/props_junk/garbage_carboard002a.mdl",
	["description"] = "Some scraps of cardboard.",
	["width"] = 2,
	["height"] = 1,
	["chance"] = 80
}

ITEMS.locker_door = {
	["name"] = "Locker Door",
	["model"] = "models/props_lab/lockerdoorleft.mdl",
	["description"] = "A simple locker door.",
	["width"] = 1,
	["height"] = 4,
	["chance"] = 1
}

ITEMS.cloth_scrap = {
	["name"] = "Cloth Scrap",
	["model"] = "models/mosi/fallout4/props/junk/dishrag.mdl",
	["description"] = "A set of scrap cloth.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 90
}

ITEMS.sewn_cloth = {
	["name"] = "Sewn Cloth",
	["model"] = "models/tnb/items/facewrap.mdl",
	["skin"] = 1,
	["description"] = "A sewn set of cloth, useful for crafting clothing.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 10
}

ITEMS.empty_ammo_box = {
	["name"] = "Empty Ammunition Case",
	["model"] = "models/Items/BoxSRounds.mdl",
	["description"] = "An empty box of used ammunition.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 75
}

ITEMS.bullet_casings = {
	["name"] = "Bullet Casings",
	["model"] = "models/Items/357ammobox.mdl",
	["description"] = "A set of bullet casings, used up",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 85
}

ITEMS.ration_wrap = {
	["name"] = "Ration Wrapper",
	["model"] = "models/weapons/w_package.mdl",
	["description"] = "An empty ration wrapper.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 1
}

ITEMS.gunpowder = {
	["name"] = "Gunpowder",
	["model"] = "models/props_lab/box01a.mdl",
	["description"] = "A small bit of black powder, used to pack bullets and fill explosives.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 45
}

ITEMS.plank = {
	["name"] = "Plank",
	["model"] = "models/props_debris/wood_board06a.mdl",
	["description"] = "A wooden plank.",
	["width"] = 1,
	["height"] = 3,
	["chance"] = 80
}

ITEMS.normal_screwdriver = {
	["name"] = "Screwdriver",
	["model"] = "models/illusion/eftcontainers/screwdriver.mdl",
	["description"] = "A screwdriver with a red handle.",
	["width"] = 2,
	["height"] = 1,
	["chance"] = 20,
	["tool"] = true
}

ITEMS.hammer = {
	["name"] = "Hamnmer",
	["model"] = "models/mosi/fallout4/props/junk/hammer03.mdl",
	["description"] = "An old hammer with a wooden handle and rusty head.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 20,
	["tool"] = true
}

ITEMS.solderingiron = {
	["name"] = "Soldering Iron",
	["model"] = "mmodels/props_c17/TrapPropeller_Lever.mdl",
	["description"] = "A pen-shaped soldering iron with a large battery pack.",
	["width"] = 1,
	["height"] = 1,
	["chance"] = 20,
	["tool"] = true
}

ITEMS.blowtorch = {
	["name"] = "Blowtorch",
	["model"] = "models/props_silo/welding_torch.mdl",
	["description"] = "A nice blowtorch with a switch and an igniter.",
	["tool"] = true
}

ITEMS.brokencputower = {
	["name"] = "Broken Computer Tower",
	["model"] = "models/props_lab/harddrive02.mdl",
	["description"] = "A broken computer tower from the nineties. It's got mud on it.",
	["width"] = 2,
	["height"] = 2
}

ITEMS.emptysodabottle = {
	["name"] = "Empty Soda Bottle",
	["model"] = "models/props_junk/garbage_plasticbottle003a.mdl",
	["description"] = "A plastic bottle that used to have soda. Its label is faded off.",
	["width"] = 1,
	["height"] = 1
}

ITEMS.emptybleachbottle = {
	["name"] = "Empty Bleach Bottle",
	["model"] = "models/props_junk/garbage_plasticbottle003a.mdl",
	["description"] = "An empty bottle that used to contain bleach. The inside still reeks of the stuff.",
	["width"] = 1,
	["height"] = 1
}

ITEMS.consulwaterempty = {
	["name"] = "Empty Consulate Water Can",
	["model"] = "models/props_lunk/popcan01a.mdl",
	["description"] = "An empty blue can of Consulate water.",
	["width"] = 1,
	["height"] = 1
}

ITEMS.flavoredconsulwaterempty = {
	["name"] = "Empty Flavored Consulate Water Can",
	["model"] = "models/props_lunk/popcan01a.mdl",
	["description"] = "An empty red can of Consulate water.",
	["width"] = 1,
	["height"] = 1,
	["skin"] = 1

}

ITEMS.sparklingconsulwaterempty = {
	["name"] = "Empty Sparkling Consulate Water Can",
	["model"] = "models/props_lunk/popcan01a.mdl",
	["description"] = "An empty red can of Consulate water.",
	["width"] = 1,
	["height"] = 1,
	["skin"] = 2
}

ITEMS.brokencpumonitor = {
	["name"] = "Broken Computer Monitor",
	["model"] = "models/props_lab/monitor02.mdl",
	["description"] = "A nineties era computer monitor. The screen is intact but you hear something rattling inside it when it movies.",
	["width"] = 2,
	["height"] = 2,
}

ITEMS.brokenkeyboard = {
	["name"] = "Broken Keyboard",
	["model"] = "models/props_c17/computer01_keyboard.mdl",
	["description"] = "A nineties era keyboard. The keys are long faded off.",
	["width"] = 2,
	["height"] = 1,
}

ITEMS.brokenclock = {
	["name"] = "Broken Clock",
	["model"] = "models/props_c17/clock01.mdl",
	["description"] = "A wooden-backed clock that no longer ticks.",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.boot = {
	["name"] = "Boot",
	["model"] = "models/props_junk/Shoe001a.mdl",
	["description"] = "An old cloth boot. It's got what looks like years of mud stains on it.",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.emptycan = {
	["name"] = "Empty Tin Can",
	["model"] = "models/props_junk/garbage_metalcan001a.mdl",	
	["description"] = "An already-opened tin can with a mostly-gone label.",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.rftransmittersingle = {
	name = "Single-Channel RF Transmitter",
	model = "models/illusion/eftcontainers/virtex.mdl",
	description = "A small chip capable of transmitting radio frequency messages, but only on one preset frequency."
}

ITEMS.rftransmitter = {
	name = "RF Transmitter",
	model = "models/illusion/eftcontainers/virtex.mdl",
	description = "A small chip capable of transmitting radio frequency messages."
}

ITEMS.rfreceiver = {
	name = "RF receiver",
	model = "models/illusion/eftcontainers/virtex.mdl",
	description = "A small chip capable of receiving radio frequency messages."
}

ITEMS.rftransceiver = {
	name = "RF Transceiver",
	model = "models/illusion/eftcontainers/virtex.mdl",
	description = "A small chip capable of transmitting and receiving radio frequency messages."
}


ITEMS.rjammer_sr = {
	name = "Short Range Radio Jammer",
	model = "models/props_lab/powerbox02a.mdl",
	description = "A device around the size of a microwave with a single card at its center.",
	width = 1, 
	height = 1
}

ITEMS.rjammer_lr = {
	name = "Long Range Radio Jammer",
	model = "models/props_lab/powerbox02a.mdl",
	description = "A device around the size of a microwave with a single card at its center.",
	width = 1, 
	height = 1
}

ITEMS.civshirt = {
	["name"] = "Citizen Shirt",
	["model"] = "models/tnb/items/shirt_citizen1.mdl",
	["description"] = "A standard button-down blue citizen overshirt and white undershirt.",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.wirerope = {
	["name"] = "Wire Rope",
	["model"] = "models/mosi/fallout4/props/junk/components/fiberoptic.mdl",
	["description"] = "A shiny cable of woven stainless steel, wrapped up in a spool.",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.antlioncarapace = {
	["name"] = "Antlion Carapace",
	["model"] = "models/mosi/fallout4/props/junk/components/fiberoptic.mdl",
	["description"] = "A fragment of green antlion carapace. It's rough to the touch.",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.synthplating = {
	["name"] = "Synth Plating",
	["model"] = "models/mosi/fallout4/props/junk/components/fiberoptic.mdl",
	["description"] = "A piece of a Synth's hard outer shell.",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.emptysmgshells = {
	["name"] = "4.6x30 Shells",
	["model"] = "models/Items/BoxMRounds.mdl",
	["description"] = "A case of 45 empty 4.6x30 shells.",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.empty9mmrounds = {
	["name"] = "9mm Shells",
	["model"] = "models/Items/BoxSRounds.mdl",
	["description"] = "A case of 18 empty 9mm shells.",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.antlionarmor = {
	["name"] = "Antlion Shell Armor",
	["model"] = "models/Items/BoxSRounds.mdl",
	["description"] = "sadf sadfsadfasd",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.syntharmor = {
	["name"] = "Synth Shell Armor",
	["model"] = "models/Items/BoxSRounds.mdl",
	["description"] = "sadf sadfsadfasd",
	["width"] = 1,
	["height"] = 1,
}


for k, v in pairs(ITEMS) do
	local ITEM = ix.item.Register(k, nil, false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model
	ITEM.description = v.description
	ITEM.category = "Crafting"
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.chance = v.chance or 0
	ITEM.skin = v.skin or 0 
	ITEM.isTool = v.tool or false
end

ITEMS = {}

ITEMS.uu_corn = {
	["name"] = "UU Brand Corn",
	["model"] = "models/bioshockinfinite/porn_on_cob.mdl",
	["description"] = "A dried-out looking cob of- wait, why is it pre-shucked?"
}

ITEMS.uu_potato = {
	["name"] = "UU Brand Potato",
	["model"] = "models/bioshockinfinite/hext_potato.mdl",
	["description"] = "A brown, but plastic-looking potato with a UU sticker on it."
}

ITEMS.uu_bread = {
	["name"] = "UU Brand Bread",
	["model"] = "models/bioshockinfinite/dread_loaf.mdl",
	["description"] = "A near stale hunk of bread that would make the italians shiver in disgust."
}

ITEMS.uu_apple = {
	["name"] = "UU Brand Apple",
	["model"] = "models/bioshockinfinite/hext_apple.mdl",
	["description"] = "A bruised apple that looks like it's made out of wax."
}

ITEMS.uu_banana = {
	["name"] = "UU Brand Banana",
	["model"] = "models/bioshockinfinite/hext_banana.mdl",
	["description"] = "This brown-spotted banana isn't even good enough for a minion."
}

ITEMS.uu_orange = {
	["name"] = "UU Brand Pear",
	["model"] = "models/bioshockinfinite/hext_pear.mdl",
	["description"] = "You wouldn't call it orange so much as you would call it concerningly fake-looking."
}

ITEMS.uu_chocolate = {
	["name"] = "UU Brand Chocolate",
	["model"] = "models/bioshockinfinite/hext_candy_chocolate.mdl",
	["description"] = "This brown lump is comparable to something you'd find in a dog's backyard, both in texture and flavor."
}

ITEMS.uu_cereal = {
	["name"] = "UU Brand Cereal",
	["model"] = "models/bioshockinfinite/hext_cereal_box_cornflakes.mdl",
	["description"] = "Hey, at least they're like the real bran flakes, in that it tastes terrible."
}

ITEMS.uu_pineapple = {
	["name"] = "UU Brand Pineapple",
	["model"] = "models/bioshockinfinite/hext_pineapple.mdl",
	["Description"] = "You're positive pineapples shouldn't be this smooth."
}

ITEMS.uu_peanuts = {
	["name"] = "UU Brand Peanuts",
	["model"] = "models/bioshockinfinite/rag_of_peanuts.mdl",
	["description"] = "The peanuts have soft shells, and don't have any saltiness to them."
}

ITEMS.uu_cheese = {
	["name"] = "UU Brand Cheese",
	["model"] = "models/bioshockinfinite/pound_cheese.mdl",
	["description"] = "This cheese is about as real as american cheese. It looks edible enough, you suppose."
}

ITEMS.uu_coffee = {
	["name"] = "UU Brand Coffee",
	["model"] = "models/bioshockinfinite/xoffee_mug_closed.mdl",
	["description"] = "A container of coffee grounds. It's probably not dirt."
}

ITEMS.pondwater = {
	["name"] = "Clean Pond Water",
	["model"] = "models/props_junk/garbage_metalcan001a.mdl",
	["description"] = "A can of pond water. It tastes like various metals. It's clean though."
}

ITEMS.nuggies = {
	["name"] = "Antlion Grub Nugget",
	["model"] = "models/grub_nugget_medium.mdl",
	["description"] = "A yellow antlion grub nugget."
}

for k, v in pairs(ITEMS) do
	local ITEM = ix.item.Register(k, nil, false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model
	ITEM.description = v.description
	ITEM.category = "Consumables"
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.chance = v.chance or 0
	ITEM.isTool = v.tool or false
	ITEM.functions.Eat = {
		OnRun = function(itemTable)
			local client = itemTable.player
	
			client:SetHealth(math.min(client:Health() + 10, client:GetMaxHealth()))
	
			return true
		end
	}
end

local posterBase = ix.item.Register("poster", nil, true, nil, true)
posterBase.name = "Poster Base"
posterBase.model = "models/mosi/fallout4/props/junk/schematic.mdl"
posterBase.description = "A paper poster with some text on it."
posterBase.category = "Poster"
posterBase.width = 1
posterBase.height = 1
posterBase.textureName = "crematorposter.jpg"
posterBase.functions.place = {
    name = "Place",
    icon = "icon16/picture.png",
    OnRun = function(itemTable)
        local ply = itemTable.player

        ix.placement.StartPlacing(ply, itemTable:GetID())
       return false
    end
}

posterBase.functions.view = {

}

function posterBase:PopulateTooltip(tooltip)
	local preview = tooltip:AddRow("preview")
	preview:SetTall(100)

	local previewImg = preview:Add("DImage")
	previewImg:SetImage("data/helix/projectrevival/"..self.textureName)
end

ITEMS = {}

ITEMS.crematorposter = {
	["name"] = "Cremator Poster",
	["model"] =  "models/mosi/fallout4/props/junk/schematic.mdl",
	["description"] = "A propaganda poster depicting a cremator with some text.",
	["textureName"] = "crematorposter.jpg",
	["imgW"] = 256,
	["imgH"] = 586
}

ITEMS.redccaposter = {
	["name"] = "Red Metropolice Poster",
	["model"] =  "models/mosi/fallout4/props/junk/schematic.mdl",
	["description"] = "A red propaganda poster depicting a metrocop with some text.",
	["textureName"] = "metropolicered.jpg",
	["imgW"] = 256,
	["imgH"] = 512
}

ITEMS.blueccaposter = {
	["name"] = "Blue Metropolice Poster",
	["model"] =  "models/mosi/fallout4/props/junk/schematic.mdl",
	["description"] = "A blue propaganda poster depicting a metrocop with some text.",
	["textureName"] = "metropoliceblue.jpg",
	["imgW"] = 256,
	["imgH"] = 512
}

ITEMS.consulposter = {
	["name"] = "Consul Poster",
	["model"] =  "models/mosi/fallout4/props/junk/schematic.mdl",
	["description"] = "A propaganda poster depicting the consul with some text.",
	["textureName"] = "ConsulHead.jpg",
	["imgW"] = 256,
	["imgH"] = 512
}

ITEMS.city17buildingposter = {
	["name"] = "City 17 Building Poster",
	["model"] =  "models/mosi/fallout4/props/junk/schematic.mdl",
	["description"] = "A propaganda poster depicting a building with some text.",
	["textureName"] = "City17Building.jpg",
	["imgW"] = 256,
	["imgH"] = 512
}

ITEMS.humanscienceeyeposter = {
	["name"] = "Human Science Eye Poster",
	["model"] =  "models/mosi/fallout4/props/junk/schematic.mdl",
	["description"] = "A red propaganda poster depicting an eye and the text \"Human Science\".",
	["textureName"] = "humanscienceeye.png",
	["imgW"] = 215,
	["imgH"] = 330
}

ITEMS.humanscienceratposter = {
	["name"] = "Human Science Rat Poster",
	["model"] =  "models/mosi/fallout4/props/junk/schematic.mdl",
	["description"] = "A red propaganda poster depicting an rat and the text \"Human Science\".",
	["textureName"] = "humansciencerat.png",
	["imgW"] = 215,
	["imgH"] = 336
}

ITEMS.reportthevort = {
	["name"] = "Report the Vort Poster",
	["model"] =  "models/mosi/fallout4/props/junk/schematic.mdl",
	["description"] = "A red propaganda poster depicting a vortigaunt and some text.",
	["textureName"] = "reportthevort.png",
	["imgW"] = 384,
	["imgH"] = 511
}

ITEMS.terminatorthreeposter = {
	["name"] = "Terminator 3 Movie Poster",
	["model"] =  "models/mosi/fallout4/props/junk/schematic.mdl",
	["description"] = "A movie poster for the third Terminator movie.",
	["textureName"] = "terminator3.png",
	["imgW"] = 346,
	["imgH"] = 512
}

ITEMS.starwarstwoposter = {
	["name"] = "Attack of the Clones Movie Poster",
	["model"] =  "models/mosi/fallout4/props/junk/schematic.mdl",
	["description"] = "A movie poster for the second episode of Star Wars.",
	["textureName"] = "starwarsepisode2.png",
	["imgW"] = 342,
	["imgH"] = 512
}

ITEMS.friendsposter = {
	["name"] = "Friends Poster",
	["model"] =  "models/mosi/fallout4/props/junk/schematic.mdl",
	["description"] = "A poster for the sitcom Friends.",
	["textureName"] = "friends.png",
	["imgW"] = 343,
	["imgH"] = 512
}

ITEMS.returnofthekingposter = {
	["name"] = "Return of the King Poster",
	["model"] =  "models/mosi/fallout4/props/junk/schematic.mdl",
	["description"] = "A poster for the third and final Lord of the Rings movie.",
	["textureName"] = "returnoftheking.png",
	["imgW"] = 336,
	["imgH"] = 512
}

for k, v in pairs(ITEMS) do
	local ITEM = ix.item.Register(k, "poster", false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model
	ITEM.description = v.description
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.textureName = v.textureName
	ITEM.imgW = v.imgW
	ITEM.imgH = v.imgH
	ITEM.chance = v.chance or 0

	function ITEM:PopulateTooltip(tooltip)
		local imgW, imgH = self.imgW, self.imgH

		local preview = tooltip:AddRow("preview")
		preview:SetTall(imgH/2 + 8)
		preview:SetText("")
		local previewImg = preview:Add("DImage")
		previewImg:SetBackgroundColor(Color(30, 30, 30, 255))

		previewImg:SetImage("data/helix/projectrevival/"..self.textureName)
		previewImg:SetSize(imgW/2, imgH/2)
		previewImg:SetPos(368/2 - imgW/4, 4)
		--previewImg:Center()
		--previewImg:SetKeepAspect(true)
	end
end

-- cooked food qualities
-- 0-10: Inedible
-- 11-15: Awful
-- 16-25: Poor
-- 26-50: Decent
-- 51-70: Good
-- 71-85: Great
-- 86-100: Amazing

local consumableBase = ix.item.Register("Consumable", nil, true, nil, true)
consumableBase.name = "Consumable Base"
consumableBase.model = "models/mosi/fallout4/props/junk/schematic.mdl"
consumableBase.description = "A food item base."
consumableBase.category = "Consumable"
consumableBase.width = 1
consumableBase.height = 1
consumableBase.ingrQuality = 100
consumableBase.baseHunger = 20
consumableBase.baseThirst = 0
consumableBase.isBeverage = false
consumableBase.functions.eat = {
    name = "Eat",
    icon = "icon16/cup.png",
    OnRun = function(itemTable)
        local ply = itemTable.player

        local foodQuality = itemTable:GetData("Quality", nil) or itemTable.ingrQuality
		local baseHunger = itemTable.baseHunger

		foodQuality = ix.util.GetFoodQuality(foodQuality)
		local restoredHunger = math.max(baseHunger*foodQuality/100, baseHunger*0.2)

		ply:RestoreHunger(restoredHunger)
       return false
    end,
	OnCanRun = function(itemTable)
		return !itemTable.isBeverage
	end
}

consumableBase.functions.drink = {
    name = "Drink",
    icon = "icon16/cup.png",
    OnRun = function(itemTable)
        local ply = itemTable.player

       ply:RestoreThirst(itemTAble.baseThirst)
       return false
    end,
	OnCanRun = function(itemTable)
		return itemTable.isBeverage
	end
}

function consumableBase:PopulateTooltip(tooltip)
	if !self.isBeverage then
		if self.ingrQuality != nil then
			if LocalPlayer():GetCharacter():GetSkill("Cooking") > 25 then
				local quality = tooltip:AddRow("quality")
				quality:SetBackgroundColor(Color(149, 27, 224))
				quality:SetText(ix.util.GetFoodQuality(self:GetData("Quality", 50)).." Quality")
			end
		else
			local quality = tooltip:AddRow("quality")
			quality:SetBackgroundColor(Color(149, 27, 224))
			quality:SetText(ix.util.GetFoodQuality(self:GetData("Quality", 50)).." Quality")
		end
	end
end

/*
ITEMS = {}

ITEMS.dualies = {
	["name"] = "Dual 9mm Pistols",
	["model"] = "models/weapons/w_pistol.mdl"
}
*/

ITEMS = {}

ITEMS.uuoliveoil = {
	["name"] = "UU Brand Olive Oil",
	["description"] = "A plastic bottle of extra virgin olive oil with a Combine label stuck on its front."
} 

for k, v in pairs(ITEMS) do
	local ITEM = ix.item.Register(k, "outfit", false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model
	ITEM.description = v.description
	ITEM.category = "Consumables"
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.chance = v.chance or 0
	ITEM.isTool = v.tool or false
	ITEM.functions.Eat = {
		OnRun = function(itemTable)
			local client = itemTable.player
	
			client:SetHealth(math.min(client:Health() + 10, client:GetMaxHealth()))
	
			return true
		end
	}
end

local propBase = ix.item.Register("prop", nil, true, nil, true)
propBase.name = "Poster Base"
propBase.model = "models/props_wasteland/controlroom_chair001a.mdl"
propBase.description = "A base for placeable props."
propBase.category = "props"
propBase.width = 1
propBase.height = 1
propBase.placementModel = "models/props_wasteland/controlroom_chair001a.mdl"
propBase.functions.place = {
    name = "Place",
    icon = "icon16/picture.png",
    OnRun = function(itemTable)
        local ply = itemTable.player

        ix.placement.StartPlacing(ply, itemTable:GetID())
       return false
    end
}

ITEMS = {}

ITEMS.cmb_barricade = {
	name = "Combine Barricade",
	description = "A transparent barricade with a blue, metal frame.",
	model = "models/props_junk/cardboard_box001a.mdl",
	placementModel = "models/props_combine/combine_barricade_short01a.mdl",
	width = 2,
	height = 2,
}

ITEMS.folding_horse = {
	name = "Folding Street Horse",
	description = "A folding wooden barricade with orange and white stripes.",
	model = "models/props_wasteland/barricade001a.mdl",
	placementModel = "models/props_wasteland/barricade001a.mdl",
	width = 2,
	height = 2,
}

ITEMS.horse = {
	name = "Street Horse",
	description = "A wooden street barricade with orange and white stripes.",
	model = "models/props_wasteland/barricade002a.mdl",
	placementModel = "models/props_wasteland/barricade002a.mdl",
	width = 2,
	height = 2,
}

ITEMS.foldingchair = {
	name = "Folding Chair",
	description = "An old, tarnished folding chair with a plastic cushion.",
	model = "models/props_wasteland/controlroom_chair001a.mdl",
	placementModel = "models/props_wasteland/controlroom_chair001a.mdl",
	width = 2,
	height = 2,
}

ITEMS.woodenshelf = {
	name = "Wooden Shelf",
	description = "A large, somewhat aged shelf consisting of nothing but wood and nails",
	model = "models/props_junk/wood_crate001a.mdl",
	placementModel = "models/props/CS_militia/shelves_wood.mdl",
	width = 2,
	height = 2,
}

for uniqueID, itemTbl in pairs(ITEMS) do
	local ITEM = ix.item.Register(uniqueID, "base_prop", false, nil, true)
	for key, value in pairs(itemTbl) do
		if key != "functions" then
			ITEM[key] = value
		else
			for funcId, tbl in pairs(value) do
				ITEM.functions[funcId] = tbl
			end
		end
	end

	ITEM.functions.place = {
		name = "Place",
		icon = "icon16/picture.png",
		OnRun = function(itemTable)
			local ply = itemTable.player
	
			ix.placement.StartPlacing(ply, itemTable:GetID())
		   return false
		end
	}
end

ITEMS = {}
do
	local ITEM = ix.item.Register("pager", nil, false, nil, true)
	ITEM.name = "Pager"
	ITEM.description = "A small handheld device with a single button and no screen."
	ITEM.model = "models/illusion/eftcontainers/rfidreader.mdl"
	ITEM.width = 1
	ITEM.height = 1
	ITEM.functions.pair = {
		name = "Pair",
		icon = "icon16/transmit.png",
		OnRun = function(itemTable)
			local ply = itemTable.player

			local traceEnt = ply:GetEyeTrace().Entity
			local distance = traceEnt:GetPos():Distance(ply:GetPos())
			if IsValid(traceEnt) and traceEnt:GetClass() == "ix_bell" and distance <= 96 then
				ply:Notify("Your pager has been paired.")
				itemTable:SetData("BellID", traceEnt.bellID)
			else
				ply:Notify("You are not looking at a bell entity!")
			end 

			return false
		end
	}
end


ITEMS = {}

ITEMS["45acp_magazine"] = {
	["name"] = ".45 ACP Magazine",
	["description"] = "A magazine of 11 .45 ACP rounds. It can be safely loaded into a USP match.",
	["model"] = "models/tnb/weapons/ammo/glock.mdl",
	["ammo"] = "45_acp",
	["ammoAmount"] = 11
}

ITEMS["9mmhp_magazine"] = {
	["name"] = "9mm Hollow Point Magazine",
	["description"] = "A magazine of 11 .45 ACP rounds.",
	["model"] = "models/tnb/weapons/ammo/glock.mdl",
	["ammo"] = "9mm_hp",
	["ammoAmount"] = 11
}

ITEMS["bitchly_magazine"] = {
	["name"] = ".45 BITCHLY Magazine",
	["description"] = "A magazine of 11 .45 ACP rounds.",
	["model"] = "models/tnb/weapons/ammo/glock.mdl",
	["ammo"] = "45_acp",
	["ammoAmount"] = 11
}

ITEMS["pulseflare"] = {
	["name"] = "Dark Energy Incendiary Charge",
	["description"] = "A dark energy charge that, when fired, behaves like a flare.",
	["model"] = "models/mosi/fallout4/ammo/cryocell.mdl",
	["ammo"] = "pulseflare",
	["ammoAmount"] = 1
}




for k, v in pairs(ITEMS) do
	local ITEM = ix.item.Register(k, "base_ammo", false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model
	ITEM.description = v.description
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.chance = v.chance or 0
	ITEM.ammo = v.ammo
	ITEM.ammoAmount = v.ammoAmount
end

