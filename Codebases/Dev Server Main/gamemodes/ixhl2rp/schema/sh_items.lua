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

ITEMS.charcoal = {
	["name"] = "Charcoal",
	["model"] = "models/gibs/manhack_gib01.mdl",
	["description"] = "A black, chalky mass. It's fairly light.",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.saltpeter = {
	["name"] = "Saltpeter",
	["model"] = "models/illusion/eftcontainers/gpgreen.mdl",
	["description"] = "A white powder with a rough feeling to it.",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.ammoniumnitrate = {
	["name"] = "Ammonium Nitrate",
	["model"] = "models/illusion/eftcontainers/gpgreen.mdl",
	["description"] = "A very coarse white powder with the appearance of many small spheres.",
	["width"] = 1,
	["height"] = 1,
}

ITEMS.refined_electronics = {
	["name"] = "Refined Electronics",
	["model"] = "models/props_lab/reciever01b.mdl",
	["description"] = "A small assorted set of electronics, all of which are fully functional.",
	["width"] = 1,
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
	["height"] = 1,
	["dictionary"] = {"watercanEmpty"}
}

ITEMS.flavoredconsulwaterempty = {
	["name"] = "Empty Flavored Consulate Water Can",
	["model"] = "models/props_lunk/popcan01a.mdl",
	["description"] = "An empty red can of Consulate water.",
	["width"] = 1,
	["height"] = 1,
	["skin"] = 1,
	["dictionary"] = {"watercanEmpty"}

}

ITEMS.sparklingconsulwaterempty = {
	["name"] = "Empty Sparkling Consulate Water Can",
	["model"] = "models/props_lunk/popcan01a.mdl",
	["description"] = "An empty red can of Consulate water.",
	["width"] = 1,
	["height"] = 1,
	["skin"] = 2,
	["dictionary"] = {"watercanEmpty"}
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

ITEMS.grenadebody = {
	name = "Grenade Body",
	model = "models/weapons/w_grenade.mdl",
	description = "A thick, cylindrical body cast from metal, no bigger than a soda can.",
	width = 1, 
	height = 1
}

ITEMS.coldpack = {
	name = "Instant Cold Pack",
	model = "models/illusion/eftcontainers/galette.mdl",
	description = "A white, snappable packet inside of a plastic brown package.",
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
	ITEM.category = v.category or "Crafting"
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.chance = v.chance or 0
	ITEM.skin = v.skin or 0 
	ITEM.dictionary = v.dictionary or {}
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
propBase.name = "Prop Base"
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

ITEMS.antiquebarstool = {
    name = "Antique Barstool",
    description = "An antique wooden bar stool, very fancy!",
    placementModel = "models/props/cs_militia/barstool01.mdl",
}

ITEMS.antiquetable = {
    name = "Antique Table",
    description = "An antique looking table, probably expensive.",
    placementModel = "models/props/de_inferno/tableantique.mdl",
}

ITEMS.barrelwood = {
    name = "Wooden Barrel",
    description = "A wooden barrel, with red stripes on it.",
    placementModel = "models/props_c17/woodbarrel001.mdl",
}

ITEMS.bedsidetable = {
    name = "Bedside Table",
    description = "A more modern looking Bedside table, made out of oak wood.",
    placementModel = "models/props_interiors/side_table_square.mdl",
}

ITEMS.blackgarbagecan = {
    name = "Black Garbage Can",
    description = "A black garbage can with a white bag inside.",
    placementModel = "models/props_interiors/trashcankitchen01.mdl",
}

ITEMS.blackleatherchair = {
    name = "Black Leather Chair",
    description = "A black leather chair, with rolling wheels.",
    placementModel = "models/props/cs_office/chair_office.mdl",
}

ITEMS.blueottoman = {
    name = "Blue Ottoman",
    description = "A small blue footrest.",
    placementModel = "models/props_interiors/ottoman01.mdl",
}

ITEMS.bluesleepingbag = {
    name = "Blue Sleeping Bag",
    description = "A sleeping bag, blue in colour, good to use for a blanket in these trying times.",
    placementModel = "models/props_equipment/sleeping_bag2.mdl",
}

ITEMS.bluesofa = {
    name = "Blue Sofa",
    description = "A round shaped blue sofa.",
    placementModel = "models/props_interiors/Furniture_chair03a.mdl",
}

ITEMS.bookshelf = {
    name = "Wooden Bookshelf",
    description = "A medium sized bookshelf made of spruce wood.",
    placementModel = "models/props_interiors/Furniture_shelf01a.mdl",
}

ITEMS.boothtable = {
    name = "Booth Table",
    description = "A table typically used in booths, in resteraunts.",
    placementModel = "models/props_downtown/booth_table.mdl",
}

ITEMS.brownsofa = {
    name = "Large Brown Sofa",
    description = "A large brown sofa, with 3 seating spots.",
    placementModel = "models/props/cs_office/sofa.mdl",
}

ITEMS.brownsofachair = {
    name = "Brown Sofa Chair",
    description = "A brown sofa chair.",
    placementModel = "models/props/cs_office/sofa_chair.mdl",
}

ITEMS.cactus = {
    name = "Potted Cactus",
    description = "A short green succulent with a pink flower.",
    placementModel = "models/props_lab/cactus.mdl",
}

ITEMS.cafateriabench = {
    name = "Cafateria Bench",
    description = "A wooden cafateria bench, the paint has started to chip.",
    placementModel = "models/props_wasteland/cafeteria_bench001a.mdl",
}

ITEMS.cafateriatable = {
    name = "Cafateria Table",
    description = "A wooden cafateria table, the paint has started to chip.",
    placementModel = "models/props_wasteland/cafeteria_table001a.mdl",
}

ITEMS.coffeetable = {
    name = "Wooden Coffee Table",
    description = "A small table close to the ground, typically stained with coffee",
    placementModel = "models/props_c17/FurnitureTable003a.mdl",
}

ITEMS.desklamp = {
    name = "Desk Lamp",
    description = "An orange desk lamp, on a movable frame.",
    placementModel = "models/props_lab/desklamp01.mdl",
}

ITEMS.desklampshade = {
    name = "Desk Lape (Shade)",
    description = "A small desk lamp, with a nondescript shade.",
    placementModel = "models/props_interiors/lamp_table02.mdl",
}

ITEMS.dresser = {
    name = "Average Dresser",
    description = "An averaged sized dresser, with two long drawers and two small ones.",
    placementModel = "models/props_c17/FurnitureDrawer001a.mdl",
}

ITEMS.endtable = {
    name = "End Table",
    description = "A Small Brown Endtable wth a single drawer",
    placementModel = "models/props_c17/FurnitureDrawer002a.mdl",
}

ITEMS.globe = {
    name = "Globe",
    description = "An old globe, probably outdated by now.",
    placementModel = "models/props_combine/breenglobe.mdl",
}

ITEMS.greenloveseat = {
    name = "Green Loveseat",
    description = "A green, two seat loveseat.",
    placementModel = "models/props_c17/FurnitureCouch002a.mdl",
}

ITEMS.greensleepingbag = {
    name = "Green Sleeping Bag",
    description = "A sleeping bag, green in colour, good to use for a blanket in these trying times.",
    placementModel = "models/props_equipment/sleeping_bag1.mdl",
}

ITEMS.kitchenshelf = {
    name = "Kitchen Shelf",
    description = "A tall blue shelf, for storing kitchen supplies like pots and pans.",
    placementModel = "models/props_wasteland/kitchen_shelf001a.mdl",
}

ITEMS.kitchenshelfwood = {
    name = "Wooden Kitchen Drawers",
    description = "A shelf typically found in kitchens that hosts drawers, and shelves with glass covers.",
    placementModel = "models/props_interiors/furniture_cabinetdrawer02a.mdl",
}

ITEMS.lunchroom = {
    name = "Lunchroom Table",
    description = "A table typically used in offices for lunch breaks.",
    placementModel = "models/props_interiors/table_cafeteria.mdl",
}

ITEMS.makeupdesk = {
    name = "Vanity Desk",
    description = "A wooden makeup desk. The mirror is missing.",
    placementModel = "models/props_interiors/Furniture_Vanity01a.mdl",
}

ITEMS.metalchair = {
    name = "Blue Sofa",
    description = "A rounded blue sofa.",
    placementModel = "models/props_interiors/Furniture_chair03a.mdl",
}

ITEMS.metaldesk = {
    name = "Metal Desk",
    description = "A long metal desk, lacking any drawers",
    placementModel = "models/props_wasteland/controlroom_desk001a.mdl",
}

ITEMS.metaldeskdrawers = {
    name = "Metal Desk with Drawers",
    description = "A long metal desk, with two drawers.",
    placementModel = "models/props_wasteland/controlroom_desk001b.mdl",
}

ITEMS.metalmesh = {
    name = "Metal and Mesh Chair",
    description = "A metal and mesh chair, with rolling wheels.",
    placementModel = "models/U4Lab/chair_office_a.mdl",
}

ITEMS.metalshelves = {
    name = "Metal Shelves",
    description = "Shelves found typically in storage units sturdy, with a crossed beamed back.",
    placementModel = "models/props/cs_office/Shelves_metal.mdl",
}

ITEMS.modernbluesofa = {
    name = "Modern Blue Sofa",
    description = "A clean long blue sofa.",
    placementModel = "models/props_interiors/sofa01.mdl",
}

ITEMS.modernbluesofachair = {
    name = "Modern Blue Sofa Chair",
    description = "A clean blue sofa chair.",
    placementModel = "mmodels/props_interiors/sofa_chair02.mdl",
}

ITEMS.oakcoffeetable = {
    name = "Oak Coffee Table",
    description = "A small able, with no coffee stains.",
    placementModel = "models/props/cs_office/table_coffee.mdl",
}

ITEMS.oakwoodchair = {
    name = "Oak Wood Chair",
    description = "A entirely wooden chair, looks freshly made.",
    placementModel = "models/props_interiors/chair01.mdl",
}

ITEMS.oldbrownsofa = {
    name = "Old Brown Sofa",
    description = "An old dingy couch, probably black mold in there.",
    placementModel = "models/props/cs_militia/couch.mdl",
}

ITEMS.ovaloakwoodtable = {
    name = "Oval Oak Wood Table",
    description = "A oval wooden table, freshly made.",
    placementModel = "models/props_interiors/dinning_table_oval.mdl",
}

ITEMS.partsbin = {
    name = "Parts Bin",
    description = "A metal container, with many small drawers, meant for storing nails, screws and other workshop objects.",
    placementModel = "models/props_lab/partsbin01.mdl",
}

ITEMS.patiochair = {
    name = "Patio Chair",
    description = "A chair with thatch for the back rest, and butt rest.",
    placementModel = "models/props/de_tides/patio_chair.mdl",
}

ITEMS.plasticchair = {
    name = "Plastic Blue Chair",
    description = "A plastic blue chair.",
    placementModel = "models/props_c17/chair02a.mdl",
}

ITEMS.plasticporchchair = {
    name = "Plastic Outside Chair",
    description = "A chair typically found outside. Usually on someones porch.",
    placementModel = "models/props_urban/plastic_chair001.mdl",
}

ITEMS.porchtable = {
    name = "Porch Table",
    description = "A small wooden table, found on most peoples porches, storing a radio or plants.",
    placementModel = "models/props/CS_militia/wood_table.mdl",
}

ITEMS.pottedfern = {
    name = "Potted Fern",
    description = "A Potted Fern Plant, livens up the place.",
    placementModel = "models/props/cs_office/plant01.mdl",
}

ITEMS.redloveseat = {
    name = "Red Loveseat",
    description = "A red, two seat loveseat.",
    placementModel = "models/props_c17/FurnitureCouch001a.mdl",
}

ITEMS.rollingstool = {
    name = "Rolling Stool",
    description = "A Black Stool, with a metal underside, can roll.",
    placementModel = "models/props_c17/chair_stool01a.mdl",
}

ITEMS.roundchair = {
    name = "Round Wooden Chair",
    description = "A rounded wooden chair.",
    placementModel = "models/props_interiors/Furniture_chair01a.mdl",
}

ITEMS.roundoakwoodtable = {
    name = "Round Oak Wood Table",
    description = "A round wooden table, freshly made.",
    placementModel = "models/props_interiors/dining_table_round.mdl",
}

ITEMS.roundtable = {
    name = "Round Kitchen Table",
    description = "A rounded Kitchen Table made out of wood",
    placementModel = "models/props_c17/FurnitureTable001a.mdl",
}

ITEMS.sawhorse = {
    name = "Saw Horse",
    description = "A small wooden object, used for sawing things.",
    placementModel = "models/props/CS_militia/sawhorse.mdl",
}

ITEMS.smallbench = {
    name = "Small Bench",
    description = "A small wooden bench, no back support.",
    placementModel = "models/props/CS_militia/wood_bench.mdl",
}

ITEMS.smalltrash = {
    name = "Small Trash Can",
    description = "A short black trash can.",
    placementModel = "models/props/cs_office/trash_can_p.mdl",
}

ITEMS.squaretable = {
    name = "Square Kitchen Table",
    description = "A squared Kitchen Table made out of wood.",
    placementModel = "models/props_c17/FurnitureTable002a.mdl",
}

ITEMS.standinglamp = {
    name = "Standing Lamp",
    description = "A tall standing lamp, with a pointed shade.",
    placementModel = "models/env/lighting/lamp_trumpet/lamp_trumpet_tall.mdl",
}

ITEMS.talldresser = {
    name = "Tall Dresser",
    description = "A thing but tall Dresser, with 10 drawers.",
    placementModel = "models/props_c17/FurnitureDrawer003a.mdl",
}

ITEMS.talllamp = {
    name = "Tall Lamp",
    description = "A tall lamp, with a floral pattern on the shade.",
    placementModel = "models/props_interiors/Furniture_Lamp01a.mdl",
}

ITEMS.tanchair = {
    name = "Tan Chair",
    description = "A large tan chair.",
    placementModel = "models/props_interiors/Furniture_Couch02a.mdl",
}

ITEMS.toothbrushcup = {
    name = "Toothbrush Cup",
    description = "A cup with toothbrushes and toothpaste in it.",
    placementModel = "models/props/CS_militia/toothbrushset01.mdl",
}

ITEMS.trayholderlua = {
    name = "Tray Holder",
    description = "A tall storage holder, for baked goods on trays.",
    placementModel = "models/props_wasteland/kitchen_shelf002a.mdl",
}

ITEMS.wardrobe = {
    name = "Wardrobe",
    description = "A tall Wardrobe, used for hanging clothing.",
    placementModel = "models/props_c17/FurnitureDresser001a.mdl",
}

ITEMS.whitemetaldesk = {
    name = "White Metal Desk",
    description = "A white desk, with four drawers on it.",
    placementModel = "models/props_office/desk_01.mdl",
}

ITEMS.whiteworkshoptable = {
    name = "White Workshop Table",
    description = "A table most people have in their garage, or workshops, very sturdy.",
    placementModel = "models/props/cs_militia/table_kitchen.mdl",
}

ITEMS.wideblue = {
    name = "Wide Blue Chair",
    description = "A wide blue chair, with metal mesh for support.",
    placementModel = "models/props_interiors/chair_cafeteria.mdl",
}

ITEMS.woodenbookshelf = {
    name = "Large Wooden Shelf",
    description = "A large wooden shelf, used for storing books, or nicknacks on.",
    placementModel = "models/props_c17/shelfunit01a.mdl",
}

ITEMS.woodenchair = {
    name = "Wooden Chair",
    description = "A average sized wooden chair",
    placementModel = "models/props_c17/FurnitureChair001a.mdl",
}

ITEMS.woodendesk = {
    name = "Wooden Desk",
    description = "A average sized wooden desk, with 5 drawers on it",
    placementModel = "models/props_interiors/Furniture_Desk01a.mdl",
}

ITEMS.woodendresserdrawer = {
    name = "Wooden Dresser with Shelves",
    description = "A wooden dresser with many shelves on it, for storage.",
    placementModel = "models/props_interiors/furniture_cabinetdrawer01a.mdl",
}

ITEMS.workshoptable = {
    name = "Workshop Table",
    description = "A table most people have in their garage, or workshops, insanely sturdy.",
    placementModel = "models/props/cs_militia/table_shed.mdl",
}

for uniqueID, itemTbl in pairs(ITEMS) do
	local ITEM = ix.item.Register(uniqueID, "prop", false, nil, true)
	for key, value in pairs(itemTbl) do
		if key != "functions" then
			ITEM[key] = value
		else
			for funcId, tbl in pairs(value) do
				ITEM.functions[funcId] = tbl
			end
		end
	end

	if ITEM.model == nil then
		ITEM.model = "models/props_junk/wood_crate001a.mdl"
	end

	if ITEM.width == 1 or ITEM.width == nil then
		ITEM.width = 2
		ITEM.height = 2
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