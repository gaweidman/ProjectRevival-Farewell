ITEM.name = "Frag grenade"
ITEM.description = "itemFragGrenadeDesc"
ITEM.class = "weapon_grenadefrag"
ITEM.category = "Grenade"
ITEM.model = "models/halokiller38/fallout/weapons/explosives/fraggrenade.mdl"
ITEM.width = 1
ITEM.height = 1
-- ITEM.price = 150
ITEM.price = 25
ITEM.exRender = true
ITEM.functions.Ready = {
	tip = "equipTip",
	icon = "icon16/add.png",
	sound = "items/ammo_pickup.wav",
	OnRun = function(item)
		item.player:Give(item.class)
	end
}