
ITEM.name = "Priority Grade Ration"
ITEM.model = Model("models/weapons/w_packatp.mdl")
ITEM.description = "A shrink-wrapped packet containing some food and money."
ITEM.items = {"prifood", "prisupps", "water_sparkling", "citizenfilter"}

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
			character:GiveMoney(ix.config.Get("rationTokens", 20) * 3)
		end
		client:EmitSound("ambient/fire/mtov_flame2.wav", 75, math.random(160, 180), 0.35)
	end
}