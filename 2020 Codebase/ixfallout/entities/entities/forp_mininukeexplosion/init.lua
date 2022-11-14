AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

local WaveResolution = 0.1
local WaveSpeed = 9000

function ENT:Initialize()

	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:DrawShadow(false)
	self.Entity:SetNotSolid(true)
	self.Position = self.Entity:GetPos()
	self.Scale = 1
	self.EffectScale = self.Scale^0.65
	self.BlastScale = self.Scale^0.74
	
	local trace = {}
	trace.start = self.Position + Vector(0,0,32)
	trace.endpos = self.Position - Vector(0,0,128)
	trace.Entity = self.Entity
	trace.mask  = 16395
	local Normal = util.TraceLine(trace).HitNormal
	
	self.Origin = self.Position + Vector(0,0,8) + 32*Normal
	self.LastThink = CurTime() + 0.1
	self.WaveDist = 0

	local effectdata = EffectData()
	effectdata:SetOrigin(self.Position)
	effectdata:SetNormal(Normal)
	effectdata:SetScale(self.EffectScale)
	util.Effect("effect_fo3_fatman",effectdata)
	
	local BlastRadius = 600*self.BlastScale
	local KillTime = BlastRadius/WaveSpeed
	if BlastRadius > 10000 then BlastRadius = 10000 end
	KillTime = KillTime + 0.12
	KillTime = math.ceil(KillTime/WaveResolution)*WaveResolution
	
	self.Entity:Fire("kill","",KillTime)
	
		local position = self.Position
local damage = 600
local radius = 1700
local attacker = self.Entity
local inflictor = self.Entity
 
util.BlastDamage(inflictor, attacker, position, radius, damage)
	
	self.Sploding = true

end


function ENT:Think()

	if not self.Sploding then return end

	local CurrentTime = CurTime()
	local FTime = CurrentTime - self.LastThink

	if FTime < WaveResolution then return end
	
	self.WaveDist = self.WaveDist + WaveSpeed*FTime
	self.LastThink = CurrentTime
	
	local PowerScale = WaveResolution*self.BlastScale*400/self.WaveDist

	for key,found in pairs(ents.FindInSphere(self.Origin,self.WaveDist)) do

		local movetype = found:GetMoveType()
		local IsPhysObj = movetype == 6
		local valid = (found:IsValid() and
					(movetype == 2 or 
					movetype == 3 or 
					movetype == 5 or 
					movetype == 9 or 
					IsPhysObj))
		if valid then
		
			local entpos = found:LocalToWorld(found:OBBCenter()) --more accurate than getpos
			local force = (entpos - self.Position):GetNormalized()*5e5*PowerScale
			local class = found:GetClass()
			local physobj = found:GetPhysicsObject()
			
			local dmginfo = DamageInfo(DMG_BLAST) --This doesn't work : /
			if found:IsNPC() and 
				(class == "npc_strider" or
				class == "npc_antliongaurd" or
				class == "npc_combinegunship" or
				class == "npc_combinedropship" or
				class == "npc_helicopter") then
				
				dmginfo:SetDamage(4000*PowerScale)
			else
				dmginfo:SetDamage(600*PowerScale)
			end
			dmginfo:SetAttacker(self.Owner)
			dmginfo:SetInflictor(self.Entity)
			dmginfo:SetDamageForce(force)
			found:DispatchTraceAttack(dmginfo, self.Origin, entpos)
			
			util.BlastDamage(self.Entity, self.Owner, entpos, 12, 3)
			
				if physobj:IsValid() and IsPhysObj and not (class == "prop_ragdoll") then
					physobj:ApplyForceOffset(force,entpos + Vector(math.random(-20,20),math.random(-20,20),math.random(20,40)))
				end	

		end

		
	end

end


