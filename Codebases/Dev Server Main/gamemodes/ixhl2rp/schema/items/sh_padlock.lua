
ITEM.name = "Padlock"
ITEM.description = "A metal padlock, operated with a 1-59 dial. It can be shot open."
ITEM.price = 0
ITEM.model = "models/props_wasteland/prison_padlock001a.mdl"
ITEM.functions.Use = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local tr = util.TraceLine(data)
		local target = tr.Entity

		if (IsValid(target) and target:GetClass() == "ix_container") then

			if (SERVER) then

				if target:GetLocked() then
					itemTable.player:Notify("That container is already locked!")
					return false
				end

				local passcode = tostring(math.random(1, 59))..tostring(math.random(1, 59))..tostring(math.random(1, 59))
				local oldName = target:GetDisplayName()

				target.Sessions = {}
				
				target:SetDisplayName("Padlocked "..oldName)
				target:SetLocked(true)
				client:NotifyLocalized("containerPassword", passcode)
				target.password = passcode
				itemTable:Remove()

			end
	
		elseif  IsValid(target) and target:IsDoor() and target:MapCreationID() != -1 then
			
			client:SetVar("SettingDoorLock", target:MapCreationID())
			local lock = ents.Create("ix_padlock")
			local position, angles = lock:GetLockPosition(target, tr.HitNormal:Angle())
			lock:SetPos(target:GetPos())
			lock:SetDoor(target, position, angles)
			lock:Spawn()
			lock:Activate()

			print("lockvalid", lock, IsValid(lock))
			

			net.Start("ixPadlockCode")
				net.WriteBool(true)
				net.WriteInt(lock:EntIndex(), 32)
				net.WriteBool(false)
			net.Send(client)

			return true

		else
			itemTable.player:Notify("That's not a valid target!")
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
