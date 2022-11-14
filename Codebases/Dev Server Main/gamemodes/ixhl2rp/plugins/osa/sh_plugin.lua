PLUGIN.name = "Overwatch Synthetic Arm"
PLUGIN.author = "QIncarnate"
PLUGIN.description = "Adds a faction for synths."

local CHAR = ix.meta.character

function CHAR:IsSynth()
	local faction = self:GetFaction()
	return faction == FACTION_SYNTH
end

function CHAR:IsSpeakingSynth()
	local class = self:GetClass()
	return class == CLASS_CSS or CLASS_ELITESYNTH
end

/*
ix.chat.Register("Synth", {
	format = "%s says in synth \"%s\"",
	GetColor = function(self, speaker, text)
		-- If you are looking at the speaker, make it greener to easier identify who is talking.
		if (LocalPlayer():GetEyeTrace().Entity == speaker) then
			return ix.config.Get("chatListenColor")
		end

		-- Otherwise, use the normal chat color.
		return ix.config.Get("chatColor")
	end,
	CanHear = ix.config.Get("chatRange", 280),
	CanSay = function(self, speaker,text)
		if (speaker:GetCharacter():IsVortigaunt()) then
			return true
		else
			speaker:NotifyLocalized("You don't know Vortigese!")
			return false
		end
	end,
	OnChatAdd = function(self,speaker, text, anonymous, info)
		local color = self:GetColor(speaker, text, info)
		local name = anonymous and
				L"someone" or hook.Run("GetCharacterName", speaker, chatType) or
				(IsValid(speaker) and speaker:Name() or "Console")
		
		if (!LocalPlayer():GetCharacter():IsVortigaunt()) then
			local splitedText = string.Split(text, " ")
			local vortigese = {}

			for k, v in pairs(splitedText) do
				local word = table.Random(randomVortWords)
				table.insert( vortigese, word )

			end
			PrintTable(vortigese)
			text = table.concat( vortigese, " " )
		end

		chat.AddText(color, string.format(self.format, name, text))
	end,	
	prefix = {"/s", "/synth"},
	description = "Says in synth language.",
	indicator = "chatTalking",
	deadCanChat = false
})
*/

-- Animations, yay!
ix.anim.supersoldier = {
	normal = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_RUN] = {ACT_WALK, ACT_WALK},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		attack = ACT_MELEE_ATTACK1,
		reload = ACT_RELOAD_PISTOL,
		glide = ACT_IDLE
	},
	pistol = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_RUN] = {ACT_WALK, ACT_WALK},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		attack = ACT_RANGE_ATTACK1_LOW,
		glide = ACT_IDLE
	},
	melee = {
		[ACT_MP_STAND_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_CROUCH_IDLE] = {ACT_IDLE, ACT_IDLE},
		[ACT_MP_WALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_CROUCHWALK] = {ACT_WALK, ACT_WALK},
		[ACT_MP_RUN] = {ACT_WALK, ACT_WALK},
		[ACT_LAND] = {ACT_WALK, ACT_WALK},
		attack = ACT_MELEE_ATTACK1,
		glide = ACT_IDLE
	},
}

ix.anim.SetModelClass("models/elite_synth.mdl", "supersoldier")