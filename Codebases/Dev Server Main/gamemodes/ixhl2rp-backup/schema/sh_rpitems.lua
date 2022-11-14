local ITEMS = {}

ITEMS.cmbhexkey = {
	["name"] = "Combine Hex Key",
	["model"] = "models/gibs/metal_gib5.mdl",
	["description"] = "A little piece of metal in a hexagonal shape, with a hexagon-shaped hole inset at its bottom. It's no bigger than a banknote.",
	["width"] = 1,
	["height"] = 1,
	["functions"] = {
		["freevort"] = {
			["name"] = "Free Vortigaunt",
			["tip"] = "Free the vortigaunt you're looking at.",
			["icon"] = "icon16/lock_open.png",
			["OnRun"] = function(itemTable)
				local client = itemTable.player
				local char = client:GetCharacter()

				local tr = client:GetEyeTrace()
				if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
					local targetPly = tr.Entity
					local targetChar = targetPly:GetCharacter()
					local response = targetPly:TryFreeVort(client)
					if response then
						client:Notify(response)
					end
				else
					client:Notify("You are not looking at a valid player!")
				end

				return false
			end,
			["OnCanRun"] = function(itemTable)
				local client = itemTable.player
				local char = client:GetCharacter()

				local tr = client:GetEyeTrace()
				if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
					local targetPly = tr.Entity
					local targetChar = targetPly:GetCharacter()
					return targetChar:GetFaction() == FACTION_CAC and targetChar:GetClass() == CLASS_VORTSLAVE		
				end	
			end
		}
	}
}

ITEMS.vortbindings = {
	["name"] = "Vortigaunt Bindings",
	["model"] = "models/gibs/manhack_gib02.mdl",
	["description"] = "A set of vortigaunt bindings, meant to be surgically implanted.",
	["width"] = 2,
	["height"] = 2,
	["functions"] = {
		["bindvort"] = {
			["name"] = "Bind Vortigaunt",
			["tip"] = "Implant the bindings into the vortigaunt you're looking at.",
			["icon"] = "icon16/lock.png",
			["OnRun"] = function(itemTable)
				local client = itemTable.player
				local char = client:GetCharacter()

				local tr = client:GetEyeTrace()
				if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
					local targetPly = tr.Entity
					local targetChar = targetPly:GetCharacter()
					local response = targetPly:TryBindVort(client)
					if response then
						client:Notify(response)
					end
				else
					client:Notify("You are not looking at a valid player!")
				end

				return false
			end,
			["OnCanRun"] = function(itemTable)
				local client = itemTable.player
				local char = client:GetCharacter()

				local tr = client:GetEyeTrace()
				if IsValid(tr.Entity) and tr.Entity:IsPlayer() then
					local targetPly = tr.Entity
					local targetChar = targetPly:GetCharacter()
					return targetChar:GetFaction() == FACTION_ALIEN and targetChar:GetClass() == CLASS_FREEVORT		
				end	
			end
		}
	}
}

ITEMS.scalpel = {
	["name"] = "Scalpel",
	["model"] = "models/weapons/w_knife_t.mdl",
	["description"] = "A sharp scalpel made of stainless steel. It's not a good weapon, but it's great at cutting things.",
	["width"] = 1,
	["height"] = 1
}

ITEMS.larvalextract = {
	["name"] = "Larval Extract",
	["model"] = "models/props_hive/larval_essence_wphysics.mdl",
	["description"] = "A strangely shaped mass, not unlike in appearance to a human heart. It has a slight glow to it.",
	["width"] = 1,
	["height"] = 1,
	["functions"] = {
		["imbibe"] = {
			["name"] = "Imbibe",
			["tip"] = "Imbibe in the larval extract and dissolve the false veils that divide the vortessence.",
			["icon"] = "icon16/layers.png",
			["OnRun"] = function(itemTable)
				if SERVER then
					for k, v in ipairs(player.GetAll()) do
						if v:GetCharacter():GetFaction() == FACTION_ALIEN and v:GetCharacter():GetClass() == CLASS_FREEVORT then
							v:Transcend()
						end
					end
				end
			end,
			["OnCanRun"] = function(itemTable)
				return itemTable.player:GetCharacter():GetFaction() == FACTION_ALIEN and itemTable.player:GetCharacter():GetClass() == CLASS_FREEVORT
			end
		}
	}
}

for k, v in pairs(ITEMS) do
	local ITEM = ix.item.Register(k, nil, false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model
	ITEM.description = v.description
	ITEM.category = v.description or "Roleplay Items"
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.chance = v.chance or 0
	ITEM.isTool = v.tool or false

	if v.functions then 
		for funcName, func in pairs(v.functions) do 
			ITEM.functions[funcName] = func
		end
	end
end

ITEMS = {}
ITEMS["identiband"] = {
	name = "Identiband",
	description = "A cloth armband used to identify citizens. It's a dull gray color and a bit itchy.",
	model = "models/props_junk/cardboard_box004a.mdl",
	width = 1,
	height = 1,
	outfitCategory = "armband"
}


for k, v in pairs(ITEMS) do
	local ITEM = ix.item.Register(k, "base_outfit", false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model
	ITEM.description = v.description
	ITEM.category = v.description or "Miscellaneous"
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.chance = v.chance or 0
	ITEM.isTool = v.tool or false
	ITEM.outfitCategory = v.outfitCategory or "armband"

	if v.functions then 
		for funcName, func in pairs(v.functions) do 
			ITEM.functions[funcName] = func
		end
	end
end