
-- The shared init file. You'll want to fill out the info for your schema and include any other files that you need.

-- Schema info
Schema.name = "PROJECT REVIVAL DEV SERVER"
Schema.author = "QIncarnate & Nebulous"
Schema.description = "A roleplay schema based on Star Wars."

ix.currency.symbol = ""
ix.currency.singular = "credit"
ix.currency.plural = "credits"

-- Additional files that aren't auto-included should be included here. Note that ix.util.Include will take care of properly
-- using AddCSLuaFile, given that your files have the proper naming scheme.

-- You could technically put most of your schema code into a couple of files, but that makes your code a lot harder to manage -
-- especially once your project grows in size. The standard convention is to have your miscellaneous functions that don't belong
-- in a library reside in your cl/sh/sv_schema.lua files. Your gamemode hooks should reside in cl/sh/sv_hooks.lua. Logical
-- groupings of functions should be put into their own libraries in the libs/ folder. Everything in the libs/ folder is loaded
-- automatically.


ix.util.Include("libs/thirdparty/sh_netstream2.lua")

ix.util.Include("cl_schema.lua")
ix.util.Include("sv_schema.lua")

ix.util.Include("cl_hooks.lua")
ix.util.Include("sh_hooks.lua")
ix.util.Include("sv_hooks.lua")

-- You'll need to manually include files in the meta/ folder, however.
ix.util.Include("meta/sh_character.lua")
ix.util.Include("meta/sh_player.lua")

-- Commands
ix.util.Include("sh_commands.lua")

ix.util.Include("sh_items.lua")

ix.util.Include("sh_storagedefs.lua")

-- Add NetStream2

do
	local CLASS = {}
	CLASS.color = Color(75, 150, 50)
	CLASS.format = "%s comlink in \"%s\""

	function CLASS:CanHear(speaker, listener)
		local character = listener:GetCharacter()
		local inventory = character:GetInventory()
		local bHasRadio = false

		for k, v in pairs(inventory:GetItemsByUniqueID("comlink", true)) do
			if (v:GetData("enabled", false)) then
				bHasRadio = true
				break
			end
		end

		return bHasRadio
	end

	function CLASS:OnChatAdd(speaker, text)
		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
	end

	ix.chat.Register("comlink", CLASS)
end

do
	local CLASS = {}
	CLASS.color = Color(255, 255, 175)
	CLASS.format = "%s comlinks in \"%s\""

	function CLASS:GetColor(speaker, text)
		if (LocalPlayer():GetEyeTrace().Entity == speaker) then
			return Color(175, 255, 175)
		end

		return self.color
	end

	function CLASS:CanHear(speaker, listener)
		if (ix.chat.classes.comlink:CanHear(speaker, listener)) then
			return false
        end
        
        if (speaker:__eq(listener)) then
            return false
        end

		local chatRange = ix.config.Get("chatRange", 280)

		return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange)
	end

	function CLASS:OnChatAdd(speaker, text)
		chat.AddText(self.color, string.format(self.format, speaker:Name(), text))
	end

	ix.chat.Register("comlink_eavesdrop", CLASS)
end

ix.anim.SetModelClass("models/range_trooper/range_trooper.mdl", "player")
ix.anim.SetModelClass("models/valleyofdea7h/soul_culaberation/characters/darth_vader.mdl", "player")
ix.anim.SetModelClass("models/hcn/starwars/bf/rodian/rodian_2.mdl", "player")
ix.anim.SetModelClass("models/hcn/starwars/bf/rodian/rodian_3.mdl", "player")
ix.anim.SetModelClass("models/hcn/starwars/bf/quarren/quarren_2.mdl", "player")
ix.anim.SetModelClass("models/bananakin/thrawn/imperial_thrawn_player.mdl", "player")
ix.anim.SetModelClass("models/hcn/starwars/bf/human/human_male_5.mdl", "player")