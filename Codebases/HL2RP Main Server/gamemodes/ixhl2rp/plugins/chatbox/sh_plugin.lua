
local PLUGIN = PLUGIN

PLUGIN.name = "Chatbox"
PLUGIN.author = "`impulse"
PLUGIN.description = "Replaces the chatbox to enable customization, autocomplete, and useful info."

function PLUGIN:LoadFonts()
	self:LoadChatFonts(ix.option.Get("useAltChatFont", false))
end

function PLUGIN:LoadChatFonts(altFont)
	print("altFont", altFont)

	print("plugin reloading the fonts")

	surface.CreateFont("prChatFont", {
		font = altFont and "Roboto" or "Khand Regular",
		size =  altFont and (math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1)) or math.max(ScreenScale(11), 32) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = altFont and 600 or 100,
		antialias = true
	})

	surface.CreateFont("prChatYellFont", {
		font = altFont and "Roboto" or "Khand Medium",
		size =  altFont and (math.max(ScreenScale(7), 17)*1.2 * ix.option.Get("chatFontScale", 1)) or (math.max(ScreenScale(11), 32) * ix.option.Get("chatFontScale", 1))*1.2,
		extended = true,
		weight = altFont and 1200 or 100,
		antialias = true
	})

	surface.CreateFont("prChatWhisperFont", {
		font =  altFont and "Roboto" or "Khand Light",
		size =  altFont and (math.max(ScreenScale(7), 17)*0.85 * ix.option.Get("chatFontScale", 1)) or (math.max(ScreenScale(11), 32) * ix.option.Get("chatFontScale", 1))*0.85,
		extended = true,
		weight = altFont and 300 or 100,
		antialias = true
	})

	surface.CreateFont("prChatFontItalics", {
		font = altFont and "Roboto" or "Khand Light",
		size = altFont and (math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1)) or math.max(ScreenScale(11), 32) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = 600,
		antialias = true,
		italic = true
	})
end

if (CLIENT) then
	ix.chat.history = ix.chat.history or {} -- array of strings the player has entered into the chatbox
	ix.chat.currentCommand = ""
	ix.chat.currentArguments = {}

	ix.option.Add("chatNotices", ix.type.bool, false, {
		category = "chat"
	})

	ix.option.Add("chatTimestamps", ix.type.bool, false, {
		category = "chat"
	})

	ix.option.Add("chatFontScale", ix.type.number, 1, {
		category = "chat",
		OnChanged = function(oldValue, newValue)
			hook.Run("LoadFonts", ix.config.Get("font"), ix.config.Get("genericFont"))
			PLUGIN:CreateChat()
		end
	})

	ix.option.Add("useAltChatFont", ix.type.bool, false, {
		description = "Use Alternate Chat Font",
		category = "chat",
		OnChanged = function(oldValue, newValue)
			PLUGIN:LoadChatFonts(newValue)
			PLUGIN:CreateChat()
		end
	})


	ix.option.Add("chatOutline", ix.type.bool, false, {
		category = "chat"
	})

	-- tabs and their respective filters
	ix.option.Add("chatTabs", ix.type.string, "", {
		category = "chat",
		hidden = function()
			return true
		end
	})

	-- chatbox size and position
	ix.option.Add("chatPosition", ix.type.string, "", {
		category = "chat",
		hidden = function()
			return true
		end
	})

	--PLUGIN:CreateChat()

	function PLUGIN:CreateChat()
		if (IsValid(self.panel)) then
			self.panel:Remove()
		end

		self.panel = vgui.Create("ixChatbox")
		self.panel:SetupTabs(util.JSONToTable(ix.option.Get("chatTabs", "")))
		self.panel:SetupPosition(util.JSONToTable(ix.option.Get("chatPosition", "")))

		hook.Run("ChatboxCreated")
	end

	function PLUGIN:TabExists(id)
		if (!IsValid(self.panel)) then
			return false
		end

		return self.panel.tabs:GetTabs()[id] != nil
	end

	function PLUGIN:SaveTabs()
		local tabs = {}

		for id, panel in pairs(self.panel.tabs:GetTabs()) do
			tabs[id] = panel:GetFilter()
		end

		ix.option.Set("chatTabs", util.TableToJSON(tabs))
	end

	function PLUGIN:SavePosition()
		local x, y = self.panel:GetPos()
		local width, height = self.panel:GetSize()

		ix.option.Set("chatPosition", util.TableToJSON({x, y, width, height}))
	end

	function PLUGIN:InitPostEntity()
		self:CreateChat()
	end

	function PLUGIN:PlayerBindPress(client, bind, pressed)
		bind = bind:lower()

		if (bind:find("messagemode") and pressed) then
			self.panel:SetActive(true)

			return true
		end
	end

	function PLUGIN:HUDShouldDraw(element)
		if (element == "CHudChat") then
			return false
		end
	end

	function PLUGIN:ScreenResolutionChanged(oldWidth, oldHeight)
		self:CreateChat()
	end

	function PLUGIN:ChatText(index, name, text, messageType)
		if (messageType == "none" and IsValid(self.panel)) then
			self.panel:AddMessage(text)
		end
	end

	-- luacheck: globals chat
	chat.ixAddText = chat.ixAddText or chat.AddText

	function chat.AddText(...)
		if (IsValid(PLUGIN.panel)) then
			PLUGIN.panel:AddMessage(...)
		end

		-- log chat message to console
		local text = {}

		for _, v in ipairs({...}) do
			if (istable(v) or isstring(v)) then
				text[#text + 1] = v
			elseif (isentity(v) and v:IsPlayer()) then
				text[#text + 1] = team.GetColor(v:Team())
				text[#text + 1] = v:Name()
			elseif (type(v) != "IMaterial") then
				text[#text + 1] = tostring(v)
			end
		end

		text[#text + 1] = "\n"
		MsgC(unpack(text))
	end

	function chat.AddIconText(...)
		if (IsValid(PLUGIN.panel)) then
			PLUGIN.panel:AddIconMessage(...)
		end

		local args = {...}
		args = table.remove(args, 2)
	
		-- log chat message to console
		local text = {}
	
		for _, v in ipairs(args) do
			if (istable(v) or isstring(v)) then
				text[#text + 1] = v
			elseif (isentity(v) and v:IsPlayer()) then
				text[#text + 1] = team.GetColor(v:Team())
				text[#text + 1] = v:Name()
			elseif (type(v) != "IMaterial") then
				text[#text + 1] = tostring(v)
			end
		end
	
		text[#text + 1] = "\n"
		MsgC(unpack(text))
	end
else
	util.AddNetworkString("ixChatMessage")

	net.Receive("ixChatMessage", function(length, client)
		local text = net.ReadString()

		if ((client.ixNextChat or 0) < CurTime() and isstring(text) and text:find("%S")) then
			local maxLength = ix.config.Get("chatMax")

			if (text:utf8len() > maxLength) then
				text = text:utf8sub(0, maxLength)
			end

			hook.Run("PlayerSay", client, text)
			client.ixNextChat = CurTime() + 0.5
		end
	end)
end
