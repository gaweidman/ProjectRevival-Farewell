
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Sewer Garbage"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true
ENT.PopulateEntityInfo = true

local SEARCH_TIME = 0.5
local common = 1
local uncommon = 2
local rare = 3
local veryRare = 4

local LOOT_RARITY = {
	padlock = uncommon,
	aabattery = common,
	bolts = uncommon,
	capacitors = common,
	carbattery = uncommon,
	circuitboard = common,
	graphicscard = common,
	horsefigurine = uncommon,
	hose = common, 
	insulatingtape = uncommon,
	lcdbroken = common, 
	lightbulb = common,
	nailpack = uncommon,
	pliers = rare,
	powercord = common, 
	powersupplyunit = common,
	roubles = uncommon,
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
	small_thermos = uncommon,
	zip_tie = rare,
	citizenfilter = uncommon,
	rock = common,
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
	reinforced_padlock = rare,
	bleach = rare,
	paper = uncommon,
	notepad = uncommon,
	minsupps = uncommon,
	minfood = uncommon,
	pot = uncommon, 
	pan = uncommon,
	empty_glass_bottle = common, 
	pipe = uncommon,
	regration = veryRare,
	resin = rare,
	electricdrill = rare,
	gasanalyser = rare,
	gasoline = rare,
	lcd = uncommon,
	matches = uncommon,
	militarycircuitboard = uncommon,
	paracord = common,
	plexiglass = common,
	armor_scraps = uncommon,
	weaponparts = veryRare,
	shovel = rare,
	axe = veryRare,
	pipe = common,
	refined_metal = uncommon,
	sewn_cloth = uncommon,
	blacksmithtongs = rare,
	airtankempty = uncommon,
	cyclopscivsuit = rare,
	greencivsuit = rare,
	knife = veryRare,
	crowbar = rare,
	electricmotor = rare,
	controller = rare,
	radiatorhelix = rare,
	bloodsyringe = uncommon,
	sewing_kit = rare,
	firstaidkit = veryRare,
	health_vial = rare,
	stimshot = rare,
	smallfirstaid = veryRare,
	ai2 = rare,
	gunpowder = rare,
	ccafilter = rare,
	conscriptfilter = rare,
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
		self:SetModel("models/props_junk/trashcluster01a_corner.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self:DrawShadow(false)
		
		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()
	end

	
	function ENT:Use(ply)
		local this = self
		local char = ply:GetCharacter()
		local inv = char:GetInventory()
		
		ply:SetAction("Searching...", SEARCH_TIME)
		ply:DoStaredAction(self, function()
			local critRoll = math.random(1, 100)
			local lowBound, highBound = this:GetModelBounds()

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
			self:Remove()
		end, SEARCH_TIME, function()
			ply:SetAction()
		end)
	end

	function ENT:OnRemove()
		if IsValid(self:GetParent()) then 
			self:GetParent():SetVar("NextSpawn", CurTime() + math.random(15, 20))
		end
	end


end

if CLIENT then
	function ENT:OnPopulateEntityInfo(tooltip)
		local name = tooltip:AddRow("name")
		name:SetImportant(true)
		name:SetText("Garbage")
		name:SizeToContents()
		local desc = tooltip:AddRow("description")
		desc:SetText("A cluster of plastic garbage bags. There may be something worth taking in them.")
		desc:SizeToContents()
	end
end