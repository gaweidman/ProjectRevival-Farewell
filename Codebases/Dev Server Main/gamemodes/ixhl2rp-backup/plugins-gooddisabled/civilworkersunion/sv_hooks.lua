
function PLUGIN:LoadData()
	self:LoadUnionLocks()
end

function PLUGIN:SaveData()
	self:SaveUnionLocks()
end

function PLUGIN:PlayerUse(client, entity)
	if (client:HasBiosignal() or client:GetCharacter():GetInventory():HasItem("uid") or IsValid(entity.ixUnionLock) and entity.ixUnionLock:HasKey(client)) then
		if (entity:IsDoor() and IsValid(entity.ixUnionLock) and client:KeyDown(IN_SPEED)) then
		entity.ixUnionLock:Toggle(client)
		return false
		end
	end
end