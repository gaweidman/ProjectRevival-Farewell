local rowPaintFunctions = {
	function(width, height)
	end,

	function(width, height)
		surface.SetDrawColor(30, 30, 30, 25)
		surface.DrawRect(0, 0, width, height)
	end
}

local containerRows
local containerFactions

-- character icon
-- we can't customize the rendering of ModelImage so we have to do it ourselves

PANEL = {}

DEFINE_BASECLASS("Panel")

AccessorFunc(PANEL, "player", "Player")

function PANEL:Init()

	self:SetTall(64)

	self.avatar = self:Add("AvatarImage")
	self.avatar:SetSize(64, 64)
	self.avatar:Dock(LEFT)
	
	self.modelIcon = self:Add("ixScoreboardIcon")
	self.modelIcon:Dock(LEFT)
	self.modelIcon:SetSize(64, 64)

	local charInfo = self:Add("Panel")
	charInfo:Dock(FILL)
	charInfo:SetTall(64)

	self.nameLbl = charInfo:Add("DLabel")
	self.nameLbl:Dock(TOP)
	self.nameLbl:SetFont("prSmallHeadingFont")
	self.nameLbl:DockMargin(10, 0, 0, 0)
	self.nameLbl:SizeToContents()
	
	self.descLbl = charInfo:Add("DLabel")
	self.descLbl:Dock(TOP)
	self.descLbl:DockMargin(10, -7, 0, 0)
	self.descLbl:SetFont("prSmallMenuFont")
	self.descLbl:SizeToContents()

	local miscData = self:Add("Panel")
	miscData:Dock(RIGHT)
	miscData:SetSize(64, 64)

	self.pingLbl = miscData:Add("ixLabel")
	self.pingLbl:Dock(TOP)
	self.pingLbl:SetFont("prSmallMenuBtnFont")
	self.pingLbl:SetSize(64, 32)
	self.pingLbl:SetContentAlignment(6)
	self.pingLbl:DockMargin(0, 0, 5, 0)

	self.nextThink = CurTime() + 0.5
end

function PANEL:Update()
	local client = self.player
	local model = client:GetModel()
	local skin = client:GetSkin()
	local name = client:GetName()
	local description = hook.Run("GetCharacterDescription", client) or
		(client:GetCharacter() and client:GetCharacter():GetDescription()) or ""

	local bRecognize = false
	local localCharacter = LocalPlayer():GetCharacter()
	local character = IsValid(self.player) and self.player:GetCharacter()

	if (localCharacter and character) then
		bRecognize = hook.Run("IsCharacterRecognized", localCharacter, character:GetID())
			or hook.Run("IsPlayerRecognized", self.player)
	end

	self.modelIcon:SetHidden(!bRecognize)
	self:SetZPos(bRecognize and 1 or 2)

	-- no easy way to check bodygroups so we'll just set them anyway
	for _, v in pairs(client:GetBodyGroups()) do
		self.modelIcon:SetBodygroup(v.id, client:GetBodygroup(v.id))
	end

	if (self.modelIcon:GetModel() != model or self.modelIcon:GetSkin() != skin) then
		self.modelIcon:SetModel(model, skin)
		self.modelIcon:SetTooltip(nil)
	end

	if (self.nameLbl:GetText() != name) then
		self.nameLbl:SetText(name)
		self.nameLbl:SizeToContents()
	end

	

	if (self.descLbl:GetText() != description) then
		self.descLbl:SetText(description)
		self.descLbl:SizeToContents()
	end
end

function PANEL:SetPlayer(ply)
	self.player = ply

	local char = ply:GetCharacter()
	self.modelIcon:SetModel(ply:GetModel())
	self.avatar:SetPlayer(ply, 64)
	self.nameLbl:SetText(char:GetName())
	self.nameLbl:SizeToContents()

	local model = ply:GetModel()
	local skin = ply:GetSkin()
	local name = ply:GetName()
	local description = hook.Run("GetCharacterDescription", ply) or
		(ply:GetCharacter() and ply:GetCharacter():GetDescription()) or ""

	self.nameLbl:SetText(name)
	self.nameLbl:SizeToContents()
	self.descLbl:SetText(description)
	self.descLbl:SizeToContents()
	self.modelIcon:SetModel(model, skin)
	self.modelIcon:SetTooltip(nil)

	local bRecognize = false
	local localCharacter = LocalPlayer():GetCharacter()
	local character = IsValid(self.player) and self.player:GetCharacter()

	if (localCharacter and character) then
		bRecognize = hook.Run("IsCharacterRecognized", localCharacter, character:GetID())
			or hook.Run("IsPlayerRecognized", self.player)
	end

	self.modelIcon:SetHidden(!bRecognize)
	self:SetZPos(bRecognize and 1 or 2)

	self.pingLbl:SetText("Ping: "..ply:Ping())

	self.avatar:SetHelixTooltip(function(tooltip)
		local client = self.player

		if (IsValid(self) and IsValid(client)) then
			ix.hud.PopulatePlayerTooltip(tooltip, client)
		end
	end)

	self.nextPing = CurTime() + 5
end

function PANEL:GetPlayer()
	return self.player
end

function PANEL:Think()
	if CurTime() >= self.nextPing then
		self.nextPing = CurTime() + 5
		self.pingLbl:SetText("Ping: "..self.player:Ping())
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(65, 65, 65)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(39, 39, 39)
	surface.DrawRect(64, 0, 64, 64)
	
	for k, v in pairs(self:GetChildren()) do
		v:PaintManual()
	end
end

vgui.Register("prScoreboardRow", PANEL, "Panel")

