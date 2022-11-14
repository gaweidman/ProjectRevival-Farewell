
Schema.name = "HL2 RP"
Schema.author = "nebulous.cloud"
Schema.description = "A schema based on Half-Life 2."
Schema.logo = "vgui/project-revival/LongLogoNoBackground1024px.png"

Schema.socioWord = "GREEN"
Schema.socioColor = Color(0, 255, 0)
Schema.socioOutline = Color(255, 255, 255, 0)
Schema.Version = "Public Build 0.1.2"

function ix.option.Add(key, optionType, default, data)
	assert(isstring(key) and key:find("%S"), "expected a non-empty string for the key")

	data = data or {}

	local categories = ix.option.categories
	local category = data.category or "misc"
	local upperName = key:sub(1, 1):upper() .. key:sub(2)

	categories[category] = categories[category] or {}
	categories[category][key] = true

	ix.option.stored[key] = {
		key = key,
		phrase = data.phrase or "opt" .. upperName,
		description = data.description or "optd" .. upperName,
		type = optionType,
		default = default,
		min = data.min or 0,
		max = data.max or 10,
		decimals = data.decimals or 0,
		category = data.category or "misc",
		bNetworked = data.bNetworked and true or false,
		hidden = data.hidden or nil,
		populate = data.populate or nil,
		OnChanged = data.OnChanged or nil
	}
end

-- Include netstream
ix.util.Include("libs/thirdparty/sh_netstream2.lua")

ix.util.Include("libs/thirdparty/sh_imgui.lua")
ix.util.Include("libs/thirdparty/sh_netdata.lua")
circles = ix.util.Include("libs/thirdparty/cl_circles.lua")

ix.util.Include("sh_configs.lua")
ix.util.Include("sh_commands.lua")

ix.util.Include("cl_schema.lua")
ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("sh_voices.lua")
ix.util.Include("sv_schema.lua")
ix.util.Include("sv_hooks.lua")
ix.util.Include("sh_items.lua")
ix.util.Include("sh_alienparts.lua")
ix.util.Include("sh_rpitems.lua")
ix.util.Include("libs/sh_skills.lua")
ix.util.Include("libs/sh_crafting.lua")
ix.util.Include("libs/sh_apartments.lua")
ix.util.Include("libs/sh_perks.lua")
ix.util.Include("libs/sh_rpdamage.lua")
ix.util.Include("libs/sh_music.lua")
ix.util.Include("libs/cl_bar.lua")
ix.util.Include("libs/sh_illness.lua")


ix.util.Include("meta/sh_player.lua")
ix.util.Include("meta/sv_player.lua")
ix.util.Include("meta/sh_character.lua")

ix.flag.Add("v", "Access to light blackmarket goods.")
ix.flag.Add("V", "Access to heavy blackmarket goods.")

-- todo: migrate this to its own library
ix.messages = {}

-- ENUMS
THERMOS_EMPTY = 0
THERMOS_DIRTYWATER = 1
THERMOS_CLEANWATER = 2

-- Apartment Action enums
APTACT_OPEN = 0
APTACT_SVRESPONSE = 1
APTACT_ADDTENANT = 2
APTACT_REMOVETENANT = 3
APACT_INVALIDINDV = 4
APTACT_INVALIDTENANT = 5
APTACT_SVSUCCESS = 6
APTACT_APTFULL = 7
APTACT_INVALIDAPT = 8
APTACT_PRINTKEY = 9
APTACT_CALLRES = 10
APTACT_BADRANK = 11
APTACT_BADFACTION = 12
APTACT_ALREADYASSIGNED = 13

-- Messenger Enums
MSG_OPEN = 0
MSG_SEND = 1
MSG_DELETE = 2
MSG_SETNAME = 3 
MSG_SETREAD = 4

-- Waypoint Enums
WP_NEUTRAL = 1
WP_WARNING = 2
WP_CAUTION = 3
WP_WAYPOINT = 4

-- Message Struct (Serverside)
/*
	string sender The string representation of the character ID of the person or group that sent the message.
	string recipient The string representation of the character ID of the person or group the message was sent to.
	string text The message's contents.
	string subject The message's subject line.
	number time The time, in unix time, the message was sent.
	boolean read Whether or not the recipient has read the message.
*/

-- Message Struct (Clientside)
/*
	string sender The string representation of the IIN of the person that sent the message. This is nil if the sender is in the Combine.
	string recipient The string representation of the IIN of the person the message was sent to. This is nil if the recipient is in the Combine.
	string alias The display name of the message's sender. If the message is in the outbox, this will be the display name of the recipient.
	string text The message's contents.
	string subject The message's subject line.
	number time The time, in unix time, the message was sent.
	boolean read Whether or not the recipient has read the message. This is nil if the message is in the outbox.
	boolean isCombine Whether or not the sender is a Combine official. If the message is in the outbox, this will be whether or not the recipient is a combine official.
*/


function ServerMessage(sender, recipient, text, subject, time, read)
	return {
		sender = sender,
		recipient = recipient, 
		text = text, 
		subject = subject,
		time = time, 
		read = read
	}
end

function ClientMessage(sender, recipient, alias, text, subject, time, read, isCombine)
	return {
		sender = sender,
		recipient = recipient, 
		alias = alias,
		text = text, 
		subject = subject,
		time = time, 
		read = read,
		isCombine = isCombine
	}
end

ix.staffgroups = {
	user = 0,
	supporter = 0,
	vip = 0,
	supervip = 0,
	gamer = 0,
	epicgamer = 0,
	truegamer = 0,
	trialmod = 1,
	moderator = 2,
	admin = 3,
	superadmin = 4,
	headadmin = 5
}

DEFAULT_SUITS = {
	cyclopscivsuit = "models/industrial_uniforms/industrial_uniform.mdl", 
	greencivsuit ="models/industrial_uniforms/industrial_uniform2.mdl"
}

