
ITEM.name = "NCR dogtag"
ITEM.model = "models/gibs/metal_gib4.mdl"
ITEM.description = "itemNCRDogtagDesc"
ITEM.price = 1

ITEM.functions.read = {
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()

		client:NotifyLocalized("dogtagRead", item:GetData("name", "nobody"), item:GetData("id", "00000"))

		return false
	end
}

ITEM.functions.set = {
	OnRun = function(item)
		local client = item.player
		local character = client:GetCharacter()

		if (client:Team() == FACTION_NCR or client:IsAdmin()) then
			item:SetData("name", character:GetName())
			item:SetData("id", Schema:ZeroNumber(math.random(1, 99999), 5))
			client:NotifyLocalized("dogtagSet", item:GetData("name", "nobody"), item:GetData("id", "00000"))
		else
			client:NotifyLocalized("notNCR")
		end

		return false
	end
}