PANEL = {}

DEFINE_BASECLASS("Panel")

AccessorFunc(PANEL, "faction", "Faction")

function PANEL:Init()
	self:SetTall(32)

	self.header = self:Add("Panel")
	self.header:SetTall(32)
	self.header:Dock(TOP)

	self.label = self.header:Add("DLabel")
	self.label:Dock(LEFT)
	self.label:DockMargin(5, 1, 0, 0)
	self.label:SetFont("prCategoryHeadingFont")
	self.label:SizeToContents()

	self.nextThink = CurTime() + 0.5

	self.rows = {}
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(self.color or Color(126, 126, 0))
	surface.DrawRect(0, 0, w, self.header:GetTall())
end

function PANEL:AddRow(row)
	row:SetParent(self)
	row:Dock(TOP)

	self.rows[#self.rows + 1] = row

	self:SetTall(32 + #self.rows*64)
end


function PANEL:Update()
	local faction = self.faction

	local expectedPlayers = {}

	local facPlayers = team.GetPlayers(faction.index)

	for k, ply in ipairs(facPlayers) do
		local shouldShow = hook.Run("ShouldShowPlayerOnScoreboard", ply)
		if shouldShow != false then
			expectedPlayers[#expectedPlayers + 1] = ply
		end
	end
	

	if #expectedPlayers == 0 then
		self:Remove()
		self:InvalidateParent()
		containerFactions[faction.index] = nil
		return
	end

	if #self.rows < #expectedPlayers then
		for _, ply in ipairs(expectedPlayers) do
			if !table.HasValue(self.rows, ply.ixScoreboardSlot) then
				if ply:GetCharacter() == nil then return end
				local row = self:Add("prScoreboardRow")
				self:AddRow(row)
				row:Dock(TOP)
				row:SetTall(64)
				row:SetPlayer(ply)
				ply.ixScoreboardSlot = row
			else
				ply.ixScoreboardSlot:Update()
			end
			self:InvalidateLayout()
		end
	elseif #self.rows > #expectedPlayers then
		for _, row in ipairs(self.rows) do
			if !table.HasValue(expectedPlayers, row.player) then
				row:Remove()
			else
				row:Update()
			end
			self:InvalidateLayout()
		end
	end
end

function PANEL:Think()
end

function PANEL:SetFaction(faction)
	self.color = faction.color
	self.label:SetText(faction.name)
	self.label:SizeToContents()
end

vgui.Register("prScoreboardCategory", PANEL, "Panel")

hook.Add("CreateMenuButtons", "ixScoreboard", function(tabs)
	tabs["playerlist"] = {
		populate = function(container)
			container.scrollPanel = container:Add("DScrollPanel")
			container.scrollPanel:Dock(FILL)

			container.nextThink = CurTime() + 0.5

			container.scrollPanel:GetCanvas():DockPadding(32, 16, 32, 16)
		
			container.Paint = function(panel, w, h)
				surface.SetDrawColor(44, 44, 44)
				surface.DrawRect(0, 0, w, h)
			end

			container.rows = {}
			containerRows = container.rows
			container.factions = {}
			containerFactions = container.factions

			function container:Think()
				if (CurTime() >= self.nextThink) then
					for k, v in pairs(container.factions) do
						v:Update()
					end

					local expectedFactions = {}
				
					for k, v in ipairs(player.GetAll()) do
						if v:GetCharacter() then
							if !table.HasValue(expectedFactions, v:GetCharacter():GetFaction()) then
								table.insert(expectedFactions, v:GetCharacter():GetFaction())
							end
						end
					end

					if table.Count(container.factions) < #expectedFactions then
						for k, expectedFac in ipairs(expectedFactions) do
							if container.factions[expectedFac] == nil then
								local category = container.scrollPanel:Add("prScoreboardCategory")
								container.scrollPanel:AddItem(category)
								category:Dock(TOP)
								category:SetTall(64)
								category:SetFaction(ix.faction.Get(expectedFac))
								category.faction = ix.faction.Get(expectedFac)
			
								category:DockMargin(0, 0, 0, 16)
			
								container.factions[expectedFac] = category

								category:Update()
							end
						end
					end

					self.nextThink = CurTime() + 0.5
				end
			end
			
			function container:Populate()
				local factions = {}
				
				for k, v in ipairs(player.GetAll()) do
					if v:GetCharacter() then
						if !table.HasValue(factions, v:GetCharacter():GetFaction()) then
							table.insert(factions, v:GetCharacter():GetFaction())
						end
					end
				end

				local categories = {}

				for k, v in ipairs(factions) do
					local category = container.scrollPanel:Add("prScoreboardCategory")
					container.scrollPanel:AddItem(category)
					category:Dock(TOP)
					category:SetTall(64)
					category:SetFaction(ix.faction.Get(v))
					category.faction = ix.faction.Get(v)

					category:DockMargin(0, 0, 0, 16)

					categories[v] = category
					container.factions[v] = category
				end

				for k, v in ipairs(player.GetAll()) do
					if v:GetCharacter() and hook.Run("ShouldShowPlayerOnScoreboard", client) != false then
						local row = vgui.Create("prScoreboardRow")
						categories[v:GetCharacter():GetFaction()]:AddRow(row)
						row:Dock(TOP)
						row:SetTall(64)
						row:SetPlayer(v)
						v.ixScoreboardSlot = row 

						container.rows[#container.rows + 1] = row
					end
				end

			end

			function container:GetFactions()
				return self.factions
			end

			container:Populate()	
		end,
		name = "Player List",
		icon = "p"
	}
end)


