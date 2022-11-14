ITEM.name = "Health Base"
ITEM.model = "models/items/healthkit.mdl"
ITEM.description = "A base for medical items that allow you to heal yourself or others."
ITEM.category = "Medical"
ITEM.heal = 1 -- The amount the item heals.

ITEM.functions.ApplySelf = {
	name = "Apply to Self",
	sound = "items/medshot4.wav",
	icon = "icon16/user.png",
	OnRun = function(itemTable)
		local client = itemTable.player
		client:SetHealth(math.Clamp(client:Health() + itemTable.heal, 0, 100))
		--ix.log.Add(client, "FLAG_WARNING", " has used a "..itemTable.name..", restoring 50 HP, leaving them at "..client:Health().."HP.")
		-- ^ This log may be too verbose.
		return
	end
}

ITEM.functions.ApplyOther = {
	name = "Apply to Other",
	sound = "items/medshot4.wav",
	icon = "icon16/group.png",
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if !target:IsPlayer() then
			client:Notify("You cannot apply a medkit to this!")
			return false
		else
			target:SetHealth(math.min(target:Health() + itemTable.heal, target:GetMaxHealth()))
			--ix.log.Add(client, "FLAG_WARNING", " has used a "..itemTable.name.." on "..target:Nick()..", restoring 50 HP, leaving them at "..target:Health().."HP.")
			-- ^ This log may be too verbose, moreso than in the other function.
			client:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_GIVE)
			return
		end
	end
}
