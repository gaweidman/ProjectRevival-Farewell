local PLUGIN = PLUGIN

function PLUGIN:CharacterVarChanged(character, key, oldValue, value)
	local client = character:GetPlayer()
	if (key == "rank") then
		local classTable = ix.class.Get(client:GetCharacter():GetClass())

		if (classTable.OnRankChanged) then
			classTable:OnRankChanged(client, oldValue, value)
		end
	end
end