-- chat types
do
	local eventColor = Color(255, 150, 0)
	do
		local CLASS = {}
		CLASS.prefix = {"/v", "/vort", "vortigese"}
		CLASS.description = "Say something in vortigese."
		CLASS.color = Color(153, 153, 26)
		CLASS.indicator = "Flux Shifting..."
	
		function CLASS:CanSay(speaker, text, data)
			if speaker:GetCharacter() == nil then return false end
			if !speaker:Alive() then return false end
	
			local result = speaker:GetCharacter():GetFaction() == FACTION_ALIEN and speaker:GetCharacter():GetClass() == CLASS_FREEVORT
	
			if result then
				speaker:DoVortSpeechSounds(text)
			end
	
			return result
		end
	
		function CLASS:CanHear(speaker, listener, data)
			if listener:GetCharacter() == nil then return false end
			if speaker:GetPos():Distance(listener:GetPos()) > ix.config.Get("chatRange", 280) then return false end
	
			if listener:GetCharacter():GetFaction() == FACTION_ALIEN and speaker:GetCharacter():GetClass() == CLASS_FREEVORT then
				return true
			else
				ix.chat.Send(speaker, "icAutoDesc", speaker:GetName().." says something in Vortigese.", false, listener)
				return false
			end
	
		end
	
		function CLASS:OnChatAdd(speaker, text, anonymous, data)
			chat.AddText(self.color, speaker:GetName().." says in vortigese \""..text.."\"")
		end
	
		ix.chat.Register("vortigese", CLASS)
	end

	do
		local CLASS = {}
		CLASS.color = Color(255, 255, 175)
		CLASS.format = "%s radios in \"%s\""
		CLASS.printName = "Radio (Eavesdrop)"

		function CLASS:GetColor(speaker, text)
			if (LocalPlayer():GetEyeTrace().Entity == speaker) then
				return Color(175, 255, 175)
			end

			return self.color
		end

		function CLASS:CanHear(speaker, listener)
			if (ix.chat.classes.radio:CanHear(speaker, listener)) then
				return false
			end


			local chatRange = ix.config.Get("chatRange", 280)

			return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange)
		end

		function CLASS:OnChatAdd(speaker, text)
			local recogName

			local chatColor = ix.chat.classes.ic:GetColor(speaker, text)

			local ourCharacter = LocalPlayer():GetCharacter()
			local character = speaker:GetCharacter()

			if (LocalPlayer():GetCharacter() and speaker:GetCharacter() and !LocalPlayer():GetCharacter():DoesRecognize(speaker:GetCharacter()) and !hook.Run("IsPlayerRecognized", client)) then
				local description = character:GetDescription()

				if (#description > 40) then
					description = description:utf8sub(1, 23).."..."
				end

				recogName = "["..description.."]"
			end

			local name = hook.Run("GetCharacterName", speaker, "ic") or character:GetName()
			
			
			chat.AddText(chatColor, name.." radios in \"", color_white, text, chatColor, "\"")
		end

		ix.chat.Register("radio_eavesdrop", CLASS)
	end

	do
		local CLASS = {}
		CLASS.color = Color(207, 23, 23)
		CLASS.format = "Dispatch broadcasts \"%s\""
	
		function CLASS:CanSay(speaker, text)
			if (!speaker:IsDispatch()) then
				speaker:NotifyLocalized("notAllowed")
	
				return false
			end
		end
	
		function CLASS:OnChatAdd(speaker, text)
			if text.sub(1,1) != "!" then
				if chat.AddIconText then
					chat.AddIconText("d", self.color, string.format(self.format, text))
				else
					chat.AddText(self.color, string.format(self.format, text))
				end
			end
		end
	
		ix.chat.Register("dispatch", CLASS)
	end
	

	do
		local CLASS = {}
		CLASS.color = Color(175, 125, 100)
		CLASS.format = "%s requests \"%s\""
		CLASS.printName = "Request Device"

		function CLASS:CanHear(speaker, listener)
			return listener:IsCombine() or speaker:Team() == FACTION_ADMIN
		end

		function CLASS:OnChatAdd(speaker, text)
			chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
		end

		ix.chat.Register("request", CLASS)
	end

	do
		local CLASS = {}
		CLASS.color = Color(175, 125, 100)
		CLASS.format = "%s requests \"%s\""
		CLASS.printName = "Request Device (Eavesdrop)"

		function CLASS:CanHear(speaker, listener)
			if (ix.chat.classes.request:CanHear(speaker, listener)) then
				return false
			end

			local chatRange = ix.config.Get("chatRange", 280)

			return (speaker:Team() == FACTION_CITIZEN and listener:Team() == FACTION_CITIZEN)
			and (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange)
		end

		function CLASS:OnChatAdd(speaker, text)
			chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
		end

		ix.chat.Register("request_eavesdrop", CLASS)
	end

	do
		local CLASS = {}
		CLASS.color = Color(191, 128, 255)
		CLASS.format = "%s broadcasts \"%s\""
		CLASS.printName = "Broadcast"

		function CLASS:CanSay(speaker, text)
			if (speaker:Team() != FACTION_ADMIN) then
				speaker:NotifyLocalized("notAllowed")

				return false
			end
		end

		function CLASS:OnChatAdd(speaker, text)
			if chat.AddIconText then
				chat.AddIconText("d", self.color, string.format(self.format, speaker:Name(), text))
			else
				chat.AddIconText(self.color, string.format(self.format, speaker:Name(), text))
			end
			
		end

		ix.chat.Register("broadcast", CLASS)
	end


	do
		ix.chat.Register("warning", {
			printName = "Warning Notification",
			CanHear = 1000000,
			OnChatAdd = function(self, speaker, text)
				chat.AddIconText("g", eventColor, string.format(self.format, text))
			end
		})
	end
	
	do
		ix.chat.Register("info", {
			printName = "Information Notification",
			CanHear = 1000000,
			OnChatAdd = function(self, speaker, text)
				chat.AddIconText("f", eventColor, string.format(self.format, text))
			end
		})
	end
	
	do
		ix.chat.Register("maintenance", {
			printName = "Maintenance Notification",
			CanHear = 1000000,
			OnChatAdd = function(self, speaker, text)
				chat.AddIconText("a", eventColor, string.format(self.format, text))
			end
		})
	end
	
	ix.chat.Register("ooc", {
		CanSay = function(self, speaker, text)
			if (!ix.config.Get("allowGlobalOOC")) then
				speaker:NotifyLocalized("Global OOC is disabled on this server.")
				return false
			else
				local delay = ix.config.Get("oocDelay", 10)
	
				-- Only need to check the time if they have spoken in OOC chat before.
				if (delay > 0 and speaker.ixLastOOC) then
					local lastOOC = CurTime() - speaker.ixLastOOC
	
					-- Use this method of checking time in case the oocDelay config changes.
					if (lastOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
						speaker:NotifyLocalized("oocDelay", delay - math.ceil(lastOOC))
	
						return false
					end
				end
	
				-- Save the last time they spoke in OOC.
				speaker.ixLastOOC = CurTime()
			end
		end,
		OnChatAdd = function(self, speaker, text)
			-- @todo remove and fix actual cause of speaker being nil
			if (!IsValid(speaker)) then
				return
			end
	
			local icon = "icon16/user.png"
	
			if (speaker:IsSuperAdmin()) then
				icon = "icon16/shield.png"
			elseif (speaker:IsAdmin()) then
				icon = "icon16/star.png"
			elseif (speaker:IsUserGroup("moderator") or speaker:IsUserGroup("operator")) then
				icon = "icon16/wrench.png"
			elseif (speaker:IsUserGroup("vip") or speaker:IsUserGroup("donator") or speaker:IsUserGroup("donor")) then
				icon = "icon16/heart.png"
			end
	
			icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)
	
			chat.AddText(icon, Color(255, 50, 50), "[OOC] ", speaker, color_white, ": "..text)
		end,
		prefix = {"//", "/OOC"},
		description = "@cmdOOC",
		noSpaceAfter = true
	})
	
	ix.chat.Register("looc", {
		CanSay = function(self, speaker, text)
			local delay = ix.config.Get("loocDelay", 0)
	
			-- Only need to check the time if they have spoken in OOC chat before.
			if (delay > 0 and speaker.ixLastLOOC) then
				local lastLOOC = CurTime() - speaker.ixLastLOOC
	
				-- Use this method of checking time in case the oocDelay config changes.
				if (lastLOOC <= delay and !CAMI.PlayerHasAccess(speaker, "Helix - Bypass OOC Timer", nil)) then
					speaker:NotifyLocalized("loocDelay", delay - math.ceil(lastLOOC))
	
					return false
				end
			end
	
			-- Save the last time they spoke in OOC.
			speaker.ixLastLOOC = CurTime()
		end,
		OnChatAdd = function(self, speaker, text)
			local icon = "icon16/user.png"
	
			if (speaker:IsSuperAdmin()) then
				icon = "icon16/shield.png"
			elseif (speaker:IsAdmin()) then
				icon = "icon16/star.png"
			elseif (speaker:IsUserGroup("moderator") or speaker:IsUserGroup("operator")) then
				icon = "icon16/wrench.png"
			elseif (speaker:IsUserGroup("vip") or speaker:IsUserGroup("donator") or speaker:IsUserGroup("donor")) then
				icon = "icon16/heart.png"
			end
	
			icon = Material(hook.Run("GetPlayerIcon", speaker) or icon)
			
			chat.AddText(icon, Color(255, 50, 50), "[LOOC] ", ix.config.Get("chatColor"), speaker:Name()..": "..text)
		end,
		CanHear = ix.config.Get("chatRange", 280),
		prefix = {".//", "[[", "/LOOC"},
		description = "@cmdLOOC",
		noSpaceAfter = true
	})
	
	
	do
		local CLASS = {}
		CLASS.color = Color(46, 167, 6)
		CLASS.format = "%s radios in \""
		CLASS.printName = "Radio"
	
		function CLASS:CanHear(speaker, listener)
			local character = listener:GetCharacter()
			local inventory = character:GetInventory()
			local bHasRadio = false
			local nearRadio = false
			local speakerFreq = speaker:GetCharacter():GetData("frequency")
			local listenerFreq = character:GetData("frequency")
	
			print("PSEAKER FREQ", speakerFreq, "LISTENER FREQ", listenerFreq)
			local listenerPos = listener:GetPos()
	
			local traceEnt = speaker:GetEyeTrace().Entity
	
			local speakerFacingRadio = IsValid(traceEnt) and 
			traceEnt:GetClass() == "ix_transrecradio" and 
			traceEnt:GetNetVar("On", false) and 
			traceEnt.frequency != nil and 
			speaker:GetPos():Distance(traceEnt:GetPos()) <= 96
	
			if speakerFacingRadio then
				speakerFreq = traceEnt.frequency
			end
		
			for k, v in ipairs(ents.FindInSphere(listenerPos, ix.config.Get("chatRange", 280))) do
				if v:GetClass() != "ix_transrecradio" then continue end
				if v.volume == 0 and listener != speaker then continue end
				local reqDistance = Lerp(v.volume/100, 45, 280)
	
				if speakerFreq == v.frequency and v:GetNetVar("On", false) and listenerPos:Distance(v:GetPos()) <= reqDistance then
					return true
				end
			end
	
			for k, v in pairs(inventory:GetItemsByUniqueID("hybridradio", true)) do
				if (v:GetData("enabled", false) and speakerFreq == listenerFreq) then
					return true
				end
			end
	
			return false
		end
	
		function CLASS:OnChatAdd(speaker, text)
			local recogName
	
			local ourCharacter = LocalPlayer():GetCharacter()
			local character = speaker:GetCharacter()
	
			local name = hook.Run("GetCharacterName", speaker, "radio") or character:GetName()
	
			chat.AddText(self.color, name.." radios in \"", color_white, text, self.color, "\"")
		end
	
		ix.chat.Register("radio", CLASS)
	end
	
	do
		local CLASS = {}
		CLASS.color = Color(46, 167, 6)
		CLASS.format = "%s: %s"
		CLASS.printName = "OOC Radio"
	
		function CLASS:CanHear(speaker, listener)
			local character = listener:GetCharacter()
			local inventory = character:GetInventory()
			local bHasRadio = false
			local nearRadio = false
			local speakerFreq = speaker:GetCharacter():GetData("frequency")
			local listenerFreq = character:GetData("frequency")
			local listenerPos = listener:GetPos()
	
			local traceEnt = speaker:GetEyeTrace().Entity
	
			local speakerFacingRadio = IsValid(traceEnt) and 
			traceEnt:GetClass() == "ix_transrecradio" and 
			traceEnt:GetNetVar("On", false) and 
			traceEnt.frequency != nil and 
			speaker:GetPos():Distance(traceEnt:GetPos()) <= 96
	
			if speakerFacingRadio then
				speakerFreq = traceEnt.frequency
			end
		
			for k, v in ipairs(ents.FindInSphere(listenerPos, ix.config.Get("chatRange", 280))) do
				if v:GetClass() != "ix_transrecradio" then continue end
				if v.volume == 0 and listener != speaker then continue end
				local reqDistance = Lerp(v.volume/100, 45, 280)
	
				if speakerFreq == v.frequency and v:GetNetVar("On", false) and listenerPos:Distance(v:GetPos()) <= reqDistance then
					return true
				end
			end
	
			for k, v in pairs(inventory:GetItemsByUniqueID("hybridradio", true)) do
				if (v:GetData("enabled", false) and speakerFreq == listenerFreq) then
					return true
				end
			end
	
			return false
		end
	
		function CLASS:OnChatAdd(speaker, text)
			chat.AddText(Color(255, 50, 50), "[Radio OOC] ", self.color, speaker:Name(), color_white, ": "..text)
		end
	
		ix.chat.Register("oocradio", CLASS)
	end
	
	ix.chat.Register("roll", {
		format = "** %s has rolled %s out of %s.",
		color = Color(160, 91, 192),
		CanHear = ix.config.Get("chatRange", 280),
		deadCanChat = true,
		OnChatAdd = function(self, speaker, text, bAnonymous, data)
			local max = data.max or 100
			local translated = L2(self.uniqueID.."Format", speaker:Name(), text, max)
	
			chat.AddText(self.color, translated and "** "..translated or string.format(self.format,
				speaker:Name(), text, max
			))
		end
	})
	
	ix.chat.Register("fliptoken", {
		format = "** %s flips a token and it lands on %s.",
		color = Color(160, 91, 192),
		CanHear = ix.config.Get("chatRange", 280),
		deadCanChat = true,
		OnChatAdd = function(self, speaker, text, bAnonymous, data)
			chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
		end
	})
	
	ix.chat.Register("rollattribute", {
		format = "** %s has rolled %d (%s + %s) out of 100 on %s.",
		color = Color(160, 91, 192),
		CanHear = ix.config.Get("chatRange", 280),
		deadCanChat = true,
		OnChatAdd = function(self, speaker, text, bAnonymous, data)
			if data.critVal == 1 then
				chat.AddText(self.color, string.format("** %s has rolled %d (%s + %s) out of 100 on %s, a critical success.", speaker:Name(), tostring(text + data.attrVal), tostring(text), tostring(data.attrVal), data.attrName))
			elseif data.critVal == -1 then
				chat.AddText(self.color, string.format("** %s has rolled %d (%s + %s) out of 100 on %s, a critical failure.", speaker:Name(), tostring(text + data.attrVal), tostring(text), tostring(data.attrVal), data.attrName))
			else
				chat.AddText(self.color, string.format(self.format, speaker:Name(), tostring(text + data.attrVal), tostring(text), tostring(data.attrVal), data.attrName))
			end
		end
	})
	
	ix.chat.Register("rollskill", {
		format = "** %s has rolled %d (%s + %s) out of 100 on %s.",
		color = Color(160, 91, 192),
		CanHear = ix.config.Get("chatRange", 280),
		deadCanChat = true,
		OnChatAdd = function(self, speaker, text, bAnonymous, data)
			if data.critVal == 1 then
				chat.AddText(self.color, string.format("** %s has rolled %d (%s + %s) out of 100 on %s, a critical success.", speaker:Name(), tostring(text + data.sklVal), tostring(text), tostring(data.sklVal), data.sklName))
			elseif data.critVal == -1 then
				chat.AddText(self.color, string.format("** %s has rolled %d (%s + %s) out of 100 on %s, a critical failure.", speaker:Name(), tostring(text + data.sklVal), tostring(text), tostring(data.sklVal), data.sklName))
			else
				chat.AddText(self.color, string.format(self.format, speaker:Name(), tostring(text + data.sklVal), tostring(text), tostring(data.sklVal), data.sklName))
			end
		end
	})

	ix.chat.Register("ic", {
		format = "%s says \"%s\"",
		indicator = "chatTalking",
		GetColor = function(self, speaker, text)
			-- If you are looking at the speaker, make it greener to easier identify who is talking.
			if (speaker:GetEyeTrace().Entity == LocalPlayer()) then
				return ix.config.Get("chatListenColor")
			end
	
			-- Otherwise, use the normal chat color.
			return ix.config.Get("chatColor")
		end,
		CanHear = ix.config.Get("chatRange", 280),
		OnChatAdd = function(self, speaker, text)
			-- @todo remove and fix actual cause of speaker being nil
			if (!IsValid(speaker)) then
				return
			end
	
			local chatColor = self.GetColor(self, speaker, text)
	
			local ourCharacter = LocalPlayer():GetCharacter()
			local character = speaker:GetCharacter()

			local name = hook.Run("GetCharacterName", speaker, "ic") or character:GetName()
	
			if speaker:GetEyeTrace().Entity == LocalPlayer() then
				chat.AddText(chatColor, name.." says (to you) \"", color_white, text, chatColor, "\"")
			else
				chat.AddText(chatColor, name.." says \"", color_white, text, chatColor, "\"")
			end
		end
	})
	
	ix.chat.Register("w", {
		format = "%s whispers \"%s\"",
		GetColor = function(self, speaker, text)
			local color = ix.chat.classes.ic:GetColor(speaker, text)
			return color
		end,
		CanHear = ix.config.Get("chatRange", 280) * 0.25,
		prefix = {"/W", "/Whisper"},
		description = "@cmdW",
		font = "prChatWhisperFont",
		indicator = "chatWhispering",
		OnChatAdd = function(self, speaker, text)
			-- @todo remove and fix actual cause of speaker being nil
			if (!IsValid(speaker)) then
				return
			end
	
			local chatColor = self:GetColor(speaker, text)
	
			-- @todo remove and fix actual cause of speaker being nil
			if (!IsValid(speaker)) then
				return
			end
	
			local chatColor = self:GetColor(speaker, text)
	
			local recogName
	
			local ourCharacter = LocalPlayer():GetCharacter()
			local character = speaker:GetCharacter()
	
	
			local name = hook.Run("GetCharacterName", speaker, "ic") or character:GetName()
	
			if speaker:GetEyeTrace().Entity == LocalPlayer() then
				chat.AddText(chatColor, name.." whispers (to you) \"", color_white, text, chatColor, "\"")
			else
				chat.AddText(chatColor, name.." whispers \"", color_white, text, chatColor, "\"")
			end
		end
	})
	
	
	ix.chat.Register("y", {
		format = "%s yells \"%s\"",
		GetColor = function(self, speaker, text)
			local color = ix.chat.classes.ic:GetColor(speaker, text)
	
			return color
		end,
		CanHear = ix.config.Get("chatRange", 280) * 2,
		prefix = {"/Y", "/Yell"},
		description = "@cmdY",
		font = "prChatYellFont",
		indicator = "chatYelling",
		OnChatAdd = function(self, speaker, text)
			-- @todo remove and fix actual cause of speaker being nil
			if (!IsValid(speaker)) then
				return
			end
	
			local chatColor = self:GetColor(speaker, text)
	
			local recogName
	
			local ourCharacter = LocalPlayer():GetCharacter()
			local character = speaker:GetCharacter()
	
			local name = hook.Run("GetCharacterName", speaker, "y") or character:GetName()
	
			if speaker:GetEyeTrace().Entity == LocalPlayer() then
				chat.AddText(chatColor, name.." yells (at you) \"", color_white, text, chatColor, "\"")
			else
				chat.AddText(chatColor, name.." yells \"", color_white, text, chatColor, "\"")
			end
		end,
	})
	
	ix.chat.Register("me", {
		format = "** %s %s",
		GetColor = ix.chat.classes.ic.GetColor,
		CanHear = ix.config.Get("chatRange", 280) * 2,
		prefix = {"/Me", "/Action"},
		description = "@cmdMe",
		indicator = "chatPerforming",
		deadCanChat = true,
		OnChatAdd = function(self, speaker, text)
			-- @todo remove and fix actual cause of speaker being nil
			if (!IsValid(speaker)) then
				return
			end
	
			local chatColor = self:GetColor(speaker, text)
	
			local recogName
	
			local ourCharacter = LocalPlayer():GetCharacter()
			local character = speaker:GetCharacter()
	
			local name = hook.Run("GetCharacterName", speaker, "me") or character:GetName()
	
			local firstTwoChars = string.sub(text, 0, 2) 
			if firstTwoChars == "'s" or firstTwoChars == ", " then
				chat.AddText(chatColor, "** "..name..text)
			else
				chat.AddText(chatColor, "** "..name.." "..text)
			end
		end,
	})
	
	
	ix.chat.Register("mey", {
		format = "*** %s %s",
		GetColor = function(self, speaker, text)
			local color = ix.chat.classes.ic:GetColor(speaker, text)
	
			return color
		end,
		CanHear = ix.config.Get("chatRange", 280) * 2,
		prefix = {"/mey"},
		description = "@cmdY",
		font = "prChatYellFont",
		indicator = "chatPerforming",
		OnChatAdd = function(self, speaker, text)
			-- @todo remove and fix actual cause of speaker being nil
			if (!IsValid(speaker)) then
				return
			end
	
			local chatColor = self:GetColor(speaker, text)
	
			local recogName
	
			local ourCharacter = LocalPlayer():GetCharacter()
			local character = speaker:GetCharacter()
	
			local name = hook.Run("GetCharacterName", speaker, "me") or character:GetName()
	
			local firstTwoChars = string.sub(text, 0, 2) 
			if firstTwoChars == "'s" or firstTwoChars == ", " then
				chat.AddText(chatColor, "*** "..name..text)
			else
				chat.AddText(chatColor, "*** "..name.." "..text)
			end
		
		end,
	})
	
	ix.chat.Register("mew", {
		format = "** %s %s",
		GetColor = function(self, speaker, text)
			local color = ix.chat.classes.ic:GetColor(speaker, text)
			return color
		end,
		CanHear = ix.config.Get("chatRange", 280) /2,
		prefix = {"/mew"},
		description = "",
		font = "prChatWhisperFont",
		indicator = "chatPerforming",
		OnChatAdd = function(self, speaker, text)
			-- @todo remove and fix actual cause of speaker being nil
			if (!IsValid(speaker)) then
				return
			end
	
			local chatColor = self:GetColor(speaker, text)
	
			local recogName
	
			local ourCharacter = LocalPlayer():GetCharacter()
			local character = speaker:GetCharacter()
	
			local name = hook.Run("GetCharacterName", speaker, "me") or character:GetName()
	
			local firstTwoChars = string.sub(text, 0, 2) 
			if firstTwoChars == "'s" or firstTwoChars == ", " then
				chat.AddText(chatColor, "* "..name..text)
			else
				chat.AddText(chatColor, "* "..name.." "..text)
			end
			
		end,
	})
	
	do
		local CLASS = {}
		CLASS.prefix = {"/vfar", "/vortfar", "/vortigesefar"}
		CLASS.description = "Say something in vortigese with a large radius."
		CLASS.color = Color(155, 155, 26)
		CLASS.indicator = "Flux Shifting..."
	
		function CLASS:CanSay(speaker, text, data)
			if speaker:GetCharacter() == nil then return false end
			if !speaker:Alive() then return false end
	
			local result = speaker:GetCharacter():GetFaction() == FACTION_ALIEN and speaker:GetCharacter():GetClass() == CLASS_FREEVORT
	
			if result then
				local callSounds = {"vo/outland_01/intro/ol01_vortcall01.wav", "vo/outland_01/intro/ol01_vortcall02c.wav", "vo/outland_01/intro/ol01_vortresp01.wav"}
				speaker:EmitSound(callSounds[math.random(1, #callSounds)], SNDLVL_95dB, math.random(93, 105), 1, CHAN_VOICE)
			end
	
			return result
		end
	
		function CLASS:CanHear(speaker, listener, data)
			if listener:GetCharacter() == nil then return false end
	
			if listener:GetCharacter():GetFaction() == FACTION_ALIEN and speaker:GetCharacter():GetClass() == CLASS_FREEVORT then
				return true
			else
				ix.chat.Send(speaker, "icAutoDesc", speaker:GetName().." says something in long-distance Vortigese.", false, listener)
				return false
			end
	
		end
	
		function CLASS:OnChatAdd(speaker, text, anonymous, data)
			
			chat.AddText(self.color, speaker:GetName().." calls in Vortigese \""..text.."\"")
		end
	
		ix.chat.Register("vortigeseFar", CLASS)
	end

	do
		ix.chat.Register("bug", {
			printName = "Bug Notification",
			CanHear = 1000000,
			OnChatAdd = function(self, speaker, text)
				chat.AddIconText("b", eventColor, string.format(self.format, text))
			end
		})
	end
end

/*

ix.anim.sample = {
	normal = { --holdtype normal
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE}, -- weapon lowered, weapon raised
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE_ANGRY, ACT_CROUCH},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_HURT},
		[ACT_LAND] = {ACT_FLINCH_RIGHTLEG, ACT_FLINCH_RIGHTLEG},
		attack = ACT_MELEE_ATTACK1
	},
	pistol = { -- holdtype pistol
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE_ANGRY, ACT_CROUCH},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_HURT},
		[ACT_LAND] = {ACT_FLINCH_RIGHTLEG, ACT_FLINCH_RIGHTLEG},
		attack = ACT_MELEE_ATTACK1
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE_ANGRY, ACT_CROUCH},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_HURT},
		[ACT_LAND] = {ACT_FLINCH_RIGHTLEG, ACT_FLINCH_RIGHTLEG},
		attack = ACT_MELEE_ATTACK1
	},
	shotgun = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE_ANGRY, ACT_CROUCH},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_HURT},
		[ACT_LAND] = {ACT_FLINCH_RIGHTLEG, ACT_FLINCH_RIGHTLEG},
		attack = ACT_MELEE_ATTACK1
	},
	grenade = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE_ANGRY, ACT_CROUCH},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_HURT},
		[ACT_LAND] = {ACT_FLINCH_RIGHTLEG, ACT_FLINCH_RIGHTLEG},
		attack = ACT_RANGE_ATTACK2
	},
	melee = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE_ANGRY, ACT_CROUCH},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_HURT},
		[ACT_LAND] = {ACT_FLINCH_RIGHTLEG, ACT_FLINCH_RIGHTLEG},
		attack = ACT_MELEE_ATTACK1
	},
	glide = ACT_IDLE
}

*/

ix.sellableitems = {
	"blackbeanie",
	"bluebeanie",
	"bluewhitecoat",
	"brownbeanie",
	"brownjacketsweater",
	"comfyblueshirt",
	"fingerlessgloves",
	"gloves",
	"graybrownjacketsweater",
	"grayjacketsweater",
	"grayjeans",
	"greenbeanie",
	"greenshirt",
	"khakipants",
	"lightbluejeans",
	"redblackcoat",
	"sweatpants",
	"tealblackcoat",
	"flashlight",
	"pan",
	"pot",
	"catstatue",
	"horsefigurine",
	"copypaper",
	"uucigs",
	"lionstatue",
	"nailpack",
	"powercord",
	"soap",
	"thermometer",
	"toiletpaper",
	"notepad",
	"paper",
	"water",
	"water_flavored",
	"water_sparkling",
	"uuabsinthe",
	"uuapple",
	"uubanana",
	"uubranflakes",
	"uubread",
	"uucheese",
	"uuchips",
	"uucoffee",
	"uucorn",
	"uuchocolate",
	"uugin",
	"uulager",
	"uuorange",
	"uupeanuts",
	"uupear",
	"uupopcorn",
	"uupotato",
	"uupickles",
	"uupineapple",
	"uusardines",
	"aabattery",
	"padlock",
	"pin",
	"sewing_kit",
	"small_thermos"

}

ix.anim.strooper = {
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE_ANGRY, ACT_CROUCH},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_HURT},
		[ACT_LAND] = {ACT_FLINCH_RIGHTLEG, ACT_FLINCH_RIGHTLEG},
		attack = ACT_MELEE_ATTACK1
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE_ANGRY, ACT_CROUCH},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_HURT},
		[ACT_LAND] = {ACT_FLINCH_RIGHTLEG, ACT_FLINCH_RIGHTLEG},
		attack = ACT_MELEE_ATTACK1
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE_ANGRY, ACT_CROUCH},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_HURT},
		[ACT_LAND] = {ACT_FLINCH_RIGHTLEG, ACT_FLINCH_RIGHTLEG},
		attack = ACT_MELEE_ATTACK1
	},
	shotgun = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE_ANGRY, ACT_CROUCH},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_HURT},
		[ACT_LAND] = {ACT_FLINCH_RIGHTLEG, ACT_FLINCH_RIGHTLEG},
		attack = ACT_MELEE_ATTACK1
	},
	grenade = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE_ANGRY, ACT_CROUCH},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_HURT},
		[ACT_LAND] = {ACT_FLINCH_RIGHTLEG, ACT_FLINCH_RIGHTLEG},
		attack = ACT_RANGE_ATTACK2
	},
	melee = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE_ANGRY, ACT_CROUCH},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM_RIFLE},
		[ACT_MP_CROUCHWALK] = {ACT_WALK_CROUCH, ACT_WALK_CROUCH},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_HURT},
		[ACT_LAND] = {ACT_FLINCH_RIGHTLEG, ACT_FLINCH_RIGHTLEG},
		attack = ACT_MELEE_ATTACK1
	},
	glide = ACT_IDLE
}

