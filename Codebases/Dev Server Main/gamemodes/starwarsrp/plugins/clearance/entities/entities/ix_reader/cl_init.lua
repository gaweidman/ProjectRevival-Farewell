MODE_SWIPE_CARD = {
    ["enum"] = 1, 
    ["msg"] = "Swipe\nCard", 
    ["color"] = Color(255, 255, 255)
}

MODE_ACCESS_GRANTED = {
    ["enum"] = 2, 
    ["msg"] = "Access\nGranted", 
    ["color"] = Color(40, 255, 40)
}

MODE_ACCESS_DENIED = {
    ["enum"] = 3, 
    ["msg"] = "Access\nDenied", 
    ["color"] = Color(255, 40, 40)
}

MODE_OPEN = {
    ["enum"] = 4, 
    ["msg"] = "Open", 
    ["color"] = Color(40, 255, 40)
}

MODE_LOCKDOWN = {
    ["enum"] = 5, 
    ["msg"] = "Locked\nDown", 
    ["color"] = Color(255, 40, 40)
}

MODE_UNDEFINED = {
    ["enum"] = 6, 
    ["msg"] = "UNDEFINED", 
    ["color"] = Color(255, 40, 255)
}


-- Called when the entity initializes.
function ENT:Initialize()
end

-- Called when the entity should draw.
function ENT:Draw()
	self.Entity:DrawModel()
	local mode = self:GetNetVar("mode", MODE_UNDEFINED)

	cam.Start3D2D(self:GetPos() + Vector(0, 0, 9), self:GetAngles() + Angle(0, 0, 0), 0.1)
		draw.DrawText(mode.msg, "ScoreboardDefaultTitle", 0, 0, mode.color, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end