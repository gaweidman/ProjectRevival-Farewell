

AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Blood Donation Station"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/ccr/props/blood_donator.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()
		
		self.totalHP = 50
	end

	function ENT:SpawnFunction(client, trace)
		local vendor = ents.Create("ix_blooddono")

		vendor:SetPos(trace.HitPos)
		vendor:SetAngles(Angle(0, (vendor:GetPos() - client:GetPos()):Angle().y - 180, 0))
		vendor:Spawn()
		vendor:Activate()

		return vendor
	end

	local isDrawingBlood = false
	function ENT:Use(client, caller, useType)

		-- Freezing taken out because of permanent freezing on leaving the entity's radius.
		if client:GetCharacter():GetData("lastBloodDonation", os.time() + 129601) > os.time() + 129600 and !isDrawingBlood then
			--client:Notify(client:GetPos():DistToSqr(self:GetPos()))
			--client:Notify(25*25)
			if client:GetPos():DistToSqr(self:GetPos()) > 70*70 then
				return
			end

			if isDrawingBlood then
				return
			end

			isDrawingBlood = true
			client:Freeze(true)

			client:SetAction("Drawing blood...", 15)

			client:DoStaredAction(self, function()
				
				client:TakeDamage(5, client, self)

				if client:Health() <= 30 then
					client:SetRagdolled(true, 45, 0)
					client:Notify("You passed out because you were so hurt!")
				end

				client:Freeze(false)

				client:GetCharacter():GiveMoney(10)
				client:Notify("You gained 10 tokens!")
				client:GetCharacter():SetData("lastBloodDonation", os.time())

				--client:ChatPrint("this worked")

				isDrawingBlood = false

			end, 15, function()
			
				client:NotifyLocalized("Your blood is no longer being drawn.")
				--client:ChatPrint("another test")
				client:SetAction(nil)
				client:Freeze(false)

				isDrawingBlood = false

			end, 96)

		else

			client:Notify("You donated blood too recently!")
			return

		end

	end
end

if (CLIENT) then
	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(tooltip)
		local name = tooltip:AddRow("name")
		name:SetImportant()
		name:SetText("Blood Donation Machine")
		name:SizeToContents()

		local description = tooltip:AddRow("description")
		description:SetText("A flat panel resembling a Combine energy outlet, with a padded slot to insert your arm into.")
		description:SizeToContents()
	end
end