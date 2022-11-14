PLUGIN.name = "Advertising"
PLUGIN.author = "AngryBaldMan, Frosty"
PLUGIN.description = "Adds an advert command."

ix.lang.AddTable("english", {
	adverteseSent = "%s has been deducted from your account for advertising.",
	advertiseMoneyLow = "You lack sufficient funds(at least %s) to advertise.",
})
ix.lang.AddTable("korean", {
	adverteseSent = "광고 비용으로 %s을(를) 지출했습니다.",
	advertiseMoneyLow = "광고를 하기 위해 필요한 최소 자금(%s)이 없습니다.",
})

ix.chat.Register("Advert", {
	CanSay =  function(self, speaker, text)
		if speaker:GetCharacter() and speaker:GetCharacter():HasMoney(100) then
				speaker:GetCharacter():TakeMoney(100)
				speaker:NotifyLocalized("adverteseSent", ix.currency.Get(100))
			return true
		else 
			speaker:NotifyLocalized("advertiseMoneyLow", ix.currency.Get(100))
			return false 
		end
	end,
	OnChatAdd = function(self, speaker, text)
		chat.AddText(Color(255, 94, 0), "[AD] ", Color(166, 166, 166), text)
	end,
	prefix = {"/Advertisement", "/Advert", "/Ad"},
	noSpaceAfter = true
})