
function Schema:PopulateCharacterInfo(client, character, tooltip)
	if (client:IsRestricted()) then
		local panel = tooltip:AddRowAfter("name", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText(L("tiedUp"))
		panel:SizeToContents()
	elseif (client:GetNetVar("tying")) then
		local panel = tooltip:AddRowAfter("name", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText(L("beingTied"))
		panel:SizeToContents()
	elseif (client:GetNetVar("untying")) then
		local panel = tooltip:AddRowAfter("name", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText(L("beingUntied"))
		panel:SizeToContents()
	end
end

function Schema:FinishChat()
	netstream.Start("PlayerFinishChat")
end

function Schema:CanPlayerJoinClass(client, class, info)
	return false
end

function Schema:ShouldDrawCrosshair()
	local client = LocalPlayer()
	local weapon = client:GetActiveWeapon()
	
	if (weapon and weapon:IsValid()) then
		local class = weapon:GetClass()
		
		if (class:find("ix_") or class:find("weapon_physgun") or class:find("gmod_tool")) then
			return true
		elseif (!client:IsWepRaised()) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function Schema:BuildBusinessMenu(panel)
	local client = LocalPlayer()

	return client:IsAdmin() or client:GetCharacter():HasFlags("b")
end

function Schema:ContextMenuOpen()
	local client = LocalPlayer()

	if (client:IsAdmin() or client:GetCharacter():HasFlags("x")) then
		return true
	else
		return false
	end
end


netstream.Hook("PlaySound", function(sound)
	surface.PlaySound(sound)
end)

netstream.Hook("Frequency", function(oldFrequency)
	Derma_StringRequest("Frequency", "What would you like to set the frequency to?", oldFrequency, function(text)
		ix.command.Send("SetFreq", text)
	end)
end)