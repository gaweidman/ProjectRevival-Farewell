ITEM.name = "Army Bandage"
ITEM.model = Model("models/illusion/eftcontainers/armybandage.mdl")
ITEM.description = "A pre-war, Army-issue gauze bandage designed to slow the flow of blood from gunshot wounds, abrasions and other injuries taken in the field."
ITEM.category = "Medical"
ITEM.heal = 20

ITEM.functions.Apply = {
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 20, 100))
	end
}