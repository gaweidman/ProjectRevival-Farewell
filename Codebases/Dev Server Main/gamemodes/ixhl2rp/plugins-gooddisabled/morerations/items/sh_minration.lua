
ITEM.name = "Minimal Grade Ration"
ITEM.model = Model("models/weapons/w_packati.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A tan and brown ration packet."
ITEM.items = {"minsupps", "minfood", "water"}


ITEM.functions.Open = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local character = client:GetCharacter()

		for k, v in ipairs(itemTable.items) do
			if (v.flavors != nil) then
				if (!character:GetInventory():Add(v, 1, {
					["flavor"] = v.flavors[math.random(#v.flavors)]
				})) then
					ix.item.Spawn(v, client)
				end	
			else
				if (!character:GetInventory():Add(v)) then
					ix.item.Spawn(v, client)
				end
			end
		end

		if !character:IsCombine() then
			character:GiveMoney(ix.config.Get("rationTokens", 20) * 0.5)
		end

		client:EmitSound("ambient/fire/mtov_flame2.wav", 75, math.random(160, 180), 0.35)
	end
}