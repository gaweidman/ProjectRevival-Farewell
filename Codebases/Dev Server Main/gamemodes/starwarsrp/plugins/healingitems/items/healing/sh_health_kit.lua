
ITEM.name = "Health Kit"
ITEM.model = Model("models/items/healthkit.mdl")
ITEM.description = "A white packet filled with medication."
ITEM.category = "Medical"
ITEM.heal = 50

ITEM.functions.ApplySelf = {
	name = "Apply to Self",
	sound = "items/medshot4.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		client:AnimRestartGesture( GESTURE_SLOT_GRENADE, ACT_GMOD_GESTURE_ITEM_THROW, true )

		client:SetHealth(math.min(client:Health() + 50, client:GetMaxHealth()))
	end
}

ITEM.functions.ApplyOther = {
	name = "Apply to Other",
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if !target:IsPlayer() then
			client:Notice("You cannot apply a medkit to this!")
			return false
		else
			target:SetHealth(math.min(target:Health() + 50, target:GetMaxHealth()))
			return
		end
	end
}
