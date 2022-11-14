local bands = { --taka tablica, żeby nie zapierdalać po tabelach itemku
	["brown"] = {Color(102, 51, 51),"Wearing a brown loyalist armband."},
	["red"] = {Color(192, 57, 43),"Wearing a red loyalist armband."},
	["green"] = {Color(39, 174, 96),"Wearing a green loyalist armband."},
	["blue"] = {Color(41, 128, 185),"Wearing a blue loyalist armband."},
	["white"] = {Color(221, 221, 221),"Wearing a white loyalist armband."},
	["gold"] = {Color(241, 196, 15),"Wearing a gold loyalist armband."},
	["yellow"] = {Color(192, 192, 43),"Wearing a yellow loyalist armband."},
	["violet"] = {Color(142, 68, 173),"Wearing a purple loyalist armband."}
}

function PLUGIN:PopulateCharacterInfo(client, character, tooltip)
	local band = client:GetNW2String("band",false) --string z typem opaski, czyli można rzec, że kolorem
	if band then --jako, że po zdjęciu banda NWString jest nilem to można zajebać takiego checka
		local panel = tooltip:AddRowAfter("name", "band")
		panel:SetBackgroundColor(bands[band][1]) 
		panel:SetText(bands[band][2])
		panel:SizeToContents()
    end
end	