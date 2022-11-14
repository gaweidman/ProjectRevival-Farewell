local PANEL = {}

function PANEL:Init()
	ix.gui.dialogue = self
	self:SetSize(ScrW() / 3, ScrH() / 4)
	self:MakePopup()
	local scrW, scrH = ScrW(), ScrH()
	self:SetPos(scrW / 3, scrH / 1.5)
	self:SetTitle("Engaged in dialogue")
	local w, h = self:GetSize()
	self.TextPanel = self:Add("DPanel")
	self.TextPanel:Dock(BOTTOM)
	self.TextPanel:SetTall(h / 2.5)
	self.TextPanel.PanelList = self.TextPanel:Add("DPanelList")
	self.TextPanel.PanelList:Dock(FILL)
	self.TextPanel.PanelList:EnableVerticalScrollbar(true)
	self.DialoguePanel = self:Add("DPanel")
	self.DialoguePanel:Dock(TOP)
	self.DialoguePanel:SetTall(h / 2.5)
	self.DialogueList = self.DialoguePanel:Add("DScrollPanel")
	self.DialogueList:Dock(FILL)
	self.CurDialogue = self.DialoguePanel:Add("DLabel")
	self.CurDialogue:Dock(TOP)
	self.CurDialogue:SetWrap(true)
	self.CurDialogue:SetFont("ixSmallFont")
	self.CurDialogue:SetText("What do you need ?")
	self.CurDialogue:SetAutoStretchVertical(true)
	self.DialogueList:AddItem(self.CurDialogue)
	self.DialoguePanelList = self:Add("DPanelList")
	self.DialoguePanelList:Dock(FILL)
	self.DialoguePanelList:EnableVerticalScrollbar(true)
end

function PANEL:Say(text)
	self.CurDialogue:SetText(text)
	self.CurDialogue:SizeToContents()
end

function PANEL:AddDialogueOption(text, callback, response)
	local button = self:Add("DButton")
	button:SetText(text)
	self.TextPanel.PanelList:AddItem(button)
	button:Dock(TOP)
	button.id = text

	function button:DoClick()
		surface.PlaySound("buttons/button24.wav")

		if callback then
			callback()
		end

		if response then
			ix.gui.dialogue:Say(response)
		end
	end
end

function PANEL:SetCharacter(ent)
	ix.gui.dialogue.ent = ent

	for k, v in pairs(ent:GetNetVar("dialogue", {})) do
		for k2, v2 in pairs(GLOBAL_PreDefinedDialogue) do
			if v == k2 then
				if not v2.Additional then
					self:AddDialogueOption(v2.Button, v2.Callback, v2.Response)
				else
					self:AddDialogueOption(v2.Button, function()
						for k3, v3 in pairs(v2.Additional) do
							self:AddDialogueOption(v3.Button, v3.Callback, v3.Response)

							if v2.Callback then
								v2.Callback()
							end
						end
					end, v2.Response)
				end
			end
		end
	end

	local EntDataQuests = ent:GetNetVar("quests", {})
	local check = table.Random(EntDataQuests)


	if table.Count(ent:GetNetVar("quests", {})) > 0 then
		if not (table.HasValue(LocalPlayer():GetCharacter():GetData("finishquests", {}), check) or table.HasValue(LocalPlayer():GetCharacter():GetData("quests", {}), check))then
			self:AddDialogueOption("Do you have work for me ?", function()
				--if LocalPlayer():GetCharacter():GetData("quests", {})  then
				--	local alreadyQuest = {"J'ai rien à te confier.", "Je n'ai pas de travail pour vous en ce moment.", "Non."}
				--	ix.gui.dialogue:Say(table.Random(alreadyQuest))

				--	return
				--end

				local quests = ent:GetNetVar("quests", {})

				if table.Count(quests) < 1 then
					LocalPlayer():Notify("You should not be able to start a quest with this NPC, contact a developer.")
				else
					local rnd = table.Random(quests)

					for k, v in pairs(GLOBAL_Quests) do
						if k == rnd then
							ix.gui.dialogue:Say(v.dialogue.start)
							PrintTable(v)
						end
					end

					netstream.Start("GetQuest", {ent, rnd})

					self.TextPanel.PanelList:Remove()

					self.TextPanel.PanelList = self.TextPanel:Add("DPanelList")
					self.TextPanel.PanelList:Dock(FILL)
					self.TextPanel.PanelList:EnableVerticalScrollbar(true)

					self:AddDialogueOption("Goodbye.", function()
						ix.gui.dialogue:Remove()
					end, false)
				end
			end, false)
		end
	end

	self:QuestStuff(ent)

	self:AddDialogueOption("Goodbye.", function()
		ix.gui.dialogue:Remove()
	end, false)
end

function PANEL:QuestStuff(ent)
	local data = LocalPlayer():GetCharacter():GetData("quests", {})
	local entquests = ent:GetNetVar("quests", {})
	local rnd = table.Random(entquests)
	local quest = "Unknown"

	for k, v in pairs(data) do
		if v == rnd then
			quest = v
		end
	end


	if table.HasValue(ent:GetNetVar("quests", {}), quest) then
		self:AddDialogueOption("About this quest...", function()
			self:AddDialogueOption("Can you tell me more?", function()
				for k, v in pairs(GLOBAL_Quests) do
					if k == quest then
						ix.gui.dialogue:Say(v.dialogue.question)
					end
				end
			end, false)

			self:AddDialogueOption("I completed it.", function()
				ix.gui.dialogue:CheckQuestCompletion(ent, quest)
			end, false)
		end, "Qu'en est-il ?")
	end
end

