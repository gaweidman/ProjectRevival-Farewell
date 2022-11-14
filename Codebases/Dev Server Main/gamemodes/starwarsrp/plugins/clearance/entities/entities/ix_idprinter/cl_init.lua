-- Called when the entity initializes.
function ENT:Initialize()
end

-- Called when the entity should draw.
function ENT:Draw()
	self.Entity:DrawModel()

	print(math.ceil(self:GetAngles()[1]) .." "..math.ceil(self:GetAngles()[2]).." "..math.ceil(self:GetAngles()[3]))
	print()

	local yaw = self:GetAngles()[2]

	cam.Start3D2D(self:GetPos() + Vector(0, 0, 8), Angle(0, yaw+90, 75), 0.1)
		draw.DrawText("Identichip Printer", "ScoreboardDefaultTitle", 0, 0, Color(55, 110, 183), TEXT_ALIGN_CENTER)
	cam.End3D2D()
end