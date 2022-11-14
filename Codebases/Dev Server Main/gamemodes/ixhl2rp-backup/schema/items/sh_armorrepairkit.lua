ITEM.name = "Armor Repair Kit"
ITEM.description = "A package of armor pieces, used to patch up damaged armor."
ITEM.category = "Equipment"
ITEM.model = "models/illusion/eftcontainers/armorrepair.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.ApplySelf = {
	name = "Apply to Self",
	sound = "items/ammopickup.wav",
	icon = "icon16/user.png",
	OnRun = function(itemTable)
		local client = itemTable.player
		local classIndex = client:GetCharacter():GetClass()
        local class = ix.class.Get(classIndex)
        
        if (class.defaultArmor == nil) then
            client:Notify("You don't have anything to repair!")

            -- This log may be too verbose.
            --ix.log.Add(client, "FLAG_WARNING", " tried to use an "..itemTable.name.." on themself, but failed because they had nothing to repair.")

            return false
        elseif (class.defaultArmor == client:Armor()) then
            client:Notify("Your armor doesn't need to be repaired!")
            return false
        else
            local oldArmor = client:Armor()
            local amountRestored = math.Clamp(client:Armor() + 50, 0, class.defaultArmor) - client:Armor()
            client:SetArmor(math.Clamp(client:Armor() + 50, 0, class.defaultArmor))

            -- This log may be too verbose.
		    --ix.log.Add(client, "FLAG_WARNING", " has used an "..itemTable.name.." on themself, restoring ".. amountRestored .." armor and leaving them at "..client:Armor().." armor.")
		    
		    return
        end
	end
}

ITEM.functions.ApplyOther = {
	name = "Apply to Other",
	sound = "items/ammopickup.wav",
	icon = "icon16/group.png",
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if !target:IsPlayer() then
			client:Notify("You cannot apply an Armor Repair Kit on this!")
			return false
		elseif target:IsPlayer() then
            local classIndex = target:GetCharacter():GetClass()
            local class = ix.class.Get(classIndex)

            if (class.defaultArmor == nil) then
                client:Notify("This person has nothing to repair!")

                -- This log may be too verbose.
                --ix.log.Add(client, "FLAG_WARNING", " tried to use an "..itemTable.name.." on "..target:Nick()..", but failed because they had nothing to repair.")

                return false
            elseif (class.defaultArmor == target:Armor()) then
                client:Notify("This person's armor doesn't need to be repaired!")
                return false
            else
                local oldArmor = target:Armor()
                local amountRestored = math.Clamp(target:Armor() + 50, 0, class.defaultArmor) - target:Armor()
                target:SetArmor(math.Clamp(target:Armor() + 50, 0, class.defaultArmor))
                client:DoAnimationEvent(ACT_GMOD_GESTURE_ITEM_GIVE)

                -- This log may be too verbose.
                --ix.log.Add(client, "FLAG_WARNING", " has used an "..itemTable.name.." on "..target:Nick()..", restoring ".. amountRestored .." armor and leaving them at "..target:Armor().." armor.")

                return
            end
		end
	end
}