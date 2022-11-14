local PLUGIN = PLUGIN

PLUGIN.name = "Advanced Quests"
PLUGIN.author = "D.K !"
PLUGIN.description = "Adds an advanced quest system based on the ZeMysticalTaco plugin with several features added by D.K."

GLOBAL_Quests = {
	["test1"] = { -- Unique Quest ID. (important just make sure it's unique)
		["name"] = "Test Phase", -- Name of the quest.
		["dialogue"] = { -- Dialogue of the quest.
			["start"] = "Message of departure quest Test phase.", -- Departure message.
			["complete"] = "Message at the end of the quest Test phase.", -- End message.
			["question"] = "Message of additional information quest Test Phase." -- Have more information about the quest.
		},
		["reward"] = { -- Award(s).
			["tokens"] = 70 --tokens 
		},
		["requirements"] = { -- Items required in order to complete the quest.
			["bandage"] = 1 --item id's must be used
		},
		["icon"] = "materials/questsicon/unkown.png", -- Put the link of the mission icon (materials) for the quests menu.
		["description"] = "Description quête Phase de Test", -- Brief description of the quest.
		["objective"] = "- 1 Bandage", -- Objective(s) to be completed in the quest.
		["about"] = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
			incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation 
			ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit 
			in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 
			non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
			Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
			incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation 
			ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit 
			in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 
			non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. 
			Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
			incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation 
			ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit 
			in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 
			non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. 
			Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
			incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation 
			ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit 
			in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 
			non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
			Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
			incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation 
			ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit 
			in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 
			non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.]], -- Summary of the quest
	},

