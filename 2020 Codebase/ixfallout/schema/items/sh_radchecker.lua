
ITEM.name = "Radiation checker"
ITEM.description = "itemRadcheckerDesc"
ITEM.price = 150
ITEM.model = "models/gibs/shield_scanner_gib1.mdl"

ITEM.functions.Check = {
	OnRun = function(itemTable)
		local client = itemTable.player
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer() and target:GetCharacter()) then
			local radiation = target:GetRadiation()
			
			client:EmitSound("tools/ifm/beep.wav")
			-- client:ConCommand("say /me 방사능 수치 측정기로 "..target:GetName().."의 방사능 수치를 측정합니다.") 
			client:NotifyLocalized("radAmountChecked", radiation)
			target:NotifyLocalized("radChecked", client:GetName())
		else
			client:NotifyLocalized("plyNotValid")
		end

		return false
	end
}

ITEM.functions.Self = {
	OnRun = function(itemTable)
		local client = itemTable.player

		if (IsValid(client) and client:IsPlayer() and client:GetCharacter()) then
			local radiation = client:GetRadiation()
			
			client:EmitSound("tools/ifm/beep.wav")
			-- client:ConCommand("say /me 방사능 수치 측정기로 자신의 방사능 수치를 측정합니다.") 
			client:NotifyLocalized("radCheckedSelf", radiation)
		else
			client:NotifyLocalized("plyNotValid")
		end

		return false
	end
}