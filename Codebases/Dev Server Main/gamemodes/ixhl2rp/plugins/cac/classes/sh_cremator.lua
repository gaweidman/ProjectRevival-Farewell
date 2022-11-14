CLASS.name = "Cremator"
CLASS.faction = FACTION_CAC
CLASS.isDefault = false
CLASS.weapons = {"weapon_vfirethrower", "ix_biosigstunstick"}

function CLASS:OnSet(client)
	local character = client:GetCharacter()

	if (character) then
		character:SetName("CAC.C17-CRM." .. Schema:ZeroNumber(math.random(1, 99999), 5), true)
		character:SetModel("models/cdpmator.mdl")
	end

	client:SetMaxHealth(75)
	client:SetHealth(75)
	client:SetArmor(0)
	client:SetWalkSpeed(91)
    client:SetRunSpeed(104)
	client:SetBloodColor(DONT_BLEED)
	client:SetLadderClimbSpeed(0)
	client:EmitSound("npc/cremator/amb_loop.wav", 70, 100, 0.3)
	
end

CLASS_CREMATOR = CLASS.index
