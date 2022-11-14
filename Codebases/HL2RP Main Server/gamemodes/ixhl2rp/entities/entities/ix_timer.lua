
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Detainment Timer"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = true
ENT.bNoPersist = true

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


if (SERVER) then
	function ENT:Initialize()
		self:SetModel("models/props_lab/keypad.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetUseType(SIMPLE_USE)

		local physics = self:GetPhysicsObject()
		physics:EnableMotion(false)
		physics:Sleep()

	end

	function ENT:ReceiveNetAction(cl)
		if cl:GetEyeTrace().Entity != self then return end

		if cl:GetPos():Distance(self:GetPos()) > 96 then return end


		self:EmitSound("buttons/button17.wav")
		local num = net.ReadUInt(4)
		if num == 10 then
			if self:GetNetVar("Beeping", false) then
				self:SoftClear()
			else
				self:Start()
			end
		elseif num == 11 then
			self:Clear()
		elseif !self:GetNetVar("Ticking", false) and !self:GetNetVar("Beeping", false) then
			local typedNum = self:GetNetVar("TypedNum", "")
			if #typedNum > 4 then return end
			typedNum = typedNum..tostring(num)

			self:SetNetVar("TypedNum", typedNum)
		end

		
        self:NetDataUpdate()
    end

	function ENT:Think()
		if self:GetNetVar("Ticking", false) then
			if self:GetNetVar("NextTick", -1) <= CurTime() then
				self:SetNetVar("NextTick", CurTime() + 1)

				local seconds = self:GetNetVar("Seconds", 0)
				local minutes = self:GetNetVar("Minutes", 0)

				print(minutes, seconds)
				if seconds == 0 then
					minutes = minutes - 1
					seconds = 59
				else
					seconds = seconds - 1
				end

				self:SetNetVar("Seconds", seconds)
				self:SetNetVar("Minutes", minutes)

				if seconds <= 0 and minutes <= 0 then
					self:TimeUp()
				end
			end
		elseif self:GetNetVar("Beeping", false) then
			if self:GetNetVar("NextBeep", -1) <= CurTime() then
				local doubleBeep = self:GetNetVar("DoubleBeep", true)
				local curTime = CurTime()
				self:EmitSound("buttons/button17.wav")
				if doubleBeep then
					self:SetNetVar("NextBeep", curTime + 0.1 )
				else
					self:SetNetVar("NextBeep", curTime + 0.75)
				end

				self:SetNetVar("DoubleBeep", !doubleBeep)

			end
			
		end
	end

	function ENT:Clear()
		self:SetNetVar("TypedNum", "")
		self:SetNetVar("Ticking", false)
		self:SetNetVar("Seconds", nil)
		self:SetNetVar("Minutes", nil)
		self:SetNetVar("NextTick", nil)
		self:SetNetVar("NextBeep", nil)
		self:SetNetVar("Beeping", false)
		self:SetNetVar("DoubleBeep", true)
	end

	-- this functionality is why i still have a job
	function ENT:SoftClear()
		self:SetNetVar("Ticking", false)
		self:SetNetVar("Seconds", nil)
		self:SetNetVar("Minutes", nil)
		self:SetNetVar("NextTick", nil)
		self:SetNetVar("NextBeep", nil)
		self:SetNetVar("Beeping", false)
		self:SetNetVar("DoubleBeep", true)
	end

	function ENT:TimeUp()
		self:SetNetVar("Ticking", false)
		self:SetNetVar("Beeping", true)
		self:SetNetVar("NextBeep", CurTime() + 0.5)
	end

	function ENT:Start()
		local typedNum = self:GetNetVar("TypedNum", "")
		while #typedNum < 4 do
			typedNum = "0"..typedNum
		end

		self:SetNetVar("Ticking", true)
		self:SetNetVar("Seconds", tonumber(string.sub(typedNum, 3, 4)))
		self:SetNetVar("Minutes", tonumber(string.sub(typedNum, 0, 2)))
		self:SetNetVar("NextTick", CurTime() + 1)
	end

end

if CLIENT then

	function ENT:NetDataRead()

    end

	--local screenPos = Vector(-11.5, -23.5/2 + 0.28, 1.55 )
	local screenPos = Vector(1.15, -3, 5.45 )
	local screenAng = Angle(0, 90, 90)
	local scale = 80
	local scrH = 10.9 * scale
	local scrW = 6 * scale

	local cursorMat = Material("sprites/arrow")
	local bgMat = Material("phoenix_storms/train_wheel")

	local btnBg = Color(133, 65, 48)
	local btnBgClick = Color(179, 112, 96)
	local btnBgHover = Color(189, 93, 69)

    function ENT:DrawTranslucent(flags)
        self:DrawModel(flags)

        if imgui.Entity3D2D(self, screenPos, screenAng, 1/scale) then
            --surface.SetDrawColor(0, 255, 115, 10)
			--surface.DrawRect(0, 0, scrW, scrH)

			--surface.SetDrawColor(0, 163, 155)
			--surface.DrawRect(0, 15, scrW, 50)

			
			--draw.DrawText("Timer", "DermaLarge", scrW/2, 24, Color(255, 255, 255), TEXT_ALIGN_CENTER)

			local digit1 = math.floor(CurTime()*5)%9
			local digit2 = "2"
			local digit3 = "4"
			local digit4 = "5"

			draw.DrawText("88:88", "7SegDisplayBig", scrW/2, scrH/5 - 10, Color(56, 56, 56, 45), TEXT_ALIGN_CENTER)
			if self:GetNetVar("Ticking", false) then
				local minutes = tostring(self:GetNetVar("Minutes", 0))
				local seconds = tostring(self:GetNetVar("Seconds", 0))

				if #minutes == 1 then minutes = "0"..minutes end
				if #seconds == 1 then seconds = "0"..seconds end

				draw.DrawText(minutes..":"..seconds, "7SegDisplayBig", scrW/2, scrH/5 - 10, Color(0, 0, 0), TEXT_ALIGN_CENTER)
			elseif self:GetNetVar("Beeping", false) then
				draw.DrawText("00:00", "7SegDisplayBig", scrW/2, scrH/5 - 10, Color(0, 0, 0), TEXT_ALIGN_CENTER)
			else
				local typedNum = self:GetNetVar("TypedNum", "")
				while #typedNum < 4 do
					typedNum = "0"..typedNum
				end
				typedNum = string.sub(typedNum, 0, 2)..":"..string.sub(typedNum, 3, 4)
				draw.DrawText(typedNum, "7SegDisplayBig", scrW/2, scrH/5 - 10, Color(0, 0, 0), TEXT_ALIGN_CENTER)
			end
			
			local btnSize = 95
			local btnMargin = 12

			local row1 = 340
			local row2 = row1 + btnSize + btnMargin
			local row3 = row1 + btnSize*2 + btnMargin*2
			local row4 = row1 + btnSize*3 + btnMargin*3
			local col1 = scrW/2 - btnSize/2 - btnSize - btnMargin
			local col2 = scrW/2 - btnSize/2
			local col3 = scrW/2 - btnSize/2 + btnSize + btnMargin

			surface.SetDrawColor(46, 46, 46)
			surface.DrawRect(col1 - btnMargin, row1 - btnMargin, btnSize*3 + btnMargin*4, btnSize*4 + btnMargin*5)
			
			if imgui.xFillTextButton("1", "!Roboto@60", col1, row1, btnSize, btnSize, color_black, btnBg, btnBgHover, btnBgClick) then 
				self:StartNetAction()
					net.WriteUInt(1, 4)
                net.SendToServer()
			elseif imgui.xFillTextButton("2", "!Roboto@60", col2, row1, btnSize, btnSize, color_black, btnBg, btnBgHover, btnBgClick) then 
				self:StartNetAction()
					net.WriteUInt(2, 4)
                net.SendToServer()
			elseif imgui.xFillTextButton("3", "!Roboto@60", col3, row1, btnSize, btnSize, color_black, btnBg, btnBgHover, btnBgClick) then 
				self:StartNetAction()
					net.WriteUInt(3, 4)
                net.SendToServer()
			elseif imgui.xFillTextButton("4", "!Roboto@60", col1, row2, btnSize, btnSize, color_black, btnBg, btnBgHover, btnBgClick) then 
				self:StartNetAction()
				net.WriteUInt(4, 4)
                net.SendToServer()
			elseif imgui.xFillTextButton("5", "!Roboto@60", col2, row2, btnSize, btnSize, color_black, btnBg, btnBgHover, btnBgClick) then 
				self:StartNetAction()
					net.WriteUInt(5, 4)
                net.SendToServer()
			elseif imgui.xFillTextButton("6", "!Roboto@60", col3, row2, btnSize, btnSize, color_black, btnBg, btnBgHover, btnBgClick) then 
				self:StartNetAction()
					net.WriteUInt(6, 4)
                net.SendToServer()
			elseif imgui.xFillTextButton("7", "!Roboto@60", col1, row3, btnSize, btnSize, color_black, btnBg, btnBgHover, btnBgClick) then
				self:StartNetAction()
					net.WriteUInt(7, 4)
                net.SendToServer()
			elseif imgui.xFillTextButton("8", "!Roboto@60", col2, row3, btnSize, btnSize, color_black, btnBg, btnBgHover, btnBgClick) then
				self:StartNetAction()
					net.WriteUInt(8, 4)
                net.SendToServer()
			elseif imgui.xFillTextButton("9", "!Roboto@60", col3, row3, btnSize, btnSize, color_black, btnBg, btnBgHover, btnBgClick) then
				self:StartNetAction()
					net.WriteUInt(9, 4)
                net.SendToServer()
			elseif imgui.xFillTextButton("S", "!Roboto@60", col1, row4, btnSize, btnSize, color_black, btnBg, btnBgHover, btnBgClick) then
				self:StartNetAction()
					net.WriteUInt(10, 4)
                net.SendToServer()
			elseif imgui.xFillTextButton("0", "!Roboto@60", col2, row4, btnSize, btnSize, color_black, btnBg, btnBgHover, btnBgClick) then
				self:StartNetAction()
					net.WriteUInt(0, 4)
                net.SendToServer()
			elseif imgui.xFillTextButton("C", "!Roboto@60", col3, row4, btnSize, btnSize, color_black, btnBg, btnBgHover, btnBgClick) then 
				self:StartNetAction()
					net.WriteUInt(11, 4)
                net.SendToServer()
			end
			
			local mX, mY = imgui.CursorPos()	
			local dist = LocalPlayer():GetPos():Distance(self:GetPos())

			if mX and mY and mX > 0 and mY > 0 and mX <= scrW and mY <= scrH and dist <= 96 then
				mX, mY = mX - 9*5, mY - 9*5

				local origCrsWidth = 100
				local origCrsHeight = 100

				local crsWidth = origCrsWidth
				local crsHeight = origCrsHeight

				local crsU = 1
				local crsV = 1

				if imgui.IsHovering(0, scrH - crsHeight/2, scrW, scrH) then
					local yDiff = scrH - mY

					crsHeight = yDiff
					crsV = yDiff/origCrsHeight
				end

				if imgui.IsHovering(scrW - crsWidth/2, 0, scrW, scrH) then
					local xDiff = scrW - mX
					
					crsWidth = xDiff
					crsU = xDiff/origCrsWidth
				end
				
				surface.SetDrawColor(255, 255, 255)
                surface.SetMaterial(cursorMat)

                surface.DrawTexturedRectUV(mX, mY, crsWidth, crsHeight, 0, 0, crsU, crsV)
			end

			
        imgui.End3D2D()
		end
        
    end
end