ITEM.name = "Super stimpak"
ITEM.description = "itemSuperStimpakDesc"
ITEM.model = "models/fallout_4/props/superstimpak.mdl"
ITEM.category = "Medical"
ITEM.price = 150
ITEM.healthPoint = 60 -- Health point that the player will get
ITEM.medAttr = 0 -- How much medical attribute the character needs

ITEM:Hook("heal", function(item)
	local client = item.player
	client:EmitSound("ui/stim.wav")
end)

ITEM:Hook("selfheal", function(item)
	local client = item.player
	client:EmitSound("ui/stim.wav")
end)