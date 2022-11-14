ATTRIBUTE.name = "Agility"
ATTRIBUTE.description = "Your ability to move with speed and dexterity."

function ATTRIBUTE:OnSetup(client, value)
	client:SetRunSpeed(ix.config.Get("runSpeed", 235) + (value * ix.config.Get("agilityMultiplier")))
end