
ITEM.name = "Brotherhood of Steel holotag"
ITEM.model = "models/gibs/metal_gib4.mdl"
ITEM.description = "itemBOSHolotagDesc"
ITEM.price = 1

ITEM.functions.Read = {
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()

		client:NotifyLocalized("holotagRead", item:GetData("name", "nobody"), item:GetData("id", "00000"))

		return false
	end
}

ITEM.functions.Set = {
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()

		if (client:Team() == FACTION_BOS or client:IsAdmin()) then
			item:SetData("name", character:GetName())
			item:SetData("id", Schema:ZeroNumber(math.random(1, 99999), 5))
			client:NotifyLocalized("holotagSet", item:GetData("name", "nobody"), item:GetData("id", "00000"))
		else
			client:NotifyLocalized("notBOS")
		end

		return false
	end
}