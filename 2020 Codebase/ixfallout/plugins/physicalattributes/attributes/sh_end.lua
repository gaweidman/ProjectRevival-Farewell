ATTRIBUTE.name = "Endurance"
ATTRIBUTE.description = "Your body's ability to endure trauma and remain healthy."

function ATTRIBUTE:OnSetup(client, value)
	client:SetMaxHealth(client:GetMaxHealth() + (value * ix.config.Get("enduranceMultiplier")))
end