ix.anim.grief = {
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE}, -- weapon lowered, weapon raised
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		attack = ACT_MELEE_ATTACK1
	}
}

ix.anim.vortigaunt = {
	melee = {
		["attack"] = ACT_MELEE_ATTACK1,
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "ActionIdle"},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_AIM},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM},
	},
	grenade = {
		["attack"] = ACT_MELEE_ATTACK1,
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "ActionIdle"},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK}
	},
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE_ANGRY},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_AIM},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM},
		["attack"] = ACT_MELEE_ATTACK1
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "TCidlecombat"},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		["reload"] = ACT_IDLE,
		[ACT_MP_RUN] = {ACT_RUN, "run_all_TC"},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, "Walk_all_TC"}
	},
	shotgun = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "TCidlecombat"},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		["reload"] = ACT_IDLE,
		[ACT_MP_RUN] = {ACT_RUN, "run_all_TC"},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, "Walk_all_TC"}
	},
	smg = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, "TCidlecombat"},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		["reload"] = ACT_IDLE,
		[ACT_MP_RUN] = {ACT_RUN, "run_all_TC"},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, "Walk_all_TC"}
	},
	beam = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE_ANGRY},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {ACT_RUN, ACT_RUN_AIM},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK_AIM},
		["attack"] = ACT_GESTURE_RANGE_ATTACK1,
		["reload"] = ACT_IDLE,
		["glide"] = {ACT_RUN, ACT_RUN}
	},
	sweep = {
		[ACT_MP_STAND_IDLE] = {"sweep_idle", "sweep_idle"},
		[ACT_MP_CROUCH_IDLE] = {"crouchidle", "crouchidle"},
		[ACT_MP_RUN] = {"run_all_tc", "run_all_tc"},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {"walk_all_holdbroom", "walk_all_holdbroom"},
		["attack"] = ACT_GESTURE_RANGE_ATTACK1,
		["reload"] = ACT_IDLE,
		["glide"] = {ACT_RUN, ACT_RUN}
	},
	glide = "jump_holding_glide"
}

