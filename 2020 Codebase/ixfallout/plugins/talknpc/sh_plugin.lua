
PLUGIN.name = "Talking NPCs"
PLUGIN.author = "Black Tea (NS 1.0), Neon (NS 1.1), Frosty (Helix)"
PLUGIN.description = "Adding talking NPCs."
PLUGIN.chatDelay = { min = .5, max = 1 }
PLUGIN.defaultDialogue = {
	npc = {
		["_start"] = "Hello, This is default Text.",
		["test1"] = "He is also known as 'Black Tea'. He is really famous for incredible sucky coding skill and not working buggy code. Long time ago, I suggested him to kill himself but he refused.",
	},
	player = {
		["_quit"] = "I gotta go.",
		["test1"] = "Can you tell me who is rebel1324?",
	},
}

ix.lang.AddTable("korean", {
	["Dialogue"] = "대화창",
})

if (SERVER) then
	local PLUGIN = PLUGIN

	function PLUGIN:SaveData()
		local data = {}
			for _, entity in ipairs(ents.FindByClass("ix_talker")) do
				local bodygroups = {}

				for _, v in ipairs(entity:GetBodyGroups() or {}) do
					bodygroups[v.id] = entity:GetBodygroup(v.id)
				end

				data[#data + 1] = {
					name = entity:GetNetVar("name"),
					description = entity:GetNetVar("description"),
					pos = entity:GetPos(),
					angles = entity:GetAngles(),
					model = entity:GetModel(),
					skin = entity:GetSkin(),
					bodygroups = bodygroups,
					factions = entity:GetNetVar("factiondata", {}),
					dialogue = entity:GetNetVar( "dialogue", self.defaultDialogue ),
					classes = entity:GetNetVar("classdata", {})
				}
			end
		self:SetData(data)
	end

	function PLUGIN:LoadData()
		for k, v in ipairs(self:GetData() or {}) do
			local entity = ents.Create("ix_talker")
			entity:SetPos(v.pos)
			entity:SetAngles(v.angles)
			entity:Spawn()
			entity:SetModel(v.model)
			entity:SetSkin(v.skin)

			local physObj = entity:GetPhysicsObject()

			if (IsValid(physObj)) then
				physObj:EnableMotion(false)
				physObj:Sleep()
			end

			for id, bodygroup in pairs(v.bodygroups or {}) do
				entity:SetBodygroup(id, bodygroup)
			end

			entity:SetNetVar("dialogue", v.dialogue)
			entity:SetNetVar("factiondata", v.factions)
			entity:SetNetVar("classdata", v.classes)
			entity:SetNetVar("name", v.name)
			entity:SetNetVar("description", v.description)
		end
	end
end