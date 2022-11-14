CLASS.name = "Stalker"
CLASS.faction = FACTION_CAC
CLASS.isDefault = false

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetName("CAC.C17-STK." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
		character:SetModel("models/stalker.mdl")
	end
end

CLASS_STK = CLASS.index
