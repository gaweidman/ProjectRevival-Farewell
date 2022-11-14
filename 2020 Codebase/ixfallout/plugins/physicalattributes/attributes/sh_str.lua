ATTRIBUTE.name = "Strength"
ATTRIBUTE.description = "Your ability to carry weight and manipulate heavy objects."

function ATTRIBUTE:OnSetup(client, value)
	client:SetJumpPower(ix.config.Get("jumpPower", 200) + (value * ix.config.Get("strengthMultiplier")))
end