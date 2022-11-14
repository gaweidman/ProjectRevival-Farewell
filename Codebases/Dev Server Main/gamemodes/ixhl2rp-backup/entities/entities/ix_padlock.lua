
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Padlock"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Locked")
	self:NetworkVar("Bool", 1, "DisplayError")

	if (SERVER) then
		self:NetworkVarNotify("Locked", self.OnLockChanged)
	end
end

if (SERVER) then
	function ENT:GetLockPosition(door, normal)
		local index = door:LookupBone("handle")
		local position = door:GetPos()
		normal = normal or door:GetForward():Angle()


		if (index and index >= 1) then
			
			position = door:GetBonePosition(index)
		end


		if IsValid(door:GetDoorPartner()) then
			position = position + normal:Forward() * 2 + door:GetRight() * -4.1 + door:GetUp()*-1.5

			print()

			return position, normal
		else
			local lowBound, highBound = door:GetCollisionBounds()
			local sumBound = highBound + lowBound


			position = position + sumBound.x*door:GetForward()/2 + normal:Forward() * 2.5-- + normal:Up() * 10 + normal:Right() * 2


			return position, normal
		end
	end

	function ENT:SetDoor(door, position, angles)
		if (!IsValid(door) or !door:IsDoor()) then
			return
		end

		local doorPartner = door:GetDoorPartner()

		self.door = door
		self.door:DeleteOnRemove(self)
		door.ixLock = self

		if (IsValid(doorPartner)) then
			self.doorPartner = doorPartner
			self.doorPartner:DeleteOnRemove(self)
			self.bar = ents.Create("prop_dynamic")
			self.bar:SetModel("models/hunter/plates/plate025.mdl")
			self.bar:SetMaterial("phoenix_storms/iron_rails")
			self.bar:SetPos(position + door:GetForward()*0)
			self.bar:SetAngles(angles)
			self.bar:SetParent(door)
			self.bar:Spawn()
			doorPartner.ixLock = self
		end

		

		self:SetPos(position)
		self:SetAngles(angles)
		self:SetParent(door)


	end

	function ENT:SpawnFunction(client, trace)
		local door = trace.Entity

		if (!IsValid(door) or !door:IsDoor() or IsValid(door.ixLock)) then
			return client:NotifyLocalized("dNotValid")
		end

		local normal = client:GetEyeTrace().HitNormal:Angle()
		local position, angles = self:GetLockPosition(door, normal)

		local entity = ents.Create("ix_padlock")
		entity:SetPos(trace.HitPos)
		entity:Spawn()
		entity:Activate()
		entity:SetDoor(door, position, angles)
		entity:Initialize()
		
		undo.Create("Padlock")
			undo.AddEntity(entity)
			undo.SetPlayer(client)
		undo.Finish()
	end

	function ENT:Initialize()
		self:SetModel("models/props_wasteland/prison_padlock001a.mdl")
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetUseType(SIMPLE_USE)

		self.nextUseTime = 0
	end

	function ENT:OnRemove()
		if (IsValid(self)) then
			self:SetParent(nil)
		end

		if (IsValid(self.door)) then
			self.door:Fire("unlock")
			self.door.ixLock = nil
		end

		if (IsValid(self.doorPartner)) then
			self.doorPartner:Fire("unlock")
			self.doorPartner.ixLock = nil
		end

		if IsValid(self.bar) then
			self.bar:Remove()
		end

		if (!ix.shuttingDown) then
			Schema:SaveCombineLocks()
		end
	end

	function ENT:OnLockChanged(name, bWasLocked, bLocked)
		if (!IsValid(self.door)) then
			return
		end

		if bLocked then
			self.door:Fire("lock")
			self.door:Fire("close")

			
			self:EmitSound("doors/handle_pushbar_locked1.wav")
			self:SetModel("models/props_wasteland/prison_padlock001a.mdl")

			

			if (IsValid(self.doorPartner)) then
				self.doorPartner:Fire("lock")
				self.doorPartner:Fire("close")
			end
		else
			self.door:Fire("unlock")

			self:EmitSound("doors/door_latch1.wav")
			self:SetModel("models/props_wasteland/prison_padlock001b.mdl")
	 
			if (IsValid(self.doorPartner)) then
				self.doorPartner:Fire("unlock")
			end
		end
	end

	function ENT:Toggle(client)
		if (self.nextUseTime > CurTime()) then
			return
		end

		self:SetLocked(!self:GetLocked())

	end

	function ENT:Use(client)
		local char = client:GetCharacter()
		local locks = char:GetData("DoorLocks", {})

		if (self.nextUseTime > CurTime()) then
			return
		end

		if self.password != nil and locks[self.door:MapCreationID()] == self.password or (IsValid(self.doorPartner) and locks[self.doorPartner:MapCreationID()] == self.password) then
			self:Toggle()
		elseif self.password == nil then
			net.Start("ixPadlockCode")
				net.WriteBool(true)
				net.WriteInt(self:EntIndex(), 32)
				net.WriteBool(false)
			net.Send(client)
		else
			net.Start("ixPadlockCode")
				net.WriteBool(false)
				net.WriteInt(self:EntIndex(), 32)
			net.Send(client)
		end
		
		self.nextUseTime = CurTime() + 0.01
	end
else
	local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
	local color_green = Color(0, 255, 0, 255)
	local color_blue = Color(0, 100, 255, 255)
	local color_red = Color(255, 50, 50, 255)

	function ENT:Initialize()
		self:SetupBones()
	end
end