ix.option.Add("showSquadInChat", ix.type.bool, true, {
	["category"] = "Appearance",
	["phrase"] = "Show Squad in Chat",
	["description"] = "Whether or not to show fellow squad members' squad designation in the chatbox."
})

ix.option.Add("drawCinematicOverlays", ix.type.bool, false, {
	["category"] = "Staff Options",
	["phrase"] = "Draw Cinematic Overlays",
	["description"] = "Whether or not to draw cinematic screen overlays."
})

ix.option.Add("autoVortMessages", ix.type.bool, false, {
	["category"] = "Roleplay",
	["phrase"] = "Automatically Send Vortigaunt Messages",
	["description"] = "Whether or not to automatically send IC messages from your vortigaunt when attacking."
})

ix.attributes.creationPoints = 3

timer.Simple(5, function()

	ix.attributes.list = {}

	ix.attributes.list["strength"] = {
		["name"] = "Strength",
		["description"] = "Your ability to move and handle heavy weights and exert large forces."
	}

	ix.attributes.list["agility"] = {
		["name"] = "Agility",
		["description"] = "How quickly you can efficiently move your body."
	}

	ix.attributes.list["intelligence"] = {
		["name"] = "Intelligence",
		["description"] = "Your capability for complex reasoning and how well you can both obtain and apply knowlede."
	}

	ix.attributes.list["constitution"] = {
		["name"] = "Constitution",
		["description"] = "Your body's ability to resist and endure physical stress."
	}

end)

function ix.messages.GetSpecialRecip(recipID)
	-- todo: add special recipients. sectorial, commander, consul
	if recipID == "SECTORIAL" then
		-- return sectorial char
	elseif recipID == "COMMANDER" then
		-- return commander char
	elseif recipID == "CONSUL" then
		-- return consul char
	end
end

if SERVER then
	function ix.messages.GetMsgInfo(id)
		-- if the sender is not an organization
		if tonumber(id) then
			local char = ix.char.loaded[id]
			local isCombine = char:IsCombine()
	
			local id
			local alias
	
			if isCombine then
				id = char:GetName()
				alias = nil
			else
				id = char:GetData("cid", "ERROR")
				alias = char:GetData("MsgDisplayName", nil)
			end
	
			return id, alias
		else
			-- todo: organization support
		end
	end 
end 


function ix.util.GetFoodQuality(qualityNum)
	if qualityNum <= 10 then return "Inedible"
	elseif qualityNum <= 15 then return "Awful"
	elseif qualityNum <= 25 then return "Poor"
	elseif qualityNum <= 50 then return "Decent"
	elseif qualityNum <= 70 then return "Good"
	elseif qualityNum <= 85 then return "Great"
	else return "Amazing" end
end

function ix.util.GetIngrQuality(qualityNum)
	if qualityNum < 25 then return "Very Poor"
	elseif qualityNum < 50 then return "Poor"
	elseif qualityNum < 75 then return "Good"
	else return "Very Good" end
end

function ix.util.DrawAlyxText(text, font, x, y, color, xAlign, yAlign)
	draw.SimpleText(text, font, x, y - draw.GetFontHeight(font)*0.425, color, xAlign, yAlign)

	local u, v = draw.SimpleText("A", font, 200, 200, color, xAlign, yAlign)
	surface.SetDrawColor(255, 0, 0, 150)
	surface.DrawRect(200, 200, u, v)
end

function ix.util.GenerateIdempKey()
	local idempKey = ""
	for i=1, 32 do
		idempKey = idempKey..util.Base64Encode(math.random(63))
	end
	return idempKey
end

ix.sentences = {
	passivedispatch = {
		prefix = "npc/overwatch/radiovoice/",

		random = {
			location = {"404zone", "canalblock", "stationblock", "transitblock", "workforceintake", "stormsystem", "wasteriver", "deservicedarea", "industrialzone", "restrictedblock", "repurposedarea", "condemnedzone", "residentialblock", "distributionblock", "productionblock", "highpriorityregion", "terminalrestrictionzone", "controlsection"},
			punishment = {"permanentoffworld", "immediateamputation", "halfreproductioncredits", "halfrankpoints", "disassociationfromcivic"},
		},

		sentences = {

			METROPOLICE_IDLE_CHECK3 = {
				sounds = {"on3", "teamsreportstatus", "off2"}
			},

			METROPOLICE_KILL_PLAYER6 = {
				sounds = {"on3", "rewardnotice", "off2"},
			},

			METROPOLICE_REMINDERCREDITS = {
				sounds = {"on3", "reminder100credits", "off2"},
			},

			METROPOLICE_DATACONFLICT = {
				sounds = {"on3", "recievingconflictingdata", "_comma", "recalibratesocioscan", "off2"},
			},

			METROPOLICE_NOACTIVITY = {
				sounds = {"on3", "airwatchcopiesnoactivity", "off2"},
			},
			
			METROPOLICE_FATIGUERATION = {
				sounds = {"on3", "antifatigueration3mg", "off2"},
			},

			METROPOLICE_BODYCOUNT = {
				sounds = {"on3", "leadersreportratios", "off2"},
			},

			METROPOLICE_CLOSINGSUSPECT = {
				sounds = {"on3", "officerclosingonsuspect", "prepareforfinalsentencing", "off2"},
			},

			METROPOLICE_VISUALDOWNLOAD = {
				sounds = {"on3", "preparevisualdownload", "off2"},
			},

			METROPOLICE_OPERATINGAREA = {
				sounds = {"on3", "accomplicesoperating", "off2"},
			},
			
			METROPOLICE_RECALLRECYCLE = {
				sounds = {"on3", "failuretotreatoutbreak", "off2"},
			},

			METROPOLICE_STAMARGINAL = {
				sounds = {"on3", "failuretotreatoutbreak", "off2"},
			},

			METROPOLICE_PREMATURETERM = {
				sounds = {"on3", "attention", "allunitsat", "RAND_location", "_comma", "prematuremissiontermination", "RAND_punishment", "off2"},
			},

			METROPOLICE_SOCIALFRACTURE = {
				sounds = {"on3", "socialfractureinprogress", "off2"},
			},

			METROPOLICE_BOLSUSPECT = {
				sounds = {"on3", "allunitsbolfor243suspect", "off2"},
			},

			METROPOLICE_POLITISTA = {
				sounds = {"on3", "politistablizationmarginal", "off2"},
			},

			METROPOLICE_RADIOIDLE1 = {
				sounds = {"npc/combine_soldier/vo/prison_soldier_activatecentral.wav"}
			},

			METROPOLICE_RADIOIDLE2 = {
				sounds = {"npc/combine_soldier/vo/prison_soldier_boomersinbound.wav"}
			},

			METROPOLICE_RADIOIDLE3 = {
				sounds = {"npc/combine_soldier/vo/prison_soldier_bunker1.wav"}
			},

			METROPOLICE_RADIOIDLE4 = {
				sounds = {"npc/combine_soldier/vo/prison_soldier_bunker2.wav"}
			},

			METROPOLICE_RADIOIDLE5 = {
				sounds = {"npc/combine_soldier/vo/prison_soldier_bunker3.wav"}
			},

			METROPOLICE_RADIOIDLE6 = {
				sounds = {"npc/combine_soldier/vo/prison_soldier_containd8.wav"}
			},

			METROPOLICE_RADIOIDLE7 = {
				sounds = {"npc/combine_soldier/vo/prison_soldier_negativecontainment.wav"}
			},

			METROPOLICE_RADIOIDLE8 = {
				sounds = {"npc/combine_soldier/vo/prison_soldier_tohighpoints.wav"}
			},

			METROPOLICE_RADIOIDLE9 = {
				sounds = {"npc/combine_soldier/vo/prison_soldier_visceratorsa5.wav"}
			},
		}
		
	}
}

