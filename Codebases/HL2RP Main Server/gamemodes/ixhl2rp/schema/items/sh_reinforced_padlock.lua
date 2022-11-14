
ITEM.name = "Reinforced Padlock"
ITEM.description = "A metal padlock, operated with a 1-59 dial."
ITEM.price = 0
ITEM.model = "models/props_wasteland/prison_padlock001a.mdl"
ITEM.functions.Use = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:GetClass() == "ix_container") then

			if (SERVER) then

				if target:GetLocked() then
					itemTable.player:Notify("That container is already locked!")
					return false
				end

				local passcode = tostring(math.random(1, 59))..tostring(math.random(1, 59))..tostring(math.random(1, 59))
				local oldName = target:GetDisplayName()

				target.Sessions = {}
				
				target:SetDisplayName("Reinforced Padlocked "..oldName)
				target:SetLocked(true)
				client:NotifyLocalized("containerPassword", passcode)
				target.password = passcode
				itemTable:Remove()

			end
	
		else
			itemTable.player:Notify("That's not a valid container!")
			return false
		end

		return false
	end,
	OnCanRun = function(itemTable)
		return !IsValid(itemTable.entity) or itemTable.bBeingUsed
	end
}

function ITEM:CanTransfer(inventory, newInventory)
	return !self.bBeingUsed
end
