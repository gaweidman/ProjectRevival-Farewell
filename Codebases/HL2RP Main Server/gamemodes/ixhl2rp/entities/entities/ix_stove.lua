
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Stove"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

if SERVER then
	startTable = {}
	cookingTable = {}
	cookedTable = {}
	burntTable = {}
	
	function ENT:Initialize()
		
		self:SetModel("models/hunter/plates/plate075x1.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		self:SetPos(trace.HitPos + Vector(0, 0, 21))

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Wake()
		
		self.stoveOn = false
		
	end
	

	function ENT:Use(client, caller, useType)
		self.stoveOn = !self.stoveOn

		if self.stoveOn then
			self:EmitSound("ambient/fire/mtov_flame2.wav", 75, 100, 0.3)
			self:EmitSound("ambient/gas/steam_loop1.wav", 75, 100, 0.3)
		else
			self:StopSound("ambient/fire/mtov_flame2.wav")
			self:StopSound("ambient/gas/steam_loop1.wav")
		end

		
		--client:ChatPrint(tostring(self.stoveOn))

	end

	function ENT:StartTouch(ent)

		if self.stoveOn and ent:GetClass() == "ix_item" then

			local itemTable = ent:GetItemTable()

			-- These two set up the cook time and burn time
			-- for the item unless it's already been set up.
			if itemTable:GetData("cookTime", nil) == nil then
				local newCookTime = math.random(5, 10)
				itemTable:SetData("cookTime", newCookTime)
			end
								
			if itemTable:GetData("burnTime", nil) == nil then
				local newBurnTime = math.random(-45, -75)
				itemTable:SetData("burnTime", newBurnTime)
			end

			

			
			startTable[ent:EntIndex()] = math.floor(CurTime()) -- Adds the entity to the cooking table.
			cookingTable[ent:EntIndex()] = 0
			cookedTable[ent:EntIndex()] = itemTable:GetData("cookTime", 60)
			burntTable[ent:EntIndex()] = itemTable:GetData("burnTime", -45)
			
			

			local nameSplit = string.Split(itemTable.uniqueID, "_")
			--local newItem = ix.item.Spawn("cooked_"..nameSplit[2].."_"..nameSplit[3], ent:GetPos(), nil, ent:GetAngles(), nil)
			--newItem:Spawn(ent:GetPos(), ent:GetAngles())
			--ent:Remove()

			for k, v in pairs(player.GetAll()) do
				--v:ChatPrint(ent:GetItemTable():GetName()) -- Development testing only.
			end

		end
		
	end

	function ENT:Touch(ent)

		if self.stoveOn and ent:GetClass() == "ix_item" and string.find(ent:GetItemTable().name, "Raw") then
			local itemTable = ent:GetItemTable()
/*
			for k, v in pairs(player.GetAll()) do
				v:ChatPrint("hmm")
			end
			

			for k, v in pairs(player.GetAll()) do
				v:ChatPrint("nice")
				v:ChatPrint(itemTable.name)
			end

			
			*/	
			cookingTable[ent:EntIndex()] = math.floor(CurTime()) - startTable[ent:EntIndex()]
			--ent:SetItemID("cooked_"..nameSplit[2].."_"..nameSplit[3])
			
			
			
			
			if cookingTable[ent:EntIndex()] >= cookedTable[ent:EntIndex()] then
				local entPos = ent:GetPos()
				local entAng = ent:GetAngles()
				ent:Remove()
				cookingTable[ent:EntIndex()] = nil
				cookedTable[ent:EntIndex()] = nil
				burntTable[ent:EntIndex()] = nil
				startTable[ent:EntIndex()] = nil
				
				local idSplit = string.Split(itemTable.uniqueID, "_")
				ix.item.Spawn("cooked_"..idSplit[2].."_"..idSplit[3], entPos, nil, entAng, nil)
				
			end

			if cookingTable[ent:EntIndex()] - startTable[ent:EntIndex()] >= cookedTable[ent:EntIndex()] + burntTable[ent:EntIndex()] then
				-- TODO: IMPLEMENT CONVERSION FROM COOKED ITEM TO RAW ITEM.
			end
			

		end

	end

	function ENT:EndTouch(ent)

		if self.stoveOn and ent:GetClass() == "ix_item" then
			local itemTable = ent:GetItemTable()
			itemTable:SetData("cookTime", itemTable:GetData("cookTime", 60) - cookingTable[ent:EntIndex()])
			cookingTable[ent:EntIndex()] = nil
			cookedTable[ent:EntIndex()] = nil
			burntTable[ent:EntIndex()] = nil
			startTable[ent:EntIndex()] = nil

		end

		
		
	end

	function ENT:OnRemove()
		self:StopSound("ambient/fire/mtov_flame2.wav")
		self:StopSound("ambient/gas/steam_loop1.wav")
	end

end