ix.placement = ix.placement or {}
ix.placement.maxRange = 120

local function checkFunc(startPos, lowBound, highBound, axis, direction)
	local endVector = Vector(0, 0, 0)

	local lowBoundAdjusted = lowBound[axis]*direction
	local highBoundAdjusted = highBound[axis]*direction

	endVector = lowBoundAdjusted - highBoundAdjusted

	--render.DrawLine(startPos, startPos + endVector)
	
	return util.TraceLine({
		start = startPos,
		endpos = startPos + endVector
	}).Hit
end

function ix.placement.CanPlace(ply, model, distance, angles)
	local trace = ply:GetEyeTrace()
	local isBlocked = false
	if model != "POSTER" then
		local modelPos = trace.HitPos
		local testModel = ents.Create("prop_physics")
		testModel:SetPos(modelPos)
		testModel:SetAngles(angles)
		testModel:SetModel(model)
		local lowBound, highBound = testModel:GetModelBounds()
		local forward, right, up = testModel:GetForward(), testModel:GetRight(), testModel:GetUp()
		local axes = {["x"] = forward, ["y"] = right, ["z"] = up} 
		testModel:SetNoDraw(true)

		local trLength = trace.HitPos:Distance(trace.StartPos)
		if trLength > distance then
			local plyPos = ply:GetPos()
			local normal = trace.Normal
			normal.z = 0
			modelPos = plyPos + normal*distance
		end

		if !util.QuickTrace(modelPos, Vector(0, 0, -1)).Hit then
			isBlocked = true
		end

		modelPos = modelPos + Vector(0, 0, -lowBound.z)

		local startPosLow = modelPos + lowBound.x*forward + lowBound.y*right + lowBound.z*up
		local startPosHigh = modelPos + highBound.x*forward + highBound.y*right + highBound.z*up

		for k, v in pairs(axes) do
			if isBlocked then break end
			isBlocked = checkFunc(startPosLow, -lowBound, -highBound, k, v)
		end

		if !isBlocked then
			for k, v in pairs(axes) do
				if isBlocked then break end
				isBlocked = checkFunc(startPosHigh, lowBound, highBound, k, v)
			end

		end

		testModel:Remove()
	else
		local angle = trace.HitNormal:Angle()
		local scale = 0.15
		local imgW = ply:GetLocalVar("imgW", 256)
		local imgH = ply:GetLocalVar("imgH", 586)

		local imgWScaled, imgHScaled = imgW*scale, imgH*scale
		
		local posterRight, posterUp, posterBack = angle:Right()*-imgWScaled, angle:Up()*-imgHScaled, -angle:Forward()

		local posterMin = -posterRight - posterUp
		posterMin:Mul(1/-2)

		local origin = trace.HitPos - posterMin

		isBlocked = angle.x != 0 or angle.z != 0 or !trace.HitWorld

		if !isBlocked then
			local traces = {
				{origin, 1*posterRight, true},
				{origin,  1*posterUp, true},
				{origin, posterBack, false}, -- top left
				{origin + posterRight, posterBack, false}, -- top right 
				{origin + posterUp, posterBack, false}, -- bottom left
				{origin + posterUp + posterRight, posterBack, false} -- bottom right
			}

			local function checkFunc(origin, distance, checkBool)
				return util.QuickTrace(origin, distance).HitWorld == checkBool
			end

			for k, v in ipairs(traces) do
				if isBlocked then break end
				isBlocked = checkFunc(v[1], v[2], v[3])
			end
		end
	end

	return !isBlocked
end


