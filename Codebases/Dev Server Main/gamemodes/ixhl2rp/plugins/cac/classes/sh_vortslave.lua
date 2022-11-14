CLASS.name = "Vortigaunt Slave"
CLASS.faction = FACTION_CAC
CLASS.isDefault = false
CLASS.weapons = {"weapon_broom"}

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetName("CAC.C17-VORTIPODE." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
		character:SetModel("models/vortigaunt_slave.mdl")
	end
end

CLASS_VORTSLAVE = CLASS.index
