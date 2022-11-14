
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Generic Actor"
ENT.Category = "Roleplay"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.PhysgunDisable = false
ENT.bNoPersist = true


function ENT:Initialize()
    if (SERVER) then
        self:SetModel("models/gman_high.mdl")
        self:ResetSequence("idle01")
        self:PhysicsInit(SOLID_BBOX)
        self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(true)
        self:SetSolid(SOLID_BBOX)
        self:SetUseType(SIMPLE_USE)

        local physics = self:GetPhysicsObject()
        physics:EnableMotion(false)
        physics:Sleep()

        self.IsCrying = true 
        self.NextCry = CurTime()
        self.CryMessages = {"Credits for scrap, here only!", "You have scrap, we have credits!", "We buy your scrap!"}
    end

    
end

if SERVER then

    function ENT:SetupVisuals(model, sequence)
        self:SetModel(model)
        timer.Simple(0, function()
            self:ResetSequence(sequence)
        end)
    end

    function ENT:SpawnFunction(ply, tr, className)
        if ( !tr.Hit ) then return end

        local SpawnPos = tr.HitPos - tr.HitNormal*0.1
        local SpawnAng = ply:EyeAngles()
        SpawnAng.p = 0
        SpawnAng.y = SpawnAng.y + 180

        local ent = ents.Create( ClassName )
        ent:SetPos( SpawnPos )
        ent:SetAngles(SpawnAng)
        ent:Spawn()
        ent:Activate()

        return ent
    end

    function ENT:Use(client, caller, useType)
        if self.UseMessages != nil and self.UseMessages[1] != "" then
            local receivers = ents.FindInSphere(self:GetPos(), ix.config.Get("chatRange", 280))

            local message = self.UseMessages[math.random(1, #self.UseMessages)]

            net.Start("ixNPCMessage")
                net.WriteEntity(self)
                net.WriteString(message)
            net.Send(receivers)
        end
    end

end

function ENT:StartTouch(otherEnt)

end

function ENT:Think()
    if SERVER then
        if CurTime() >= self.NextCry then
            
            if self.CryMessages != nil and self.CryMessages[1] != "" then
                local message = self.CryMessages[math.random(1, #self.CryMessages)]
                
                while message == self.lastMessage do
                    message = self.CryMessages[math.random(1, #self.CryMessages)]
                end

                self.lastMessage = message

                self.NextCry = CurTime() + math.random(1, 3)

                local receivers = ents.FindInSphere(self:GetPos(), ix.config.Get("chatRange", 280))

                net.Start("ixNPCMessage")
                    net.WriteEntity(self)
                    net.WriteString(message)
                net.Send(receivers)
            end
        end
    end
end

if (CLIENT) then
	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(tooltip)
		local name = tooltip:AddRow("name")
		name:SetImportant()
		name:SetText(self:GetNetVar("name", "Generic Actor"))
		name:SizeToContents()

		local description = tooltip:AddRow("description")
		description:SetText(self:GetNetVar("description", "A generic actor."))
		description:SizeToContents()
	end

    function ENT:Draw()
        self:DrawModel()
    end
end

properties.Add("SetModel", {
    MenuLabel = "Set Model",
    MenuIcon = "icon16/user_edit.png",

    Filter = function(self, ent, ply)
        local userGroup = ply:GetUserGroup()
        local isStaff = userGroup == "admin" or userGroup == "administrator" or userGroup == "superadmin" or userGroup == "founder" or userGroup == "mod" or userGroup == "moderator" or userGroup == "trialmod" or userGroup == "trialmoderator"
        return isStaff and (ent:GetClass() == "ix_npcgeneric" or ent:GetClass() == "ix_actorgeneric")
    end,

    Action = function(self, ent)
        self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
    end, 

    Receive = function(self, length, ply)
        local ent = net.ReadEntity()
        
        if !self:Filter(ent, ply) then return end

        ply:RequestString("Set Model", "Paste in the path of the model here.", function(text)
            ent:SetModel(text)
            ent:ResetSequence(ent:GetNetVar("sequence", "idle01"))
        end, "")

    end
})

properties.Add("SetCryMessages", {
    MenuLabel = "Set Cry Messages",
    MenuIcon = "icon16/comment_edit.png",

    Filter = function(self, ent, ply)
        local userGroup = ply:GetUserGroup()
        local isStaff = userGroup == "admin" or userGroup == "administrator" or userGroup == "superadmin" or userGroup == "founder" or userGroup == "mod" or userGroup == "moderator" or userGroup == "trialmod" or userGroup == "trialmoderator"
        return isStaff and (ent:GetClass() == "ix_npcgeneric" or ent:GetClass() == "ix_actorgeneric")
    end,

    Action = function(self, ent)
        self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
    end, 

    Receive = function(self, length, ply)
        local ent = net.ReadEntity()
        
        if !self:Filter(ent, ply) then return end

        local messagesStr = table.concat(ent.CryMessages or {}, "^")

        ply:RequestString("Set Messages", "Write in your messages here, separated by ^ signs.", function(text)
            ent.CryMessages = string.Explode("^", text)
            
        end, messagesStr)

    end
})

properties.Add("SetUseMessage", {
    MenuLabel = "Set Use Message",
    MenuIcon = "icon16/group.png",

    Filter = function(self, ent, ply)
        local userGroup = ply:GetUserGroup()
        local isStaff = userGroup == "admin" or userGroup == "administrator" or userGroup == "superadmin" or userGroup == "founder" or userGroup == "mod" or userGroup == "moderator" or userGroup == "trialmod" or userGroup == "trialmoderator"
        return isStaff and (ent:GetClass() == "ix_npcgeneric" or ent:GetClass() == "ix_actorgeneric")
    end,

    Action = function(self, ent)
        self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
    end, 

    Receive = function(self, length, ply)
        local ent = net.ReadEntity()

        if !self:Filter(ent, ply) then return end

        local messagesStr = table.concat(ent.UseMessages or {}, "^")

        ply:RequestString("Set Use Messages", "Write in your use messages here, separated by ^ signs.", function(text)
            ent.UseMessages = string.Explode("^", text)
        end, messagesStr)

    end
})

properties.Add("SetName", {
    MenuLabel = "Set Name",
    MenuIcon = "icon16/user_edit.png",

    Filter = function(self, ent, ply)
        local userGroup = ply:GetUserGroup()
        local isStaff = userGroup == "admin" or userGroup == "administrator" or userGroup == "superadmin" or userGroup == "founder" or userGroup == "mod" or userGroup == "moderator" or userGroup == "trialmod" or userGroup == "trialmoderator"
        return isStaff and (ent:GetClass() == "ix_npcgeneric" or ent:GetClass() == "ix_actorgeneric")
    end,

    Action = function(self, ent)
        self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
    end, 

    Receive = function(self, length, ply)
        local ent = net.ReadEntity()

        if !self:Filter(ent, ply) then return end

        ply:RequestString("Set Name", "Write the actor's name here.", function(text)
            ent:SetNetVar("name", text)
        end, ent:GetNetVar("name", "Generic Actor"))

    end
})

properties.Add("SetDescription", {
    MenuLabel = "Set Description",
    MenuIcon = "icon16/user_edit.png",

    Filter = function(self, ent, ply)
        local userGroup = ply:GetUserGroup()
        local isStaff = userGroup == "admin" or userGroup == "administrator" or userGroup == "superadmin" or userGroup == "founder" or userGroup == "mod" or userGroup == "moderator" or userGroup == "trialmod" or userGroup == "trialmoderator"
        return isStaff and (ent:GetClass() == "ix_npcgeneric" or ent:GetClass() == "ix_actorgeneric")
    end,

    Action = function(self, ent)
        self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
    end, 

    Receive = function(self, length, ply)
        local ent = net.ReadEntity()
        
        if !self:Filter(ent, ply) then return end

        ply:RequestString("Set Description", "Write the actor's description here.", function(text)
            ent:SetNetVar("description", text)
        end, ent:GetNetVar("description", "A generic actor."))

    end
})

properties.Add("SetAnimation", {
    MenuLabel = "Set Animation",
    MenuIcon = "icon16/film_edit.png",

    Filter = function(self, ent, ply)
        local userGroup = ply:GetUserGroup()
        local isStaff = userGroup == "admin" or userGroup == "administrator" or userGroup == "superadmin" or userGroup == "founder" or userGroup == "mod" or userGroup == "moderator" or userGroup == "trialmod" or userGroup == "trialmoderator"
        return isStaff and (ent:GetClass() == "ix_npcgeneric" or ent:GetClass() == "ix_actorgeneric")
    end,

    Action = function(self, ent)
        self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()
    end, 

    Receive = function(self, length, ply)
        local ent = net.ReadEntity()
        
        if !self:Filter(ent, ply) then return end

        ply:RequestString("Set Description", "Enter the name of the sequence.", function(text)
            ent:ResetSequence(text)
        end, ent:GetSequenceName(ent:GetSequence()))

    end
})