if SERVER then

	function ix.placement.GetPlacePos(ply, model, distance, angles)
		local trace = ply:GetEyeTrace()
		local modelPos = trace.HitPos

		if model != "POSTER" then
			local testModel = ents.Create("prop_physics")
			testModel:SetPos(modelPos)
			testModel:SetAngles(angles)
			testModel:SetModel(model)
			testModel:SetNoDraw(true)
			testModel:Spawn()
			local lowBound, highBound = testModel:GetModelBounds()
			local forward, right, up = testModel:GetForward(), testModel:GetRight(), testModel:GetUp()
			local axes = {["x"] = forward, ["y"] = right, ["z"] = up} 

			local trLength = trace.HitPos:Distance(trace.StartPos)
			if trLength > distance then
				local plyPos = ply:GetPos()
				local normal = trace.Normal
				normal.z = 0
				modelPos = plyPos + normal*distance
			end

			local isBlocked = false

			modelPos = modelPos + Vector(0, 0, -lowBound.z)

			print(lowBound.x, lowBound.y, lowBound.z)

			testModel:Remove()
		end
		

		return modelPos
	end

	function ix.placement.StartPlacing(ply, itemID)
		local idempKey = ix.util.GenerateIdempKey()
		local item = ix.item.instances[itemID]
		ix.placement.removalMarked = false
		ply:SetLocalVar("IsPlacing", true)
		print("placementmodel", ix.item.list[item.uniqueID].placementModel)
		
		if item.base == "base_poster" or item.base == "poster" or string.find(item.name, "Poster") then
			ply:SetLocalVar("PlacementModel", "POSTER")
			ply:SetLocalVar("imgW", item.imgW)
			ply:SetLocalVar("imgH", item.imgH)
		else
			ply:SetLocalVar("PlacementModel", ix.item.list[item.uniqueID].placementModel or item.model)
			ply:SetLocalVar("PlacingContainer", item.container or false)
		end
		
		ply:SetLocalVar("PlacementIdempKey", idempKey)
		ply:SetLocalVar("PlacementItemID", itemID)
	end

	net.Receive("ixObjectPlace", function(len, ply)
		local idempKey = net.ReadString()
		local itemID = ply:GetLocalVar("PlacementItemID", nil)
		local distance = net.ReadInt(32)
		local p, y, x = net.ReadInt(32), net.ReadInt(32), net.ReadInt(32)
		local angles = Angle(p, y, x)

		local expIdempKey = ply:GetLocalVar("PlacementIdempKey")

		if idempKey != expIdempKey or expIdempKey == nil then
			return
		end

		if CurTime() < ply:GetLocalVar("NextPlacementReq", -1) then
			return
		end

		ply:SetLocalVar("NextPlacementReq", CurTime() + 0.25)

		if ply:GetLocalVar("IsPlacing") == false then 
			ply:Notify("You are not placing anything!")
			return
		end

		if itemID == nil then
			ply:Notify("That is not a valid item!")
			return
		end

		local item = ix.item.instances[itemID]
		if !item then
			-- we don't want to differentiate here, a generic message increases security.
			ply:Notify("You do not own that item!")
			return
		end

		local model = ply:GetLocalVar("PlacementModel")

		local trace = ply:GetEyeTrace()
		if (model != "POSTER" and (distance > ix.placement.maxRange or distance < 50)) or (model == "POSTER" and trace.StartPos:Distance(trace.HitPos) > ix.placement.maxRange) then
			ply:Notify("You cannot place that there!")
			return
		end

		if !ix.placement.CanPlace(ply, model, distance, angles) then
			ply:Notify("You cannot place that there!")
			return
		end

		if item:GetOwner() != ply then
			ply:Notify("That is not a valid item!")
			return
		end

		if !item.functions.place then
			ply:Notify("That item cannot be placed!")
			return
		end

		local placePos = ix.placement.GetPlacePos(ply, model, distance, angles)

		local placedEnt

		if item.placedEnt == nil and model != "POSTER" then
			print("made it to this part")
			placedEnt = ents.Create("prop_physics")
			placedEnt:SetModel(model)
			placedEnt:Spawn()
			placedEnt:SetPos(placePos)
			placedEnt:SetAngles(angles)
			placedEnt:GetPhysicsObject():EnableMotion(false)
			placedEnt:SetVar("PlacedInHelix", true)
			placedEnt:EmitSound(util.GetSurfaceData(util.GetSurfaceIndex(placedEnt:GetBoneSurfaceProp(0))).impactHardSound)

			item:Remove()
		elseif item.placedEnt != nil and model != "POSTER" then
			local class = item.placedEnt
			placedEnt = ents.Create(class)
			placedEnt:SetPos(placePos)
			placedEnt:SetAngles(angles)
			placedEnt:Spawn()
			placedEnt:GetPhysicsObject():EnableMotion(false)
			placedEnt:EmitSound(util.GetSurfaceData(util.GetSurfaceIndex(placedEnt:GetBoneSurfaceProp(0))).impactHardSound)

			item:Remove()
		elseif model == "POSTER" then
			placedEnt = ents.Create("ix_poster")
			placedEnt:SetPos(placePos)
			placedEnt:SetAngles(trace.HitNormal:Angle():Forward():Angle())
			placedEnt:Spawn()
			placedEnt:SetImage(item.textureName)
			local posterSounds = {"physics/cardboard/cardboard_box_impact_bullet1.wav", "physics/cardboard/cardboard_box_impact_bullet2.wav", "physics/cardboard/cardboard_box_break3.wav"}
			placedEnt:EmitSound(posterSounds[math.random(1, #posterSounds)])

			item:Remove()
		end

		ply:SetLocalVar("IsPlacing", false)
	end)

	net.Receive("ixStopPlacement", function(len, ply)
		ply:SetLocalVar("IsPlacing", false)
	end)
end

if CLIENT then
	ix.placement.curAngle = Angle(0, 0, 0)
	ix.placement.curDistance = ix.placement.maxRange
	ix.placement.model = ix.placement.model or nil
	
	ix.placement.animDone = nil
	ix.placement.snapAnimStart = nil
	ix.placement.snapAnimGoal = nil
	ix.placement.animStart = nil
	ix.placement.snapAnimating = false
	
	local openColor = Color(0, 255, 0, 75)
	local blockedColor = Color(255, 0, 0, 75)

	local posterScale = 0.15

	local renderMat = Material( "debug/debugtranslucentsinglecolor" )
	hook.Remove("PreDrawViewModel", "DrawPlacement")
	hook.Add("PostDrawTranslucentRenderables", "DrawPlacement", function(drawingDepth, drawingSkybox, draw3DSkybox)
		local ply = LocalPlayer()
		if ply:GetLocalVar("IsPlacing", false) then
			local placementModel = ply:GetLocalVar("PlacementModel")
			local trace = ply:GetEyeTrace()
			
			local modelValid = IsValid(ix.placement.model)
			if !modelValid and placementModel != "POSTER" then
				ix.placement.model = ClientsideModel(placementModel, RENDERGROUP_TRANSLUCENT)
				ix.placement.model:SetRenderMode( RENDERMODE_TRANSCOLOR )
				ix.placement.model:SetMaterial("debug/debugdrawflat")
				ix.placement.model:SetColor(openColor)
				ix.placement.model:SetNoDraw(false)
				ix.placement.model:SetVar("IdempKey", ply:GetLocalVar("PlacementIdempKey"))

				ix.placement.lastViewAngle = nil

				ix.placement.curAngle = Angle(0, 180 + ply:GetAngles().y, 0)
				ix.placement.curDistance = ix.placement.maxRange
			elseif placementModel != "POSTER" and ply:GetLocalVar("PlacementIdempKey") != ix.placement.model:GetVar("IdempKey") then
				ix.placement.model:Remove()
				ix.placement.model = nil
				return
			end

			if placementModel != "POSTER" then
				render.ResetModelLighting(1, 1, 1)

				local modelPos = trace.HitPos
				local lowBound, highBound = ix.placement.model:GetModelBounds()

				--debugoverlay.Axis(modelPos + (lowBound + highBound)/2 + Vector(0, highBound.z/2, 0), Angle(0, 0, 0), 10, 0)

				local forward, right, up = ix.placement.model:GetForward(), ix.placement.model:GetRight(), ix.placement.model:GetUp()

				local axes = {["x"] = forward, ["y"] = right, ["z"] = up} 

				--lowBound = forward*lowBound.x + right*lowBound.y + up*lowBound.z 
				
				--highBound = forward*highBound.x + right*highBound.y + up*highBound.z

				local isBlocked = false
				
				local trLength = trace.HitPos:Distance(trace.StartPos)
				if trLength > ix.placement.curDistance then
					local plyPos = ply:GetPos()
					local normal = trace.Normal
					normal.z = 0
					modelPos = plyPos + normal*ix.placement.curDistance
				end

				if !util.QuickTrace(modelPos, Vector(0, 0, -0.1)).Hit then
					isBlocked = true
				end

				-- Keep this AFTER the above quicktrace, because otherwise the origin of the trace could be well above the actual ground position of the model. 
				modelPos = modelPos + Vector(0, 0, -lowBound.z)

				local startPosLow = modelPos + lowBound.x*forward + lowBound.y*right + lowBound.z*up
				local startPosHigh = modelPos + highBound.x*forward + highBound.y*right + highBound.z*up
				
				ix.placement.model:SetPos(modelPos)
				ix.placement.model:SetAngles(ix.placement.curAngle)

				for k, v in pairs(axes) do
					if isBlocked then break end
					isBlocked = checkFunc(startPosLow, -lowBound, -highBound, k, v)
				end

				if !isBlocked then
					for k, v in pairs(axes) do
						if isBlocked then break end
						isBlocked = checkFunc(startPosHigh, lowBound, highBound, k, v)
					end

				end

				if isBlocked then
					ix.placement.model:SetColor(blockedColor)
				else
					ix.placement.model:SetColor(openColor)
				end

				--traceStartPos = 
				--render.DrawLine(traceStartPos, traceStartPos + )

				ix.placement.model:DrawModel(STUDIO_DRAWTRANSLUCENTSUBMODELS)

				
			else
				local angle = trace.HitNormal:Angle()
				if angle.x == 0 and angle.z == 0 and trace.HitWorld and trace.HitPos:Distance(trace.StartPos) <= ix.placement.maxRange then
					local scale = 0.15
					local imgW = ply:GetLocalVar("imgW", 256)
					local imgH = ply:GetLocalVar("imgH", 586)

					local imgWScaled, imgHScaled = imgW*scale, imgH*scale
					
					local posterRight, posterUp, posterBack = angle:Right()*-imgWScaled, angle:Up()*-imgHScaled, -angle:Forward()

					local posterMin = -posterRight - posterUp
					posterMin:Mul(1/-2)

					local origin = trace.HitPos - posterMin
					
					local traces = {
						{origin, 1*posterRight, true},
						{origin,  1*posterUp, true},
						{origin, posterBack, false}, -- top left
						{origin + posterRight, posterBack, false}, -- top right 
						{origin + posterUp, posterBack, false}, -- bottom left
						{origin + posterUp + posterRight, posterBack, false} -- bottom right
					}

					local function checkFunc(origin, distance, checkBool)
						return util.QuickTrace(origin, distance).HitWorld == checkBool
					end

					local isBlocked = false

					for k, v in ipairs(traces) do
						if isBlocked then break end
						isBlocked = checkFunc(v[1], v[2], v[3])
					end

					if isBlocked then
						drawColor = blockedColor
					else
						drawColor = openColor
					end

					cam.IgnoreZ(true)
						cam.Start3D2D(trace.HitPos - posterMin, angle + Angle(0, 90, 90), scale)
							surface.SetDrawColor(drawColor)
							surface.DrawRect(0, 0, imgW, imgH)
						cam.End3D2D()
					cam.IgnoreZ(false)
				end
			end
		end	
	end)

	hook.Add("InputMouseApply", "PlacementControls", function(cmd, x, y, ang)
		local ply = LocalPlayer()
		if ply:GetLocalVar("IsPlacing", false) then
			if IsValid(ix.placement.model) then
				local viewAngles = cmd:GetViewAngles()
				if ix.placement.lastViewAngle then
					ix.placement.curAngle = ix.placement.curAngle - Angle(0, ix.placement.lastViewAngle.y - viewAngles.y, 0)
				end
				ix.placement.lastViewAngle = viewAngles

				local walkDown = ply:KeyDown(IN_WALK) 
				local scale = walkDown and 3 or 8
				ix.placement.curDistance = math.Clamp(ix.placement.curDistance + cmd:GetMouseWheel() * scale, 50, ix.placement.maxRange)
				if input.IsButtonDown(MOUSE_LEFT) then	
					if walkDown and (ix.placement.nextSnap == -1 or ix.placement.nextSnap == nil or CurTime() > ix.placement.nextSnap) then
						ix.placement.curAngle = ix.placement.curAngle + Angle(0, -45, 0)
						ix.placement.curAngle:SnapTo("y", 45)
						ix.placement.nextSnap = CurTime() + 0.25
						
					elseif !walkDown then
						ix.placement.curAngle = ix.placement.curAngle + Angle(0, -1, 0)
					end
				elseif input.IsButtonDown(MOUSE_RIGHT) then
					if walkDown and (ix.placement.nextSnap == -1 or ix.placement.nextSnap == nil or CurTime() > ix.placement.nextSnap) then
						ix.placement.curAngle = ix.placement.curAngle + Angle(0, 45, 0)
						ix.placement.curAngle:SnapTo("y", 45)
						ix.placement.nextSnap = CurTime() + 0.25
					elseif !walkDown then
						ix.placement.curAngle = ix.placement.curAngle + Angle(0, 1, 0)
					end
				else
					ix.placement.nextSnap = -1
				end
			end

			if input.WasKeyReleased(input.GetKeyCode(input.LookupBinding("+use"))) then
				local model = ply:GetLocalVar("PlacementModel")
				if !IsValid(ix.placement.model) and model != "POSTER" then return end
				
				if model != "POSTER" then
				
					ix.placement.model:SetColor(Color(255, 255, 255, 0))
					ix.placement.model:SetNoDraw(true)
					ix.placement.removalMarked = true
				end

				local ply = LocalPlayer()
				local walkDown = ply:KeyDown(IN_WALK) 
				local idempKey = ply:GetLocalVar("PlacementIdempKey")

				
				if !walkDown then
					if idempKey then
						net.Start("ixObjectPlace")
							net.WriteString(idempKey)
							net.WriteInt(ix.placement.curDistance, 32)
							net.WriteInt(ix.placement.curAngle.x, 32)
							net.WriteInt(ix.placement.curAngle.y, 32)
							net.WriteInt(ix.placement.curAngle.z, 32)
						net.SendToServer()

						if !ix.placement.CanPlace(ply, model, ix.placement.curDistance, ix.placement.curAngle) then
							ply:EmitSound("common/wpn_denyselect.wav")
						end
					end
				else
					ply:EmitSound("common/wpn_select.wav")
					net.Start("ixStopPlacement")
					net.SendToServer()
				end
			end
		end
	end)

	hook.Add("Tick", "PlacementCloseOpen", function()
		
	end)
end

ix.char.RegisterVar("attributes", {
	field = "attributes",
	fieldType = ix.type.text,
	default = {},
	index = 4,
	category = "attributes",
	isLocal = true,
	OnDisplay = function(self, container, payload)
		local maximum = hook.Run("GetDefaultAttributePoints", LocalPlayer(), payload) or 10

		if (maximum < 1) then
			return
		end

		local attributes = container:Add("DPanel")
		attributes:Dock(TOP)

		local y
		local total = 0

		payload.attributes = {}

		-- total spendable attribute points
		local totalBar = attributes:Add("ixAttributeBar")
		totalBar:SetMax(maximum)
		totalBar:SetValue(maximum)
		totalBar:Dock(TOP)
		totalBar:DockMargin(2, 2, 2, 2)
		totalBar:SetText(L("attribPointsLeft"))
		totalBar:SetReadOnly(true)
		totalBar:SetColor(Color(20, 120, 20, 255))

		y = totalBar:GetTall() + 4

		for k, v in SortedPairsByMemberValue(ix.attributes.list, "name") do
			payload.attributes[k] = 0

			local bar = attributes:Add("ixAttributeBar")
			bar:SetMax(maximum)
			bar:Dock(TOP)
			bar:DockMargin(2, 2, 2, 2)
			bar:SetText(L(v.name))
			bar.OnChanged = function(this, difference)
				if ((total + difference) > maximum) then
					return false
				end

				total = total + difference
				payload.attributes[k] = payload.attributes[k] + difference

				totalBar:SetValue(totalBar.value - difference)
			end

			if (v.noStartBonus) then
				bar:SetReadOnly()
			end

			y = y + bar:GetTall() + 4
		end

		attributes:SetTall(y)
		return attributes
	end,
	OnValidate = function(self, value, data, client)
		if (value != nil) then
			if (istable(value)) then
				local count = 0

				for _, v in pairs(value) do
					count = count + v
				end
				

				if (count > table.Count(ix.attributes.list)*5 + ix.attributes.creationPoints) then
					return false, "unknownError"
				end
			else
				return false, "unknownError"
			end
		end
	end,
	ShouldDisplay = function(self, container, payload)
		return !table.IsEmpty(ix.attributes.list)
	end
})

ix.config.Add("cityNumber", "C17", "The city identifier used by the local Combine units.", nil, {
	["category"] = "HL2RP"
}, false, true)

ix.config.Add("maxBleedTime", 30, "The maximum amount of time a player bleeds for.", nil, {
	["category"] = "Health",
	["type"] = ix.type.number,
	["data"] = {["min"] = 1, ["max"] = 180}
}, false, false)

ix.config.Add("bleedRate", 2, "The rate at which a player bleeds. Measured in seconds/health.", nil, {
	["category"] = "Health",
	["type"] = ix.type.number,
	["data"] = {["min"] = 1, ["max"] = 10}
}, false, false)

ix.ranks = {}

ix.ranks.CCA = {
	["RCT"] = 0,
	["i5"] = 1,
	["i4"] = 2,
	["i3"] = 3,
	["i2"] = 4,
	["i1"]= 5,
	["EpU"] = 6,
	["SqL"] = 7,
	["OfC"] = 8,
	["DvL"] = 9,
	["CmD"] = 10,
	["SeC"] = 11
}

ix.ranks.OTA = {
	["OHZ"] = 1,
	["OWS"] = 2,
	["OAS"] = 3,
	["OSS"] = 3,
	["EOS"] = 4, 
	["ORD"] = 5,
	["EOA"] = 6
}

ix.ranks.CONSCRIPT = {
	["RCT"] = 0,
	["PVT"] = 1,
	["PFC"] = 2,
	["LCPL"] = 3,
	["CPL"] = 4,
	["SGT"] = 5,
	["SSGT"] = 6,
	["GSGT"] = 7,
	["SGTM"] = 8,
	["2LT"] = 9,
	["1LT"] = 10,
	["CPT"] = 11
}
 
function ix.util.AlphabetizeByMember(tab, key)
	local tableCopy = table.Copy(tab)
	tableCopy = table.ClearKeys(tableCopy)
	table.sort(tableCopy, function(a, b)
		local aByte, bByte = {string.byte(string.lower(a[key]), 1,#a[key])}, {string.byte(string.lower(b[key]), 1, #b[key])}
		if #aByte > #bByte then
			for k, v in ipairs(bByte) do
				if aByte[k] == bByte[k] then
					continue
				else
					return aByte[k] < bByte[k]
				end 
			end
		else
			for k, v in ipairs(aByte) do
				if aByte[k] == bByte[k] then
					continue
				else
					return aByte[k] < bByte[k]
				end 
			end
		end
	end)

	return tableCopy
end

function ix.util.StartsWithVowel(str)
	local letter = string.lower(string.sub(str, 1, 1))
	return letter == "a" or letter == "e" or letter == "i" or letter == "o" or letter == "u"
end

function ix.util.WeightedRandom(choices)
	local weightSum = 0
	for choice, weight in pairs(choices) do
		weightSum = weightSum + weight
	end

	local randomNum = math.random(0, weightSum - 1)
	
	for choice, weight in pairs(choices) do
		print("loop", choice, weight)
		if randomNum < weight then 
			return choice
		else
			randomNum = randomNum - weight
		end
	end

	error("something went wrong")
end

local invMeta = ix.meta.inventory

function invMeta:GetUsableItemProperty(property)
	local items = self:GetItems()

	local possibleItems = {}
	for _, item in ipairs(items) do
		if item[property] then
			if !item.limitedUses then return item end 
			possibleItems[#possibleItems + 1] = item
		end
	end

	for _, item in ipairs(possibleItems) do
		if !item:GetData("UsesLeft") > 0 then
			return item
		end
	end
end

function ix.util.EmitSentence(entity, sentenceGroup, sentence, delay, spacing, volume, pitch)
	local sounds = {}
	local groupTable = ix.sentences[sentenceGroup]
	local prefix = groupTable.prefix


	for index, phrase in ipairs(sentence.sounds) do
		local split = string.Explode("RAND_", phrase)

		if #split > 1 then
			phrase = table.Random(groupTable.random[split[2]])
		end

		sounds[#sounds + 1] = prefix..phrase..".wav"
	end

	
	return ix.util.EmitQueuedSounds(entity, sounds, delay, spacing, volume, pitch)
end



function ix.util.ToTitleCase(str)
	local strSplit = string.Explode(" ", str)
	
	str = ""
	for k, v in ipairs(strSplit) do
		str = str..string.upper(string.sub(v, 1, 1))..string.sub(v, 2)
		if k != #strSplit then str = str.." " end
	end

	strSplit = string.Explode("-", str)
	local newString = ""
	for k, v in ipairs(strSplit) do
		newString = newString..string.upper(string.sub(v, 1, 1))..string.sub(v, 2)
		if k != #strSplit then newString = newString.."-" end
	end

	return newString
end

function Schema: ber(number, length)
	local amount = math.max(0, length - string.len(number))
	return string.rep("0", amount)..tostring(number)
end

function Schema:IsCombineRank(text, rank)
	return string.find(text, "[%D+]"..rank.."[%D+]")
end



ix.anim.SetModelClass("models/eliteghostcp.mdl", "metrocop")
ix.anim.SetModelClass("models/eliteshockcp.mdl", "metrocop")
ix.anim.SetModelClass("models/leet_police2.mdl", "metrocop")
ix.anim.SetModelClass("models/sect_police2.mdl", "metrocop")
ix.anim.SetModelClass("models/policetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/cultist/hl_a/combine_grunt/combine_grunt.mdl", "player")
ix.anim.SetModelClass("models/assassin/fassassin.mdl", "player")
ix.anim.SetModelClass("models/cultist/hl_a/metropolice/metrocop.mdl", "player")
ix.anim.SetModelClass("models/cultist/hl_a/worker/hazmat_1/hazmat_1.mdl", "player")
ix.anim.SetModelClass("models/characters/combine_soldier/jqblk/combine_s_super.mdl", "player")
ix.anim.SetModelClass("models/cultist/hl_a/vannila_combine/combine_soldier.mdl", "player")
ix.anim.SetModelClass("models/cultist/hl_a/combine_commander/combine_commander.mdl", "player")
ix.anim.SetModelClass("models/combine_soldiers_redone_playermodels/combine_elite_soldier_redone.mdl", "player")
ix.anim.SetModelClass("models/cultist/hl_a/worker/hazmat_2/hazmat_2.mdl", "player")
ix.anim.SetModelClass("models/hlvr/characters/combine/heavy/combine_heavy_hlvr_player.mdl", "player")
ix.anim.SetModelClass("models/synth/elite_brown_pm.mdl", "player")
ix.anim.SetModelClass("models/hlvr/characters/hazmat_worker/hazmat_worker_player.mdl", "player")
ix.anim.SetModelClass("models/hlvr/characters/worker/worker_player.mdl", "player")
ix.anim.SetModelClass("models/dpfilms/metropolice/tribal_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/arctic_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/badass_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/biopolice.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/blacop.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/c08cop.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/civil_medic.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/female_police.mdl", "metrocop")
ix.anim.SetModelClass("models/vortigaunt_blue_ep2anims.mdl", "vortigaunt")
ix.anim.SetModelClass("models/projectrevival/vortigaunt_mod.mdl", "vortigaunt")
ix.anim.SetModelClass("models/dpfilms/metropolice/hdpolice.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/hl2beta_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/hunter_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/hl2concept.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/phoenix_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/resistance_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/retrocop.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/rogue_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/rtb_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/steampunk_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/tf2_metrocop.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/tron_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/urban_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/arcice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/arcicetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/arcte_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/betice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/beticetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/bette_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/bioice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/bioicetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/biote_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/blaice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/blaicetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/blate_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/c08ice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/c08icetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/c08te_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/eliicetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/elite_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/frgicetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/frgte_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/hdite_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/hunice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/hunicetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/hunte_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/medice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/medicetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/medte_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/phoice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/phoicetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/phote_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/police_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/police_fragger.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/policetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/retice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/reticetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/rette_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/rogice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/rogicetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/rogte_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/steice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/steicetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/stete_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/triice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/triicetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/trite_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/troice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/troicetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/trote_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/urbice_bt.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/urbicetrench.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/urbte_police.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/zomice_bt.mdl", "zombie")
ix.anim.SetModelClass("models/dpfilms/metropolice/zomicetrench.mdl", "zombie")
ix.anim.SetModelClass("models/dpfilms/metropolice/zomte_police.mdl", "zombie")
ix.anim.SetModelClass("models/ma/hla/metropolice.mdl", "metrocop")
ix.anim.SetModelClass("models/hlvr/characters/combine/grunt/combine_grunt_hlvr_player.mdl", "player")
ix.anim.SetModelClass("models/hlvr/characters/combine_captain/combine_captain_hlvr_player.mdl", "player")
ix.anim.SetModelClass("models/player/female_02_suit.mdl", "citizen_female")
ix.anim.SetModelClass("models/hlvr/characters/combine/grunt/combine_grunt_hlvr_npc.mdl", "overwatch")
ix.anim.SetModelClass("models/dpfilms/metropolice/zombie_police.mdl", "zombie")
ix.anim.SetModelClass("models/hcca/metropolice/elite metropolice.mdl", "metrocop")
ix.anim.SetModelClass("models/dpfilms/metropolice/civil_medic_subtle.mdl", "metrocop")
ix.anim.SetModelClass("models/opfor/strooper.mdl", "strooper")
ix.anim.SetModelClass("models/combine_soldiers_redone_playermodels/combine_soldier_prisonguard_redone.mdl", "player")
ix.anim.SetModelClass("models/ninja/combine/combine_super_soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/cultist/hl_a/vannila_combine/npc/combine_soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/kaesar/hlalyx/gordon/gordon.mdl", "player")
ix.anim.SetModelClass("models/hlvr/characters/combine/suppressor/combine_suppressor_hlvr_npc.mdl", "overwatch")
ix.anim.SetModelClass("models/hlvr/characters/combine_captain/combine_captain_hlvr_npc.mdl", "overwatch")
ix.anim.SetModelClass("models/lenoax/cavejohnson_pm.mdl", "player")
ix.anim.SetModelClass("models/police_nemez.mdl", "metrocop")
ix.anim.SetModelClass("models/jq/hlvr/characters/combine/combine_captain/combine_captain_hlvr_npc.mdl", "overwatch")
ix.anim.SetModelClass("models/jq/hlvr/characters/combine/grunt/combine_grunt_hlvr_npc.mdl", "overwatch")
ix.anim.SetModelClass("models/hlvr/characters/combine/heavy/combine_heavy_hlvr_npc.mdl", "overwatch")
ix.anim.SetModelClass("models/jq/hlvr/characters/combine/suppressor/combine_suppressor_hlvr_npc.mdl", "overwatch")
ix.anim.SetModelClass("models/gonzo/monkcop/monkcop.mdl", "player")
ix.anim.SetModelClass("models/romka/romka_combine_super_soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/romka/romka_combine_soldier.mdl", "overwatch")
ix.anim.SetModelClass("models/romka/rtb_elite.mdl", "overwatch")
ix.anim.SetModelClass("models/elite_synth/elite_synth.mdl", "player")
ix.anim.SetModelClass("models/industrial_uniforms/pm_industrial_uniform.mdl", "player")
ix.anim.SetModelClass("models/industrial_uniforms/pm_industrial_uniform2.mdl", "player")
ix.anim.SetModelClass("models/ccr/auditor/conceptsoldier.mdl", "citizen_male")
ix.anim.SetModelClass("models/nasca/hl2/cmb/male_cp_penal1.mdl", "metrocop")
ix.anim.SetModelClass("models/nasca/hl2/cmb/male_cp_penal2.mdl", "metrocop")
ix.anim.SetModelClass("models/nasca/hl2/cmb/male_cp_penal3.mdl", "metrocop")
ix.anim.SetModelClass("models/nasca/hl2/cmb/male_cp_penal4.mdl", "metrocop")

VORTESSENCE_REGEN_RATE = 3 -- This is a per second rate.
MAXVORTESSENCE = 200
VORTILAMPCONSUMPRATE = 0 -- This is a per second rate.
VORTALEYECONSUMPRATE = VORTESSENCE_REGEN_RATE + 8 -- This is a per second rate.
VORTHEALCONSUMPRATE = VORTESSENCE_REGEN_RATE + 5 -- This is a per second rate.
VORTHEALRATE = 5 -- this is a per second rate

ix.char.RegisterVar("Vortessence", {
	field = "vortessence",
	fieldType = ix.type.number,
	default = 0,
	bNoDisplay = true,
})

ix.char.RegisterVar("MaxVortessence", {
	field = "MaxVortessence",
	fieldType = ix.type.number,
	default = 200,
	bNoDisplay = true,
})


function Schema:ZeroNumber(number, length)
	local amount = math.max(0, length - string.len(number))
	return string.rep("0", amount)..tostring(number)
end

function Schema:HasBiosignalRank(text, rank)
	return string.find(text, "[%D+]"..rank.."[%D+]")
end



do
	local CLASSES = {}

	CLASSES.CLASS_MPGU = {
		["uniqueID"] = "metropolice_groundunit",
		["name"] = "Metropolice Ground Unit",
		["description"] = "A CCA ground unit.",
		["defaultArmor"] = 50,
		["faction"] = FACTION_MPF,
		["ranks"] = {"i5", "i4", "i3", "i2", "i1"}
	}

	CLASSES.CLASS_MPFC = {
		["uniqueID"] = "metropolice_fieldcommand",
		["name"] = "Metropolice Field Command",
		["description"] = "A CCA field command unit.",
		["defaultArmor"] = 100,
		["faction"] = FACTION_MPF,
		["ranks"] = {"EpU", "SqL"}
	}

	CLASSES.CLASS_MPC = {
		["uniqueID"] = "metropolice_command",
		["name"] = "Metropolice Command",
		["description"] = "A CCA command unit.",
		["defaultArmor"] = 150,
		["faction"] = FACTION_MPF,
		["ranks"] = {"OfC", "DvL"}
	}

	CLASSES.CLASS_MPHC = {
		["uniqueID"] = "metropolice_highcommand",
		["name"] = "Metropolice High Command",
		["description"] = "A CCA high command unit.",
		["defaultArmor"] = 200,
		["faction"] = FACTION_MPF,
		["ranks"] = {"CmD", "SeC"}
	}

	CLASSES.CLASS_VORTSLAVE = {
		["uniqueID"] = "cac_vortslave",
		["name"] = "Vortigaunt Slave",
		["description"] = "A vortigaunt slave.",
		["faction"] = FACTION_CAC,
		["weapons"] = {"weapon_broom"}
	}

	CLASSES.CLASS_FREEVORT = {
		name = "Free Vortigaunt",
		description = "A free vortigaunt.",
		defaultArmor = 0,
		faction = FACTION_ALIEN, 
		limit = 0,
		weapons = {"weapon_vortswep"}
	}

	CLASSES.CLASS_CHUMTOAD = {
		name = "Chumtoad",
		description = "A chumtoad.",
		defaultArmor = 0,
		faction = FACTION_ALIEN, 
		limit = 0
	}

	for k, v in pairs(CLASSES) do
		local CLASS = {
			["uniqueID"] = v.uniqueID or k,
			["name"] = v.name,
			["description"] = v.description,
			["defaultArmor"] = v.defaultArmor or 0,
			["faction"] = v.faction,
			["ranks"] = v.ranks or nil,
			["limit"] = 0 or nil,
			["isDefault"] = true,
			["CanSwitchTo"]	= v.CanSwitchTo or function() return true end,
			["weapons"] = v.weapons or nil
		}

		local index = #ix.class.list + 1

		CLASS.index = index
		
		if k == "CLASS_MPGU" then
			CLASS_MPGU = index
		elseif k == "CLASS_MPFC" then
			CLASs_MPFC = index
		elseif k == "CLASS_MPC" then
			CLASS_MPC = index
		elseif k == "CLASS_MPHC" then
			CLASS_MPHC = index
		elseif k == "CLASS_VORTSLAVE" then
			CLASS_VORTSLAVE = index
		elseif k == "CLASS_FREEVORT" then
			CLASS_FREEVORT = index
		end

		ix.class.list[index] = CLASS
	end
end

function Schema:AlphaNum(text)
	if text == "1" then
		return "one"
	elseif text == "2" then
		return "two"
	elseif text == "3" then
		return "three"
	elseif text == "4" then
		return "four"
	elseif text == "5" then 
		return "five"
	elseif text == "6" then
		return "six"
	elseif text == "7" then
		return "seven"
	elseif text == "8" then
		return "eight"
	elseif text == "9" then
		return "nine"
	elseif text == "0" then
		return "zero"
	else
		return
	end
end

local entityMeta = FindMetaTable("Entity")

function entityMeta:HasAlienModel()
	return false
end


function Schema:AlphaNum(text)
	local convTable = {
		["1"] = "one",
		["2"] = "two",
		["3"] = "three",
		["4"] = "four",
		["5"] = "five",
		["6"] = "six",
		["7"] = "seven",
		["8"] = "eight",
		["9"] = "nine",
		["0"] = "zero"
	}
	return convTable[text]
end

-- Returns a color between approximately RGB(255, 0, 0) and RGB(0, 255, 0) corresponding to a health value with red being the lowest health and green being the highest health.
function Schema:GetHealthColor(health, maxHealth)
	local startColor = Color(0, 255, 0)
	local H, S, V = startColor:ToHSV()
	return HSVToColor((H - 115 + math.floor(115*(health/maxHealth))), S, V)
end

function Schema:AddFact(num, inclusive) -- Additive factorial. Ex. AddFact(4, false) = 3 + 2 + 1 
	local sum = 0
	for i = 1, num-1, 1 do
		sum = sum + i
	end
	if inclusive then
		return sum + num
	else
		return sum
	end
end

function Schema:AddFact(num, inclusive) -- Additive factorial. Ex. AddFact(4, false) = 3 + 2 + 1 
	local sum = 0
	for i = 1, num-1, 1 do
		sum = sum + i
	end
	if inclusive then
		return sum + num
	else
		return sum
	end
end

function Schema:GetHealthColor(health, maxHealth)
	local startColor = Color(0, 255, 0)
	local H, S, V = startColor:ToHSV()
	return HSVToColor((H - 115 + math.floor(115*(health/maxHealth))), S, V)
end

function Schema:AddFact(num, inclusive) -- Additive factorial. Ex. AddFact(4, false) = 3 + 2 + 1 
	local sum = 0
	for i = 1, num-1, 1 do
		sum = sum + i
	end
	if inclusive then
		return sum + num
	else
		return sum
	end
end

--concommand.Add("vortigaunttest", )

local iParticleTracers = 0
function util.ParticleEffectTracer(name, posStart, TCPoints, ang, ent, att, flRemoveDelay)
	iParticleTracers = iParticleTracers +1
	local iCheckpoint = 0
	local tblEnts = {}
	local function CreateCheckpoint(TPoint, att)
		iCheckpoint = iCheckpoint +1
		local _ent = ent
		local ent = ents.Create("obj_target")
		if type(TPoint) == "Vector" then ent:SetPos(TPoint)
		else ent:SetPos(TPoint:GetCenter()); ent:SetParent(TPoint) end
		ent:Spawn()
		ent:Activate()
		if att then ent:Fire("SetParentAttachment", att, 0) end
		table.insert(tblEnts, ent)
		
		local cName = "ParticleEffectTracer" .. iParticleTracers .. "_checkpoint" .. iCheckpoint
		ent:SetName(cName)
		if IsValid(_ent) then _ent:DeleteOnRemove(ent) end
		return ent, cName
	end

	local entParticle = ents.Create("info_particle_system")
	entParticle:SetKeyValue("start_active", "1")
	entParticle:SetKeyValue("effect_name", name)
	local cpoints
	if TCPoints then
		local sType = type(TCPoints)
		if sType == "Vector" || sType == "Entity" || sType == "Player" || sType == "NPC" then
			local ent, cName = CreateCheckpoint(TCPoints)
			cpoints = ent
			entParticle:SetKeyValue("cpoint1", cName)
		else
			cpoints = {}
			for k, v in pairs(TCPoints) do
				local TPoint, att
				if type(v) == "table" then
					TPoint = v.ent
					att = v.att
				else TPoint = v end
				local ent, cName = CreateCheckpoint(TPoint, att)
				table.insert(cpoints, ent)
				entParticle:SetKeyValue("cpoint" .. k, cName)
			end
		end
	end
	entParticle:SetAngles(ang)
	entParticle:SetPos(posStart)
	entParticle:Spawn()
	entParticle:Activate()
	if IsValid(ent) then
		entParticle:SetParent(ent)
		ent:DeleteOnRemove(entParticle)
		if att then entParticle:Fire("SetParentAttachment", att, 0) end
	end
	if flRemoveDelay != false then
		flRemoveDelay = flRemoveDelay || 1
		timer.Simple(flRemoveDelay, function()
			if IsValid(entParticle) then
				entParticle:Remove()
			end
			for k, v in pairs(tblEnts) do
				if IsValid(v) then v:Remove() end
			end
		end)
	end
	return entParticle,cpoints
end

function util.ParticleEffect(name, pos, ang, ent, att, flRemoveDelay)
	local entParticle = ents.Create("info_particle_system")
	entParticle:SetKeyValue("start_active", "1")
	entParticle:SetKeyValue("effect_name", name)
	entParticle:SetAngles(ang)
	entParticle:SetPos(pos)
	entParticle:Spawn()
	entParticle:Activate()
	if IsValid(ent) then
		entParticle:SetParent(ent)
		ent:DeleteOnRemove(entParticle)
		if att then entParticle:Fire("SetParentAttachment", att, 0) end
	end
	if flRemoveDelay != false then
		flRemoveDelay = flRemoveDelay || 1
		timer.Simple(flRemoveDelay, function()
			if IsValid(entParticle) then
				entParticle:Remove()
			end
		end)
	end
	return entParticle
end