local PLUGIN = PLUGIN
ENT.Type = "anim"
ENT.PrintName = "Alloy Basin"
ENT.Author = "La Corporativa"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "NutScript"
ENT.RenderGroup = RENDERGROUP_BOTH

if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_wasteland/laundry_washer001a.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:Sleep()
		end
	end

	function ENT:Use(activator)
		local data = activator:getChar():getData("alloyableItems", {})
		netstream.Start(activator, "nut_lc_alloywindow", activator, data, self)
	end

	netstream.Hook("nut_lc_Delete", function(client,caller)
		client:getChar():getInv():add(caller.item)
		caller:Remove()
	end)

else

	netstream.Hook("nut_lc_alloywindow", function(client, data, ent)
		if (IsValid(nut.gui.alloywindow)) then
			return
		end
		if (IsValid(ent)) then
			surface.PlaySound("items/ammocrate_close.wav")
			nut.gui.alloywindow = vgui.Create("nut_lc_Alloying")
			nut.gui.alloywindow.alloyableitems = data
			nut.gui.alloywindow.caller = ent
			nut.gui.alloywindow.title = ent:getNetVar("title")
			nut.gui.alloywindow:Center()
			nut.gui.alloywindow.done = true
		end
	end)

	function ENT:Draw()
		self:DrawModel()
	end

	ENT.DisplayVector = Vector( 0, 0, 18.5 )
	ENT.DisplayAngle = Angle( 0, 90, 0 )
	ENT.DisplayScale = .5

	function ENT:DrawTranslucent()
		local pos = self:GetPos() + self:GetUp() * self.DisplayVector.z + self:GetRight() * self.DisplayVector.x + self:GetForward() * self.DisplayVector.y
		local ang = self:GetAngles()
		ang:RotateAroundAxis( self:GetRight(), self.DisplayAngle.pitch ) -- pitch
		ang:RotateAroundAxis( self:GetUp(),  self.DisplayAngle.yaw )-- yaw
		ang:RotateAroundAxis( self:GetForward(), self.DisplayAngle	.roll )-- roll
		cam.Start3D2D( pos, ang, self.DisplayScale )
			surface.SetDrawColor( 0, 0, 0 )
			surface.SetTextColor( 255, 255, 255 )
			surface.SetFont( "ChatFont" )
			local size = { x = 10, y = 10 }
			size.x, size.y = surface.GetTextSize(self:getNetVar("title", ""))
			surface.SetTextPos( -size.x/2, -size.y/2 )
			size.x = size.x + 20; size.y = size.y + 15
			surface.DrawText(self:getNetVar("title", ""))
		cam.End3D2D()
	end
end
