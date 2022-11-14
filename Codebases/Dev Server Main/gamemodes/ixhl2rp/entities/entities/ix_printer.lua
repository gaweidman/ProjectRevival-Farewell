
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Printer"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_interiors/printer.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()

        self.paperCount = 0
	end

	function ENT:Use(client, caller, useType)
        if (self.paperCount >= 1) then
            netstream.Start(client, "ixViewPaper", nil, "", 1, "printed")
            self.paperCount = self.paperCount - 1
        else
            client:Notify("The printer is out of paper!")
        end
        print(self.paperCount)
	end

    function ENT:StartTouch(otherEnt)
        if otherEnt:GetClass() == "ix_item" then
            local item = otherEnt:GetItemTable()
            print(item.uniqueID)
            if item.uniqueID == "copypaper" then
                otherEnt:Remove()
                self.paperCount = self.paperCount + 15
            elseif item.uniqueID == "paper" then
                otherEnt:Remove()
                self.paperCount = self.paperCount + 1
            end

            print(self.paperCount)
        end
    end
end

if (CLIENT) then
	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(tooltip)
		local name = tooltip:AddRow("name")
		name:SetImportant()
		name:SetText("Printer")
		name:SizeToContents()

		local description = tooltip:AddRow("description")
		description:SetText("A pre-war printer, capable of printing official-looking documents as long as it has enough paper.")
		description:SizeToContents()
	end

    function ENT:Draw()
        self:DrawModel()
        /*
        local prop = {
            ["x"] = self:GetPos()[1],
            ["y"] = self:GetPos()[2],
            ["z"] = self:GetPos()[3],
            ["pitch"] = self:GetAngles()[1],
            ["yaw"] = self:GetAngles()[2],
            ["roll"] = self:GetAngles()[3]
        }

        --cam.Start3D2D(Vector(prop.x - 12, prop.y + 13, prop.z + 10), Angle(prop.pitch, prop.yaw, prop.roll), 1)
        cam.Start3D2D(Vector(prop.x, prop.y+ 13, prop.z), Angle(prop.pitch, prop.yaw, prop.roll+90), 1)
            --surface.SetFont()
            surface.SetDrawColor(Color(150, 255, 150))
            surface.DrawRect(-12, -10, 180, 30)
        cam.End3D2D()\
        */
    end
end