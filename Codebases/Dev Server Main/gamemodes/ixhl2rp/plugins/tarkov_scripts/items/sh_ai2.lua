ITEM.name = "AI-2 Medikit"
ITEM.model = Model("models/illusion/eftcontainers/ai2.mdl")
ITEM.description = "The AI-2 medikit was developed as a standard service first aid kit for various defence and law enforcement agencies and civil defense forces of USSR. In case of all-out conflict with the use of weapons of mass destruction it should have been distributed to the population of the affected and surrounding areas."
ITEM.category = "Medical"

ITEM.functions.Apply = {
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:SetHealth(math.min(client:Health() + 40, client:GetMaxHealth()))
	end
}
