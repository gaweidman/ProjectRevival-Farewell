
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Searchable Dumpster"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true
ENT.PopulateEntityInfo = true

local SEARCH_TIME = 5
local common = 1
local uncommon = 2
local rare = 3
local veryRare = 4

local LOOT_RARITY = {
	padlock = rare,
	aabattery = common,
	bolts = uncommon,
	capacitors = uncommon,
	carbattery = rare,
	circuitboard = common,
	graphicscard = common,
	horsefigurine = rare,
	hose = common, 
	insulatingtape = uncommon,
	lcdbroken = common, 
	lightbulb = common,
	nailpack = uncommon,
	pliers = rare,
	powercord = common, 
	coldpack = uncommon,
	powersupplyunit = common,
	roubles = rare,
	screwdriver = rare,
	screwnuts = uncommon,
	siliconetube = common,
	soap = common, 
	sparkplug = common,
	toiletpaper = common,
	wires = common,
	wrench = rare,
	cinderblock = common,
	emptybleachbottle = common,
	empty_chinese_takeout = common,
	empty_oil_bottle = common,
	empty_pill_bottle = common,
	pin = common, 
	radio_case = rare,
	rope = uncommon,
	rubber_tire = uncommon,
	scrap_glass = common,
	small_thermos = rare,
	zip_tie = veryRare,
	citizenfilter = rare,
	empty_milk_gallon = common,
	empty_paint_can = common,
	old_newspaper = common,
	locker_door = uncommon,
	cloth_scrap = common,
	scrap_metal = common,
	scrap_electronics = common,
	scrap_plastic = common,
	emptysodabottle = common,
	consulwaterempty = common,
	flavoredconsulwaterempty = common,
	sparklingconsulwaterempty = common,
	brokencpumonitor = common,
	brokenkeyboard = common,
	brokenclock = common,
	boot = common,
	emptycan = common,
	humanscienceeyeposter = rare,
	consulposter = rare,
	reinforced_padlock = veryRare,
	bleach = veryRare,
	paper = uncommon,
	notepad = uncommon,
	minsupps = uncommon,
	minfood = uncommon,
	pot = rare, 
	pan = rare,
	empty_glass_bottle = common, 
	pipe = uncommon,
	regration = veryRare,
	resin = rare,
	scrap_wood = common,
	hammer = rare,
}

local LOOT_TABLE = {}

for k, v in pairs(LOOT_RARITY) do
	local convTable = {
		[common] = 3,
		[uncommon] = 2,
		[rare] = 1,
		[veryRare] = 1
	}
	LOOT_TABLE[k] = (5 - v)*convTable[v]
end

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_junk/TrashDumpster01a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()

		self:ShuffleIndex()

	end

	function ENT:ShuffleIndex()
		local testIndex = math.random(1, 99999)
		for k, v in ipairs(ents.FindByClass("ix_searchdumpster")) do
			if v:GetVar("DumpsterIndex") == testIndex then
				self:ShuffleIndex()
				return
			end
		end

		self:SetVar("DumpsterIndex", testIndex)
	end
	
	function ENT:Use(ply)
		local this = self
		local char = ply:GetCharacter()
		local inv = char:GetInventory()
		
		local plySearches = char:GetVar("DumpsterSearches", {})
		local entSearchIndex = self:GetVar("DumpsterIndex")

		if plySearches[entSearchIndex] and plySearches[entSearchIndex] + 60*8 > CurTime() then
			ply:Notify("You have searched this dumpster too recently!")
			return
		end

		ply:SetAction("Searching...", SEARCH_TIME)
		ply:DoStaredAction(self, function()
			local critRoll = math.random(1, 100)
			local lowBound, highBound = this:GetModelBounds()

			plySearches = char:GetVar("DumpsterSearches", {})
			plySearches[entSearchIndex] = CurTime()
			char:SetVar("DumpsterSearches", plySearches)

			local item = ix.util.WeightedRandom(LOOT_TABLE)
			local itemTbl = ix.item.list[item]
			local itemName = itemTbl.name

			local notifyStr = "You found "
			if ix.util.StartsWithVowel(itemName) then
				--notifyStr = notifyStr.."an "
			elseif string.sub(itemName, #itemName - 2) == "s" then
				-- do nothing
			else
				--notifyStr = notifyStr.."a "
			end
			ply:Notify(notifyStr..itemName..".")

			if !inv:Add(item) then
				local lowBound, highBound = this:GetModelBounds()
				ix.item.Spawn(item, this:GetPos() + Vector(0, 0, highBound.z + 15))
			end
		end, SEARCH_TIME, function()
			ply:SetAction()
		end)
	end


end

if CLIENT then
	function ENT:OnPopulateEntityInfo(tooltip)
		local name = tooltip:AddRow("name")
		name:SetImportant(true)
		name:SetText("Dumpster")
		name:SizeToContents()
		local desc = tooltip:AddRow("description")
		desc:SetText("A large green dumpster. It's full of bags of garbage and items of various use.")
		desc:SizeToContents()
	end
end