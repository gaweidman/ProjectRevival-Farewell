
ENT.Type = "anim"
ENT.PrintName = "Talker"
ENT.Category = "Helix"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "NoBubble")
	self:NetworkVar("String", 0, "DisplayName")
	self:NetworkVar("String", 1, "Description")
end

function ENT:Initialize()
	if (SERVER) then
		self:SetModel("models/mossman.mdl")
		self:SetUseType(SIMPLE_USE)
		self:SetMoveType(MOVETYPE_NONE)
		self:DrawShadow(true)
		self:SetSolid(SOLID_BBOX)
		self:PhysicsInit(SOLID_BBOX)

		self.messages = {}
		self.factions = {}
		self.classes = {}

		self:SetNetVar("name", "John Doe")
		self:SetNetVar("description", "")

		self.receivers = {}

		local physObj = self:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end

	timer.Simple(1, function()
		if (IsValid(self)) then
			self:SetAnim()
		end
	end)
end

function ENT:CanAccess(client)
	if (client:IsAdmin()) then
		return true
	end

	local allowed = false
	local uniqueID = ix.faction.indices[client:Team()].uniqueID

	if (self.factions and table.Count(self.factions) > 0) then
		if (self.factions[uniqueID]) then
			allowed = true
		else
			return false
		end
	end

	if (allowed and self.classes and table.Count(self.classes) > 0) then
		local class = ix.class.list[client:getChar():getClass()]
		local uniqueID = class and class.uniqueID

		if (!self.classes[uniqueID]) then
			return false
		end
	end

	return true
end

function ENT:SetAnim()
	for k, v in ipairs(self:GetSequenceList()) do
		if (v:lower():find("idle") and v != "idlenoise") then
			return self:ResetSequence(k)
		end
	end

	self:ResetSequence(4)
end

if (CLIENT) then
	function ENT:CreateBubble()
		self.bubble = ClientsideModel("models/extras/info_speech.mdl", RENDERGROUP_OPAQUE)
		self.bubble:SetPos(self:GetPos() + Vector(0, 0, 84))
		self.bubble:SetModelScale(0.6, 0)
	end

	function ENT:Think()
		if (!IsValid(self.bubble)) then
			self:CreateBubble()
		end

		self:SetEyeTarget(LocalPlayer():GetPos())
	end

	function ENT:Draw()
		local bubble = self.bubble

		if (IsValid(bubble)) then
			local realTime = RealTime()

			bubble:SetAngles(Angle(0, realTime * 120, 0))
			bubble:SetRenderOrigin(self:GetPos() + Vector(0, 0, 84 + math.sin(realTime * 3) * 0.03))
		end

		self:DrawModel()
	end

	function ENT:OnRemove()
		if (IsValid(self.bubble)) then
			self.bubble:Remove()
		end
	end
	
	netstream.Hook("ix_Dialogue", function(data)
		if (IsValid(ix.gui.dialogue)) then
			ix.gui.dialogue:Remove()
			return
		end
		ix.gui.dialogue = vgui.Create("ixDialogue")
		ix.gui.dialogue:Center()
		ix.gui.dialogue:SetEntity(data)
if LocalPlayer():IsAdmin() then
		if (IsValid(ix.gui.edialogue)) then
			ix.gui.dialogue:Remove()
			return
		end
		ix.gui.edialogue = vgui.Create("ixDialogueEditor")
		--ix.gui.edialogue:Center()
		ix.gui.edialogue:SetEntity(data)
end
	end)
	local TEXT_OFFSET = Vector(0, 0, 20)
	local toScreen = FindMetaTable("Vector").ToScreen
	local colorAlpha = ColorAlpha
	local drawText = ix.util.DrawText
	local configGet = ix.config.Get

	ENT.PopulateEntityInfo = true

	function ENT:OnPopulateEntityInfo(container)
		local name = container:AddRow("name")
		name:SetImportant()
		name:SetText(self.GetNetVar(self, "name", "John Doe"))
		name:SizeToContents()

		local descriptionText = self.GetNetVar(self, "description")

		if (descriptionText != "") then
			local description = container:AddRow("description")
			description:SetText(self.GetNetVar(self, "description"))
			description:SizeToContents()
		end
	end
else
	function ENT:Use(activator)
		local factionData = self:GetNetVar("factiondata", {})
		if !factionData[ix.faction.indices[activator:Team()].uniqueID] and !activator:IsSuperAdmin() then
			activator:ChatPrint( self:GetNetVar( "name", "John Doe" )..": I don't want talk with you." )
			return
		end
		netstream.Start(activator, "ix_Dialogue", self)
	end

	netstream.Hook("ix_DialogueData", function( client, data )
		if (!client:IsSuperAdmin()) then
			return
		end
		local entity = data[1]
		local dialogue = data[2]
		local factionData = data[3]
		local classData = data[4]
		local name = data[5]
		local description = data[6]
		local model = data[7]

		
		if (IsValid(entity)) then
			entity:SetNetVar("dialogue", dialogue)
			entity:SetNetVar("factiondata", factionData)
			entity:SetNetVar("classdata", classData)
			entity:SetNetVar("name", name)
			entity:SetNetVar("description", description)
			entity:SetModel(model)
			entity:SetAnim()

			client:Notify("You have updated this talking npc's data.")
		end
	end)

end
