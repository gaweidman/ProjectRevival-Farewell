
ITEM.name = "Supplements"
ITEM.model = Model("models/foodnhouseholdaaaaa/combirationb.mdl")
ITEM.description = "A white packet containing a thick paste."

ITEM.functions.Eat = {
	OnRun = function(itemTable)
		local client = itemTable.player

		client:RestoreStamina(100)
		client:SetHealth(math.Clamp(client:Health() + 20, 0, client:GetMaxHealth()))
		client:EmitSound("npc/antlion_grub/squashed.wav", 75, 150, 0.25)
	end,
	OnCanRun = function(itemTable)
		return !itemTable.player:HasBiosignal()
	end
}
