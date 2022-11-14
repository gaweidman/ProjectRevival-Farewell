local PLUGIN = PLUGIN
PLUGIN.name = "IC Language"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "Now your character is able to say other language!"
PLUGIN.showOriginal = false
PLUGIN.originalLanguage = "en"
PLUGIN.langs = {
	["kor"] = "ko",
	["jap"] = "ja",
	["ger"] = "de",
	["vet"] = "vi",
	["rus"] = "ru",
	["fre"] = "fr",
}

local r, g, b = 114, 175, 237
for k, v in pairs(PLUGIN.langs) do
	nut.chat.Register(k, {
		canHear = nut.config.chatRange,
		onChat = function(speaker, text)
			local ori = text
			text = string.Replace(text, " ", "%20") // Yes
			http.Fetch("http://translate.google.com/translate_a/t?client=p&sl=" .. PLUGIN.originalLanguage .. "&tl=" .. v .. "&sc=2&ie=UTF-8&oe=UTF-8&uptl=jp&alttl=de&oc=1&otf=1&ssel=0&tsel=0&q=" .. text,
			function(resp, len, headers)
				local jsn = util.JSONToTable(resp)
				local ts = {}
				for k, v in pairs(jsn.sentences) do
					table.insert(ts, v.trans)
				end
				text = table.concat( ts )
				if (PLUGIN.showOriginal) then
					text = text .. " (" .. ori .. ")"
				end
				chat.AddText(Color(r, g, b), hook.Run("GetPlayerName", speaker, "ic", text)..": "..text)	
			end,
			function(err)
				print(err)
			end)

		end,
		prefix = "/"..k,
		font = "nut_ChatFontAction"
	})
end