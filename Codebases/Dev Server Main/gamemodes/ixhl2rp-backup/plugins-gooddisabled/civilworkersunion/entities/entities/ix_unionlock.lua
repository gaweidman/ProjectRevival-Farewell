
AddCSLuaFile()

local PLUGIN = PLUGIN

ENT.Type = "anim"
ENT.PrintName = "Union Lock"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Locked")
	self:NetworkVar("Bool", 1, "DisplayError")
	self:NetworkVar("Int", 0, "KeyCode")

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
			position = position + normal:Forward() * 7.2 + normal:Up() * 10 + normal:Right() * 2

			normal:RotateAroundAxis(normal:Up(), 90)
			normal:RotateAroundAxis(normal:Forward(), 180)
			normal:RotateAroundAxis(normal:Right(), 180)

			return position, normal
		else
			local lowBound, highBound = door:GetCollisionBounds()
			local sumBound = highBound + lowBound


			position = position + sumBound.x*door:GetForward()/2 + normal:Forward() * 7.2 -- + normal:Up() * 10 + normal:Right() * 2

			normal:RotateAroundAxis(normal:Up(), 90)
			normal:RotateAroundAxis(normal:Forward(), 180)
			normal:RotateAroundAxis(normal:Right(), 180)

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
		door.ixUnionLock = self

		if (IsValid(doorPartner)) then
			self.doorPartner = doorPartner
			self.doorPartner:DeleteOnRemove(self)
			doorPartner.ixUnionLock = self
		end

		self:SetPos(position)
		self:SetAngles(angles)
		self:SetParent(door)
	end

	function ENT:SpawnFunction(client, trace)
		local door = trace.Entity

		if (!IsValid(door) or !door:IsDoor() or IsValid(door.ixUnionLock)) then
			return client:NotifyLocalized("dNotValid")
		end

		local normal = client:GetEyeTrace().HitNormal:Angle()
		local position, angles = self:GetLockPosition(door, normal)

		local entity = ents.Create("ix_unionlock")
		entity:SetPos(trace.HitPos)
		entity:Spawn()
		entity:Activate()
		entity:SetDoor(door, position, angles)
		entity:SetKeyCode(math.random(1000,9000))

		PLUGIN:SaveUnionLocks()
		return entity
	end

	function ENT:Initialize()
		self:SetModel("models/props_combine/combine_lock01.mdl")
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
			self.door.ixUnionLock = nil
		end

		if (IsValid(self.doorPartner)) then
			self.doorPartner:Fire("unlock")
			self.doorPartner.ixUnionLock = nil
		end

		if (!ix.shuttingDown) then
			PLUGIN:SaveUnionLocks()
		end
	end

	function ENT:OnLockChanged(name, bWasLocked, bLocked)
		if (!IsValid(self.door)) then
			return
		end

		if (bLocked) then
			self:EmitSound("buttons/combine_button2.wav")
			self.door:Fire("lock")
			self.door:Fire("close")

			if (IsValid(self.doorPartner)) then
				self.doorPartner:Fire("lock")
				self.doorPartner:Fire("close")
			end
		else
			self:EmitSound("buttons/combine_button7.wav")
			self.door:Fire("unlock")

			if (IsValid(self.doorPartner)) then
				self.doorPartner:Fire("unlock")
			end
		end
	end

	function ENT:DisplayError()
		self:EmitSound("buttons/combine_button_locked.wav")
		self:SetDisplayError(true)

		timer.Simple(1.2, function()
			if (IsValid(self)) then
				self:SetDisplayError(false)
			end
		end)
	end

	function ENT:Toggle(client)
		if (self.nextUseTime > CurTime()) then
			return
		end

		if (!client:HasBiosignal() and client:Team() != FACTION_ADMIN and !client:GetCharacter():GetInventory():HasItem("uid")) then 
			self:DisplayError()
			self.nextUseTime = CurTime() + 2

			return
		end

		self:SetLocked(!self:GetLocked())
		self.nextUseTime = CurTime() + 2
	end

	function ENT:HasKey(client)
	  local bool = false

	  for _, v in pairs(client:GetCharacter():GetInventory():GetItems()) do
	    local item_table = ix.item.instances[v.id]

	    if item_table.uniqueID == 'key' and item_table:GetData('KeyCode', 0) == self:GetKeyCode() then

	      bool = true

	      break
	    end
	  end

	  return bool
	end

	function ENT:Use(client)
		self:Toggle(client)
	end
else
	local glowMaterial = ix.util.GetMaterial("sprites/glow04_noz")
	local color_green = Color(0, 255, 0, 255)
	local color_yellow = Color(0, 100, 255, 255)
	local color_red = Color(255, 50, 50, 255)

	function ENT:Draw()
		self:DrawModel()

		local color = color_green

		if (self:GetDisplayError()) then
			color = color_red
		elseif (self:GetLocked()) then
			color = color_yellow
		end

		local position = self:GetPos() + self:GetUp() * -8.7 + self:GetForward() * -3.85 + self:GetRight() * -6

		render.SetMaterial(glowMaterial)
		render.DrawSprite(position, 10, 10, color)
	end
end
