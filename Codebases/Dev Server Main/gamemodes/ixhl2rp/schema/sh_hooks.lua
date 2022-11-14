-- Client is the sprayer.
function Schema:CanPlayerUseBusiness(client, uniqueID)
	return false
end

-- called when the client wants to view the combine data for the given target
function Schema:CanPlayerViewData(client, target)
	return client:HasBiosignal() and (!target:HasBiosignal() and target:Team() != FACTION_ADMIN)
end

-- called when the client wants to edit the combine data for the given target
function Schema:CanPlayerEditData(client, target)
	return client:HasBiosignal() and (!target:HasBiosignal() and target:Team() != FACTION_ADMIN)
end

function Schema:CanPlayerViewObjectives(client)
	return client:HasBiosignal()
end

function Schema:CanPlayerEditObjectives(client)
	if (!client:HasBiosignal() or !client:GetCharacter()) then
		return falsenet.Receive("prAptResponse", function(len)
					local action = net.ReadUInt(32)
					if action == APTACT_INVALIDTENANT then
						mainPanel:ShowError("That person cannot be assigned an apartment!")
					elseif action == APTACT_TENANTNOEXIST then
						mainPanel:ShowError("That person does not exist!")
					elseif action == APTACT_APTFULL then
						mainPanel:ShowError("That apartment is full!")
					elseif action == APTACT_INVALIDAPT then
						mainPanel:ShowError("That apartment is full!")
					elseif action == APTACT_SVSUCCESS then
						mainPanel:ChangeScreen("mainMenu")
						mainPanel:EmitSound("buttons/button15.wav")
					elseif action == APTACT_BADRANK then
						mainPanel:ShowError("You are not ranked high enough to do this!")
					else
						mainPanel:ShowError("An unknown error occured.")
					end
				end)
	end

	local bCanEdit = false
	local name = client:GetCharacter():GetName()

	for k, v in ipairs({"OfC", "EpU", "DvL", "SeC", "SqL", "CmD"}) do
		if (self:HasBiosignalRank(name, v)) then
			bCanEdit = true
			break
		end
	end

	return bCanEdit
end

function Schema:CanDrive()
	return false
end

function Schema:OnCharacterCreated(client, character)
	local faction = ix.faction.Get(character:GetFaction())

	if (faction == "CITIZEN") then
		//character:SetData(combineData)
	end
end

function Schema:GetCharacterName(speaker, chatType)
	local squadNum
	local char = speaker:GetCharacter()
	for k, v in pairs(squad) do
		print(k, v)
		if v.member == speaker then
			squadNum = k
		end
	end
	if (chatType == "radio" or chatType == "ic" or chatType == "w" or chatType == "y" or chatType == "me") and squad != nil and squadNum and ix.option.Get("showSquadInChat", true) then
		return squad.name.."-"..squadNum
	end
end

function Schema:OnPickupMoney(client, self)

	if ix.faction.Get(client:Team()).name == "Citizen" then -- If the player is a metropolice unit, they play the pistol reload animation.
		client:ForceSequence("pickup", nil, nil, true)
	end
	
end


-- Pickup and drop anims
function Schema:PlayerInteractItem(client, action, item)

	if ix.faction.Get(client:Team()).name == "Citizen" then -- If the player is a metropolice unit, they play the pistol reload animation.

		if action == "take" then 
			client:ForceSequence("pickup", nil, nil, true)
		elseif action == "drop" then 
			client:ForceSequence("heal", nil, nil, true)
		end

	end

end

function Schema:IsCharacterRecognized(char, id)
	local other = ix.char.loaded[id]

	if char:IsCombine() and other:IsCombine() then
		return true
	end
end

function Schema:InitializedChatClasses()
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
end