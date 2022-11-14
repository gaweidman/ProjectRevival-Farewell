
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Ration Terminal"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.RenderGroup = RENDERGROUP_BOTH

COLOR_DISABLED = Color(80, 80, 80)
COLOR_START_CYCLE = Color(30, 210, 30)
COLOR_END_CYCLE = Color(210, 30, 0)

START_BUTTON = COLOR_START_CYCLE
END_BUTTON = COLOR_DISABLED

cycleStarted = false

if (true) then
	
	if SERVER then
		function ENT:Initialize()
			self:SetModel( "models/props_combine/combine_interface003.mdl" )
			self:PhysicsInit( SOLID_VPHYSICS )
			self:SetMoveType( MOVETYPE_VPHYSICS )
			self:SetSolid( SOLID_VPHYSICS )
			self:SetUseType( SIMPLE_USE )

			self:SetNetVar("START_BUTTON", COLOR_START_CYCLE)
			self:SetNetVar("END_BUTTON", COLOR_DISABLED)
			cycleStarted = true

			self:SetNetVar("lastCycleTime", math.floor(CurTime()))

		end
	end
	
	function ENT:Use( ply, caller )
		if !cycleStarted then
			self:SetNetVar("START_BUTTON", COLOR_START_CYCLE)
			self:SetNetVar("END_BUTTON", COLOR_DISABLED)
			self:SetNetVar("lastCycleTime", math.floor(CurTime()))
			ix.chat.Send(caller, "dispatchs", "Attention. Rations are no longer available at the train station.", true)
		else
			self:SetNetVar("START_BUTTON", COLOR_DISABLED)
			self:SetNetVar("END_BUTTON", COLOR_END_CYCLE)
			
			ix.chat.Send(caller, "dispatchs", "Attention. Rations are now available at the ration distribution terminal. Reminder: Civil Workers Union members are subject to priority distribution.", true)
		end
		cycleStarted = !cycleStarted
	end

	if (true) then

		function ENT:Draw()

			self:DrawModel()
			
			if (self:GetNetVar("END_BUTTON", COLOR_DISABLED) == COLOR_DISABLED) then
				time = math.floor(CurTime() - self:GetNetVar("lastCycleTime"))
			else
				time = 0
			end

			local seconds = leftoverTime(time)
			local minutes = leftoverTime(timeFactor(time))
			local hours = timeFactor(timeFactor(time))

			local secondDisplay = seconds
			local minuteDisplay = minutes
			local hourDisplay = hours

			if (seconds < 10) then
				secondDisplay = "0"..seconds
			end

			if (minutes < 10) then
				minuteDisplay = "0"..minutes
			end

			if (hours < 10) then
				hourDisplay = "0"..hours
			end



			cam.Start3D2D(self:GetPos() + Vector(50, 50, 0), self:GetAngles() + Angle(0, 90, 45), 0.1)

				draw.RoundedBox(0, 365, -600, 150, 150, self:GetNetVar("START_BUTTON", COLOR_DISABLED))
				draw.RoundedBox(0, 540, -600, 150, 150, self:GetNetVar("END_BUTTON", COLOR_DISABLED))
				draw.DrawText("Start\nCycle", "ScoreboardDefaultTitle", 440, -560, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
				draw.DrawText("End\nCycle", "ScoreboardDefaultTitle", 615, -560, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

				draw.RoundedBox(0, 365, -710, 325, 100, Color(30, 30, 210))
				--draw.DrawText("00:00:00", "ScoreboardDefaultTitle", 527.5, -660, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
				--draw.DrawText(hours..":"..minutes..":"..seconds, "ScoreboardDefaultTitle", 527.5, -660, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
				draw.DrawText(hourDisplay..":"..minuteDisplay..":"..secondDisplay, "ScoreboardDefaultTitle", 527.5, -660, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
				draw.DrawText("Time since last cycle: ", "ScoreboardDefaultTitle", 527.5, -695, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)

			cam.End3D2D()

			--print(os.time()%60)


		end
	end
end

-- When I figured out the algorithm for this, I felt SO SMART.
function leftoverTime(time)
	return time - (math.floor(time/60)*60)
end

function timeFactor(time)
	return math.floor(time/60)
end
