ITEM.name = "Doctor's bag"
ITEM.description = "itemDoctorbagDesc"
ITEM.model = "models/fallout/clutter/health/doctorbag.mdl"
ITEM.category = "Medical"
ITEM.price = 55
ITEM.healthPoint = 75 -- Health point that the player will get
ITEM.medAttr = 10 -- How much medical attribute the character needs

ITEM:Hook("heal", function(item)
	local client = item.player
	client:EmitSound("ui/open_loot.wav")
end)

ITEM:Hook("selfheal", function(item)
	local client = item.player
	client:EmitSound("ui/open_loot.wav")
end)