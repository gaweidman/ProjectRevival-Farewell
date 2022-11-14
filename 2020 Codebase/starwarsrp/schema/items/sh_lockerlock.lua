
ITEM.name = "Locker Lockchip"
ITEM.description = "A metal chip to be inserted in a locker to give it a passcode."
ITEM.price = 0
ITEM.model = "models/gibs/metal_gib4.mdl"
ITEM.functions.Use = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

        print(target:GetModel())
		if (IsValid(target) and target:GetClass() == "ix_container" and target:GetModel() == "models/lt_c/sci_fi/ground_locker_small.mdl") then
			if (SERVER) then

				if target:GetLocked() then
					itemTable.player:Notify("That container is already locked!")
					return false
				end

				local passcode = tostring(math.random(0, 9))..tostring(math.random(0, 9))..tostring(math.random(0, 9))..tostring(math.random(0, 9))..tostring(math.random(0, 9))..tostring(math.random(0, 9))

				target.Sessions = {}
				
                client:NotifyLocalized("containerPassword", passcode)
                
                target.password = passcode
                target:SetLocked(true)
				return true

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