function PANEL:CheckQuestCompletion(ent, quest)
	local char = LocalPlayer():GetCharacter()
	local inv = char:GetInventory()
	local items = inv:GetItems()

	for k, v in pairs(GLOBAL_Quests) do
		if quest == k then
			for k2, v2 in pairs(v.requirements) do
				if inv:GetItemCount(k2) < v2 then
					ix.gui.dialogue:Say("You didn't finish it, are you trying to trick me ?")

					return
				end
			end

			self.TextPanel.PanelList:Remove()

			self.TextPanel.PanelList = self.TextPanel:Add("DPanelList")
			self.TextPanel.PanelList:Dock(FILL)
			self.TextPanel.PanelList:EnableVerticalScrollbar(true)

			self:AddDialogueOption("Goodbye.", function()
				ix.gui.dialogue:Remove()
			end, false)

			ix.gui.dialogue:Say(v.dialogue.complete)
			netstream.Start("QuestCompleted", {ent, quest})
		end
	end
end

function PANEL:StartQuest(ent)
	local quests = ent:GetNetVar("quests", {})

	if table.Count(quests) < 1 then
		LocalPlayer():Notify("You should not be able to start a quest with this NPC, contact a developer.")
	else
		netstream.Start("GetQuest", {ent})
	end
end

vgui.Register("ixDialogueUI", PANEL, "DFrame")
local PANEL = {}

function PANEL:Init()
	ix.gui.npcedit = self
	self:SetSize(ScrW() / 4, ScrH() / 4)
	self:Center()
	self:MakePopup()
	self.Desc = self:Add("DLabel")
	self.Desc:Dock(TOP)
	self.Desc:SetText("What do you want to edit?")
	self.Desc:SizeToContents()
	self.ButtonDialogue = self:Add("DButton")
	self.ButtonDialogue:SetText("Predefined dialog")
	self.ButtonDialogue:Dock(BOTTOM)
	self.ButtonQuests = self:Add("DButton")
	self.ButtonQuests:Dock(BOTTOM)
	self.ButtonQuests:SetText("Quests")

	timer.Simple(0.1, function()
		self.TextName = self:Add("DTextEntry")
		self.TextName:Dock(TOP)
		self.TextName:SetText(ix.gui.npcedit.npc:GetNetVar("Name", "Name"))
		self.DescBox = self:Add("DTextEntry")
		self.DescBox:Dock(TOP)
		self.DescBox:SetText(ix.gui.npcedit.npc:GetNetVar("Description", "Description"))
		self.ModelBox = self:Add("DTextEntry")
		self.ModelBox:Dock(TOP)
		self.ModelBox:SetText(ix.gui.npcedit.npc:GetModel())
		self.AnimLabel = self:Add("DLabel")
		self.AnimLabel:Dock(TOP)
		self.AnimLabel:SetText("Animation Index, must be a number.")
		self.AnimLabel:SizeToContents()
		self.AnimBox = self:Add("DTextEntry")
		self.AnimBox:Dock(TOP)
		self.AnimBox:SetText(ix.gui.npcedit.npc:GetNetVar("anim", 4))
		self.SubmitBox = self:Add("DButton")
		self.SubmitBox:Dock(TOP)
		self.SubmitBox:SetText("Submit changes")

		self.SubmitBox.DoClick = function()
			netstream.Start("ChangeNPCValues", {ix.gui.npcedit.npc, self.TextName:GetText(), self.DescBox:GetText(), self.ModelBox:GetText(), self.AnimBox:GetText()})
		end
	end)

	function self.ButtonDialogue:DoClick()
		local ui = vgui.Create("DFrame")
		ui:SetSize(ScrW() / 2, ScrH() / 2)
		ui:Center()
		ui:MakePopup()

		for k, v in pairs(GLOBAL_PreDefinedDialogue) do
			local checkbox = ui:Add("DCheckBoxLabel")
			checkbox:Dock(TOP)
			checkbox.dialogue = {k, v}
			checkbox:SetText(v.Button)
			local data = ix.gui.npcedit.npc:GetNetVar("dialogue", {})

			if table.HasValue(data, k) then
				checkbox:SetChecked(true)
			end

			function checkbox:OnChange(val)
				if val then
					netstream.Start("DialogueOptionAdd", {k, v, ix.gui.npcedit.npc})
				else
					netstream.Start("DialogueOptionRemove", {k, v, ix.gui.npcedit.npc})
				end
			end
		end
	end

	function self.ButtonQuests:DoClick()
		local ui = vgui.Create("DFrame")
		ui:SetSize(ScrW() / 2, ScrH() / 2)
		ui:Center()
		ui:MakePopup()

		for k, v in pairs(GLOBAL_Quests) do
			local checkbox = ui:Add("DCheckBoxLabel")
			checkbox:Dock(TOP)
			checkbox.quest = {k, v}
			checkbox:SetText(v.name)
			local data = ix.gui.npcedit.npc:GetNetVar("quests", {})

			if table.HasValue(data, k) then
				checkbox:SetChecked(true)
			end

			function checkbox:OnChange(val)
				if val then
					netstream.Start("QuestOptionAdd", {k, v, ix.gui.npcedit.npc})
				else
					netstream.Start("QuestOptionRemove", {k, v, ix.gui.npcedit.npc})
				end
			end
		end
	end
end

function PANEL:SetCharacter(ent)
	ix.gui.npcedit.npc = ent
end

vgui.Register("ixNPCEdit", PANEL, "DFrame")

netstream.Hook("OpenQuestDialogue", function(data)
	local ui = vgui.Create("ixDialogueUI")
	ui:SetCharacter(data[1])
end)

netstream.Hook("OpenQuestEditMenu", function(data)
	local ui = vgui.Create("ixNPCEdit")
	ui:SetCharacter(data[1])
end)