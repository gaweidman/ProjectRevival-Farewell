ITEM.name = "Stimpak"
ITEM.description = "itemStimpakDesc"
ITEM.model = "models/mosi/fallout4/props/aid/stimpak.mdl"
ITEM.category = "Medical"
ITEM.price = 75
ITEM.healthPoint = 30 -- Health point that the player will get
ITEM.medAttr = 0 -- How much medical attribute the character needs

ITEM:Hook("heal", function(item)
	local client = item.player
	client:EmitSound("ui/stim.wav")
end)

ITEM:Hook("selfheal", function(item)
	local client = item.player
	client:EmitSound("ui/stim.wav")
end)