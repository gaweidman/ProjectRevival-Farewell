-- This hook returns whether character is recognised or not.
function SCHEMA:IsCharRecognised(char, id)
	local character = nut.char.loaded[id]
	local client = character:getPlayer()
	
	if (client and character) then
		local faction = nut.faction.indices[client:Team()]

		if (faction and faction.isPublic) then
			return true
		end
	end
end

-- Restrict Business.
function SCHEMA:CanPlayerUseBusiness(client, id)
	local item = nut.item.list[id]
	local char = client:getChar()

	if (char) then
		local class = nut.class.list[char:getClass()]

		if (class and class.business and class.business[id]) then
			return true
		end
	end

	return (false)
end

-- No.
function SCHEMA:CanDrive()
	return false
end