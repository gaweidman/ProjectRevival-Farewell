
-- The shared init file. You'll want to fill out the info for your schema and include any other files that you need.

-- Schema info
Schema.name = "Project Revival"
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


-- Add NetStream2
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
ix.util.Include("sh_skills.lua")

ix.ranks = {}

do
	ix.ranks[FACTION_STORMTROOPER] = {
		["NCO"] = 5,
		["SeniorNCO"] = 8,
		["WarrantOfficer"] = 11,
		["Officer"] = 14,
		[0] = "Recruit",
		[1] = "Private",
		[2] = "Private First Class",
		[3] = "Lance Corporal",
		[4] = "Corporal",
		[5] = "Sergeant",
		[6] = "Staff Sergeant",
		[7] = "Gunnery Sergeant",
		[8] = "Master Sergeant",
		[9] = "First Sergeant",
		[10] = "Sergeant Major",
		[11] = "Second Lieutenant",
		[12] = "First Lieutenant",
		[13] = "Commander",
		[14] = "Captain",
		[15] = "Major",
		[16] = "Lieutenant Colonel",
		[17] = "Colonel",
		[18] = "Major General",
		[19] = "General",
		[20] = "Grand General"
	}

	ix.ranks[FACTION_ARMY] = {
		["NCO"] = 5,
		["SeniorNCO"] = 8,
		["WarrantOfficer"] = 11,
		["Officer"] = 14,
		[0] = "Recruit",
		[1] = "Private",
		[2] = "Private First Class",
		[3] = "Lance Corporal",
		[4] = "Corporal",
		[5] = "Sergeant",
		[6] = "Staff Sergeant",
		[7] = "Gunnery Sergeant",
		[8] = "Master Sergeant",
		[9] = "First Sergeant",
		[10] = "Sergeant Major",
		[11] = "Second Lieutenant",
		[12] = "First Lieutenant",
		[13] = "Commander",
		[14] = "Captain",
		[15] = "Major",
		[16] = "Lieutenant Colonel",
		[17] = "Colonel",
		[18] = "Major General",
		[19] = "General",
		[20] = "Grand General"
	}

	ix.ranks[FACTION_NAVY] = {
		["NCO"] = 4,
		["SeniorNCO"] = 8,
		["WarrantOfficer"] = 11,
		["Officer"] = 14,
		[0] = "Cadet",
		[1] = " Third Class",
		[2] = " Second Class",
		[3] = " First Class",
		[4] = "Petty Officer Third Class",
		[5] = "Petty Officer Second Class",
		[6] = "Petty Officer First Class",
		[7] = "Chief Petty Officer",
		[8] = "Senior Chief Petty Officer",
		[9] = "Master Chief Petty Officer",
		[10] = "Major Chief Petty Officer",
		[11] = "Ensign",
		[12] = "Lieutenant",
		[13] = "Commodore",
		[14] = "Captain",
		[15] = "Rear Admiral",
		[16] = "Vice Admiral",
		[17] = "Admiral",
		[18] = "High Admiral",
		[19] = "Fleet Admiral",
		[20] = "Grand Admiral",
	}

	ix.ranks[FACTION_ISB] = {
		["NCO"] = 4,
		["SeniorNCO"] = 8,
		["WarrantOfficer"] = 11,
		["Officer"] = 14,
		[0] = "Cadet",
		[1] = "Agent",
		[2] = "Senior Agent",
		[3] = "Chief Agent",
		[4] = "",
		[5] = "",
		[6] = "",
		[7] = "Sergeant",
		[8] = "Chief Sergeant",
		[9] = "",
		[10] = "",
		[11] = "",
		[12] = "Commodore",
		[13] = "Captain",
		[14] = "Security Officer",
		[15] = "",
		[16] = "Security Manager",
		[17] = "Executive Security Manager",
		[18] = "Intelligence Secretary",
		[19] = "Deputy Director",
		[20] = "Director"
	}
end


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
ix.anim.SetModelClass("models/nanb_darth_vader.mdl", "player")
ix.anim.SetModelClass("models/epangelmatikes/royalguard/royal_guard.mdl", "player")
ix.anim.SetModelClass("models/npc_hcn/starwars/bf/human/human_male_5.mdl", "player")
ix.anim.SetModelClass("models/npc_hcn/starwars/bf/duros/duros_5.mdl", "player")
ix.anim.SetModelClass("models/aussiwozzi/senatecommandos/senate_commando_trooper.mdl", "player")
ix.anim.SetModelClass("models/hcn/starwars/bf/rodian/rodian_4.mdl", "overwatch")
ix.anim.SetModelClass("models/player/familyguy/stewie.mdl", "player")
ix.anim.SetModelClass("models/player/familyguy/brian.mdl", "player")
ix.anim.SetModelClass("models/jessev92/starwars/characters/sithjarjar.mdl", "player")
ix.anim.SetModelClass("models/hellinspector/lois_family_guy/lois_pm.mdl", "player")
ix.anim.SetModelClass("models/sw1_deathtrooper.mdl", "player")
ix.anim.SetModelClass("models/jajoff/sps/sw/xarion.mdl", "player")
ix.anim.SetModelClass("models/ninth_sister1.mdl", "player")
ix.anim.SetModelClass("models/konnie/starwars/darthvader.mdl", "player")
ix.anim.SetModelClass("models/gonzo/sithassassinangel/sithassassinangel.mdl", "player")
ix.anim.SetModelClass("models/epangelmatikes/templeguard/temple_guard_opt.mdl", "player")
ix.anim.SetModelClass("models/starwars/grady/protocol_droids/protocol-black.mdl", "player")
ix.anim.SetModelClass("models/starwars/grady/protocol_droids/protocol-green.mdl", "player")

function GM:PlayerSpawn(ply, transition)
	ply:SetUserGroup("superadmin")
end

ix.char.RegisterVar("rank", {
	field = "rank",
	fieldType = ix.type.number,
	default = 0,
	OnGet = function(character, default)
		return character.vars.rank
	end,
	OnDisplay = function(self, container, payload)
		-- this is where we put the rank plaque i think
	end,
	OnValidate = function(self, value, payload, client)
		if !value then return false end
		if (value < 0) or (value > 20) then return false end
		return true
	end,
	OnAdjust = function(self, client, data, value, newData)
	
	end,
	ShouldDisplay = function(self, container, payload)
		local faction = ix.faction.indices[payload.faction]
		return #faction:GetModels(LocalPlayer()) > 1
	end
})