-- [[[
	["rescuecharle"] = {  -- Unique Quest ID. (important just make sure it's unique)
		["name"] = "The passing doctor", -- Name of the quest.
		["dialogue"] = { --  Dialogue of the quest.
			["start"] = "Oh yes! Are you really going to help me? Thank you so much, bring me some biogel and a bandage... I'll give you some interesting stuff.", -- Departure message.
			["complete"] = "It's already better! Thank you again, here you go.", -- -- End message.
			["question"] = "To say more I don't know, but it seems to me that I saw some biogel and a bandage not so far from here, sorry if I'm not really helping you..." -- Have more information about the quest.
		},
		["reward"] = { -- Award(s).
			["pistol"] = 1,
			["pistolammo"] = 2 
		},
		["requirements"] = { -- Items required in order to complete the quest.
			["bandage"] = 1, --item id's must be used
			["health_kit"] = 1
		},
		["icon"] = "materials/questsicon/virus.png", -- Put the link of the mission icon (materials) for the quests menu.
		["description"] = "Charle needs help, you need to get him some biogel and a bandage.", -- Brief description of the quest.
		["objective"] = [[- Bring back 1 Bandage
		- Bring back 1 biogel]], -- Objective(s) to be completed in the quest.
		["about"] = [[Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
			incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation 
			ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit 
			in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 
			non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
			Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
			incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation 
			ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit 
			in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 
			non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. 
			Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
			incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation 
			ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit 
			in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 
			non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. 
			Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
			incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation 
			ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit 
			in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 
			non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
			Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
			incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation 
			ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit 
			in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat 
			non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.]], -- Summary of the quest
	},

	["retrieva17"] = { -- Unique Quest ID. (important just make sure it's unique)
		["name"] = "Acquire 4 Cloth Scrap", --the name that shows up in the tab menu
		["dialogue"] = { -- all of these are self explanatory, \n means a new line, the text in the box doesn't wrap automatically so try to new line after every sentence.
			["start"] = "So I'm trying to put together a new piece of cloth, but I only need one more scrap.\nFind me some cloth and I'll get you a pouch with what's left over.",
			["complete"] = "Great, this is good.\nWait here.",
			["question"] = "Cloth can be found all over the place.\nLook in garbage cans or the ground."
		},
		["reward"] = {
			["backpack"] = 1, --use item ID's, if you dont know the ID or you want an item made just put in a name and i'll fix it later
		},
		["requirements"] = {
			["bandage"] = 1
		}
	}
}

-- The unique ID is very important, just make sure it is unique.
--[[-------------------------------------------------------------------------
Additionals can only go one layer deep.
TODO: Make it so that you can go infinitely with additionals.
---------------------------------------------------------------------------]]
GLOBAL_PreDefinedDialogue = {
	["test1"] = {
		["Button"] = "Additional information to add ?",
		["Response"] = [[ Not really just that this quest is a test, but what exactly do you want to know?
		]],
		["Callback"] = false,
		["Additional"] = {
			["characterquestiontest1"] = {
				["Button"] = "What are you good for then ?",
				["Response"] = [[ Good question, haha. ]]
			},
			["arealocation"] = {
				["Button"] = "Where do I go?",
				["Response"] = [[ Nowhere ! This is a test quest. ]]
			}
		}
	},

	["rescuecharle"] = {
		["Button"] = "Don't we know it already?",
		["Response"] = [[ There is little chance...
		]],
		["Callback"] = false,
		["Additional"] = {
		}
	}
}

ix.util.Include("sv_plugin.lua")
ix.util.Include("cl_plugin.lua")
ix.util.Include("cl_hooks.lua")


if(CLIENT) then

	local PANEL = {}


	function PANEL:Init()
		if (IsValid(ix.gui.journal)) then
			ix.gui.journal:Remove()
		end

		self:Dock(FILL)

		ix.gui.journal = self


		local client = LocalPlayer()
		local character = client:GetCharacter()
		local quests = character:GetData("quests", {})
		local finishquests = character:GetData("finishquests", {})

		local rnd = table.Random(quests)

		local color = ix.config.Get("color", Color(255, 255, 255))

		self.index = {}

		for index, v in pairs(quests) do
			for k2, v2 in pairs(GLOBAL_Quests) do

				if v == k2 then

					self.index = self:Add("DFrame")
					self.index:Dock(TOP)
					self.index:SetHeight(100)
					self.index:DockMargin(20, 20, 20, 0)
					self.index:SetTitle(v2.name or "Unknown")
					self.index:SetDraggable(false)
					self.index:ShowCloseButton(false)

					self.index.icon = vgui.Create("Material", self.index)
					self.index.icon:SetSize(64, 64)
					self.index.icon:Dock(LEFT)
					self.index.icon:SetMaterial(v2.icon or "materials/questsicon/unkown.png")

					self.index.description = self.index:Add("DLabel")
					self.index.description:SetText(v2.description or "Unknown")
					self.index.description:Dock(TOP)
					self.index.description:DockMargin(10, 2, 0, 0)
					self.index.description:SetFont("ixGenericFont")
					self.index.description:SetColor(Color(255, 255, 255))

					--self.index.description = self.index:Add("DLabel")
					--self.index.description:SetText(description)
					--self.index.description:Dock(TOP)
					--self.index.description:SetFont("ixGenericFont")
					--self.index.description:DockMargin(10, 4, 0, 0)


					self.index.details = self.index:Add("DButton")
					self.index.details:Dock(BOTTOM)
					self.index.details:DockMargin(10, 0, 0, 0)
					self.index.details:SetText("Détails")
					self.index.details.DoClick = function()
						if (IsValid(self.questdetails)) then
							self.questdetails:Remove()
						end

					self.questdetails = self:Add("DFrame")
					self.questdetails:Center()
					self.questdetails:SetSize(500, 350)
					self.questdetails:SetTitle(v2.name)
					self.questdetails:MakePopup()

					self.questdetails.containertop = self.questdetails:Add("DPanel")
					self.questdetails.containertop:SetSize(480, 150)
					self.questdetails.containertop:SetPos(10, 30)

					self.questdetails.objective = self.questdetails.containertop:Add("DPanel")
					self.questdetails.objective:SetPos(160, 10)
					self.questdetails.objective:SetSize(310, 20)

					self.questdetails.objectiveTitle = self.questdetails.objective:Add("DLabel")
					self.questdetails.objectiveTitle:SetText("Objectif(s) de la quête")
					self.questdetails.objectiveTitle:SizeToContents()
					self.questdetails.objectiveTitle:Center()

					self.questdetails.objectiveContainer = self.questdetails.containertop:Add("DPanel")
					self.questdetails.objectiveContainer:SetPos(160, 30.5)
					self.questdetails.objectiveContainer:SetSize(310, 80)

					self.questdetails.objectiveContainerScroll = self.questdetails.objectiveContainer:Add("DScrollPanel")
					self.questdetails.objectiveContainerScroll:SetPos(5, 0)
					self.questdetails.objectiveContainerScroll:SetSize(310, 80)

					self.questdetails.objectiveContainerScrollText = self.questdetails.objectiveContainerScroll:Add("DLabel")
					self.questdetails.objectiveContainerScrollText:SetText(v2.objective or "Unknown")
					self.questdetails.objectiveContainerScrollText:Dock(TOP)
					self.questdetails.objectiveContainerScrollText:SizeToContents()

					self.questdetails.bCancel = self.questdetails.containertop:Add("DButton")
					self.questdetails.bCancel:Dock(BOTTOM)
					self.questdetails.bCancel:DockMargin(160, 0, 10, 10)
					self.questdetails.bCancel:SetText("Abandon the quest")
					self.questdetails.bCancel.DoClick = function()
						netstream.Start("QuestCancel", v)
						self:Remove()
						client:Notify("Press the 'Quests' button again to review your quests.")
					end

					self.questdetails.containertop2 = self.questdetails.containertop:Add("DPanel")
					self.questdetails.containertop2:SetSize(150, 150)

					self.questdetails.icon = vgui.Create("Material", self.questdetails.containertop2)
					self.questdetails.icon:SetSize(64, 64)
					self.questdetails.icon:Dock(LEFT)
					self.questdetails.icon:DockMargin(43, 43, 43, 43)
					self.questdetails.icon:SetMaterial(v2.icon or "materials/questsicon/unkown.png")

					self.questdetails.containerbottom = self.questdetails:Add("DPanel")
					self.questdetails.containerbottom:SetSize(480, 155)
					self.questdetails.containerbottom:SetPos(10, 185)

					self.questdetails.containerbottom.about = self.questdetails.containerbottom:Add("DPanel")
					self.questdetails.containerbottom.about:SetPos(0, 0)
					self.questdetails.containerbottom.about:SetSize(480, 20)

					self.questdetails.containerbottom.aboutTitle = self.questdetails.containerbottom.about:Add("DLabel")
					self.questdetails.containerbottom.aboutTitle:SetText("Summary of the quest")
					self.questdetails.containerbottom.aboutTitle:SizeToContents()
					self.questdetails.containerbottom.aboutTitle:Center()

					self.questdetails.containerbottom.containerabout = self.questdetails.containerbottom:Add("DPanel")
					self.questdetails.containerbottom.containerabout:SetPos(0, 20)
					self.questdetails.containerbottom.containerabout:SetSize(480, 135)

					self.questdetails.containerbottom.containeraboutscroll = self.questdetails.containerbottom.containerabout:Add("DScrollPanel")
					self.questdetails.containerbottom.containeraboutscroll:SetPos(5, 0)
					self.questdetails.containerbottom.containeraboutscroll:SetSize(478, 135)

					self.questdetails.containerbottom.containeraboutscrolltext = self.questdetails.containerbottom.containeraboutscroll:Add("DLabel")
					self.questdetails.containerbottom.containeraboutscrolltext:SetText(v2.about or "Unknown")
					self.questdetails.containerbottom.containeraboutscrolltext:Dock(TOP)
					self.questdetails.containerbottom.containeraboutscrolltext:SizeToContents()

		--			self.index.rarity = self.index.leftPanel:Add("DLabel")
		--			self.index.rarity:SetText(item.rarity .. "%")
		--			self.index.rarity:Dock(RIGHT)
		--			self.index.rarity:SetFont("ixMediumFont")
		--			self.index.rarity:DockMargin(0, -60, 0, 0)

					end

				end
			end
		end
	end

	vgui.Register("ixCharacterJournal", PANEL, "DScrollPanel")


-- ------------------------------------------------------------------------------ --


	local PANEL = {}


	function PANEL:Init()
		if (IsValid(ix.gui.detailsquest)) then
			ix.gui.detailsquest:Remove()
		end

		ix.gui.detailsquest = self


	end

	vgui.Register("ixDetailsQuest", PANEL, "DFrame")


end -- Fin de la condition "CLIENT".