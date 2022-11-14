
local PANEL = {}

AccessorFunc(PANEL, "money", "Money", FORCE_NUMBER)

function PANEL:Init()
	self:DockPadding(1, 1, 1, 1)
	self:SetTall(64)
	self:Dock(BOTTOM)

	self.moneyLabel = self:Add("DLabel")
	self.moneyLabel:Dock(TOP)
	self.moneyLabel:SetFont("prGenericFont")
	self.moneyLabel:SetText("")
	self.moneyLabel:SetTextInset(2, 0)
	self.moneyLabel:SizeToContents()
	self.moneyLabel.Paint = function(panel, width, height)
		derma.SkinFunc("DrawImportantBackground", 0, 0, width, height, ix.config.Get("color"))
	end

	self.amountEntry = self:Add("ixTextEntry")
	self.amountEntry:Dock(FILL)
	self.amountEntry:SetFont("prGenericFont")
	self.amountEntry:SetNumeric(true)
	self.amountEntry:SetValue("0")

	self.transferButton = self:Add("DButton")
	self.transferButton:SetFont("ixIconsMedium")
	self:SetLeft(false)
	self.transferButton.DoClick = function()
		local amount = math.max(0, math.Round(tonumber(self.amountEntry:GetValue()) or 0))
		self.amountEntry:SetValue("0")

		if (amount != 0) then
			self:OnTransfer(amount)
		end
	end

	self.bNoBackgroundBlur = true
end

function PANEL:SetLeft(bValue)
	if (bValue) then
		self.transferButton:Dock(LEFT)
		self.transferButton:SetText("s")
	else
		self.transferButton:Dock(RIGHT)
		self.transferButton:SetText("t")
	end
end

function PANEL:SetMoney(money)
	local name = string.gsub(ix.util.ExpandCamelCase(ix.currency.plural), "%s", "")

	self.money = math.max(math.Round(tonumber(money) or 0), 0)
	self.moneyLabel:SetText(string.format("%s: %d", name, money))
end

function PANEL:OnTransfer(amount)
end

function PANEL:Paint(width, height)
	derma.SkinFunc("PaintBaseFrame", self, width, height)
end

vgui.Register("ixStorageMoney", PANEL, "EditablePanel")

DEFINE_BASECLASS("Panel")
PANEL = {}

AccessorFunc(PANEL, "fadeTime", "FadeTime", FORCE_NUMBER)
AccessorFunc(PANEL, "frameMargin", "FrameMargin", FORCE_NUMBER)
AccessorFunc(PANEL, "storageID", "StorageID", FORCE_NUMBER)

function PANEL:Init()
	if (IsValid(ix.gui.openedStorage)) then
		ix.gui.openedStorage:Remove()
	end

	ix.gui.openedStorage = self

	self:SetSize(ScrW(), ScrH())
	self:SetPos(0, 0)
	self:SetFadeTime(0.25)
	self:SetFrameMargin(4)

	self.storageInventory = self:Add("ixInventory")
	self.storageInventory.bNoBackgroundBlur = true
	self.storageInventory:ShowCloseButton(false)
	self.storageInventory:SetDraggable(false)
	self.storageInventory:SetTitle(nil)
	self.storageInventory:SetSizable(false)
	self.storageInventory.Close = function(this)
		net.Start("ixStorageClose")
		net.SendToServer()
		self:Remove()
	end

	self.storageLbl = self:Add("DLabel")
	self.storageLbl:SetFont("prMenuButtonFontThick")
	self.storageLbl:SetText("Container")
	self.storageLbl:SetContentAlignment(1)
	self.storageLbl:SizeToContents()

	self.selfLbl = self:Add("DLabel")
	self.selfLbl:SetFont("prMenuButtonFontThick")
	self.selfLbl:SetText("You")
	self.selfLbl:SetContentAlignment(3)
	self.selfLbl:SizeToContents()
	
	self.storageMoney = self.storageInventory:Add("ixStorageMoney")
	self.storageMoney:SetVisible(false)
	self.storageMoney.OnTransfer = function(_, amount)
		net.Start("ixStorageMoneyTake")
			net.WriteUInt(self.storageID, 32)
			net.WriteUInt(amount, 32)
		net.SendToServer()
	end

	ix.gui.inv1 = self:Add("ixInventory")
	ix.gui.inv1.bNoBackgroundBlur = true
	ix.gui.inv1:ShowCloseButton(false)
	ix.gui.inv1:SetDraggable(false)
	ix.gui.inv1:SetTitle(nil)
	ix.gui.inv1:SetSizable(false)
	ix.gui.inv1.Close = function(this)
		net.Start("ixStorageClose")
		net.SendToServer()
		self:Remove()
	end

	self.closeButton = self:Add("DButton")
	self.closeButton:SetFont("prMenuButtonFont")
	self.closeButton:SetText("Done")
	self.closeButton:SetSize(ScreenScale(38), ScreenScale(18))
	self.closeButton.DoClick = function()
		net.Start("ixStorageClose")
		net.SendToServer()
		self:Remove()
	end
	

	self.localMoney = ix.gui.inv1:Add("ixStorageMoney")
	self.localMoney:SetVisible(false)
	self.localMoney:SetLeft(true)
	self.localMoney.OnTransfer = function(_, amount)
		net.Start("ixStorageMoneyGive")
			net.WriteUInt(self.storageID, 32)
			net.WriteUInt(amount, 32)
		net.SendToServer()
	end

	self.showLiquid = false

	self.liquidLevel = -1

	self:SetAlpha(0)
	self:AlphaTo(255, self:GetFadeTime())

	self.storageInventory:MakePopup()
	ix.gui.inv1:MakePopup()
end

function PANEL:OnChildAdded(panel)
	panel:SetPaintedManually(true)
end

function PANEL:SetLocalInventory(inventory)
	if (IsValid(ix.gui.inv1) and !IsValid(ix.gui.menu)) then
		ix.gui.inv1:SetInventory(inventory)
		ix.gui.inv1:SetPos(self:GetWide() / 2 + self:GetFrameMargin() / 2, self:GetTall() / 2 - ix.gui.inv1:GetTall() / 2)
	end

	if IsValid(self.storageInventory) then
		local localTall = ix.gui.inv1:GetTall()
		local otherTall = self.storageInventory:GetTall()
		local midX = self:GetWide()/2 + (ix.gui.inv1:GetWide()/2 + self.storageInventory:GetWide())/2
		local yPos = self:GetTall()/2 + (ix.gui.inv1:GetTall()/2 + self.storageInventory:GetTall())/2
		ix.gui.inv1:SetPos(midX, yPos)


		timer.Simple(0, function()
			if otherTall > localTall then
				ix.gui.inv1:PadHeight(otherTall)
			else
				self.storageInventory:PadHeight(localTall)
			end
		end)
		
		self.storageInventory:SetPos(midX - self.storageInventory:GetWide(), yPos)
		
		self.selfLbl:SetPos(ix.gui.inv1:GetX(), self.storageInventory:GetY() - self.selfLbl:GetTall())
	end
end

function PANEL:SetLocalMoney(money)
	if (!self.localMoney:IsVisible()) then
		self.localMoney:SetVisible(true)
		ix.gui.inv1:SetTall(ix.gui.inv1:GetTall() + self.localMoney:GetTall() + 2)
	end

	self.localMoney:SetMoney(money)
end

function PANEL:SetStorageTitle(title)
	timer.Simple(0, function()
		self.storageLbl:SetText(title)
		self.storageLbl:SizeToContents()
		local lblWide = self.storageLbl:GetWide()
		local invWide = self.storageInventory:GetWide()
		local invX = self.storageInventory:GetX()
		local yPos = math.max(self:GetTall() / 2 - ix.gui.inv1:GetTall() / 2, self:GetTall() / 2 - self.storageInventory:GetTall() / 2)

		print("STORAGE", lblWide, invWide) 
		
		if lblWide > invWide then
			self.storageLbl:SetX(invX - (lblWide - invWide))
		else
			self.storageLbl:SetX(self.storageInventory:GetX())
			self.storageLbl:SetWide(invWide)
		end
	end)
end

function PANEL:SetStorageInventory(inventory)
	self.storageInventory:SetInventory(inventory)
	self.storageInventory:SetPos(
		self:GetWide() / 2 - self.storageInventory:GetWide() - 2,
		self:GetTall() / 2 - self.storageInventory:GetTall() / 2
	)

	ix.gui["inv" .. inventory:GetID()] = self.storageInventory

	if IsValid(ix.gui.inv1) then
		local midX = self:GetWide()/2 - ix.gui.inv1:GetWide()/2 + self.storageInventory:GetWide()/2
		local yPos = math.min(self:GetTall() / 2 - ix.gui.inv1:GetTall() / 2, self:GetTall() / 2 - self.storageInventory:GetTall() / 2) + (self.closeButton:GetTall() + 4)/2
		local maxHeight = math.max(ix.gui.inv1:GetTall(), self.storageInventory:GetTall())

		ix.gui.inv1:SetPos(midX + 3, yPos)
		self.storageInventory:SetPos(midX - self.storageInventory:GetWide() - 3, yPos)

		
		timer.Simple(0, function()
			local localTall = ix.gui.inv1:GetTall()
			local otherTall = self.storageInventory:GetTall()
			if otherTall > localTall then
				print("TOHERTA", "othertall")
				ix.gui.inv1:PadHeight(otherTall)
				self.storageInventory:SetTall(otherTall)
			else
				self.storageInventory:PadHeight(localTall)
				ix.gui.inv1:SetTall(localTall)
				ix.gui.inv1:BuildSlots()
			end
		end)
		
		self.selfLbl:SetWide(ix.gui.inv1:GetWide())

		self.closeButton:Center()
		self.closeButton:SetY(yPos + maxHeight + 5)

		self.selfLbl:SetPos(ix.gui.inv1:GetX(), yPos - self.selfLbl:GetTall() + 10)
		self.storageLbl:SetY(yPos - self.storageLbl:GetTall() + 10)
	end
end

function PANEL:SetLiquidLevel(level)
	self.liquidLevel = level
	self.liquidBar = self.storageInventory:Add("DPanel")
	self.liquidBar:Dock(BOTTOM)
	self.liquidBar:SetTall(40)
	local gradientLeft = surface.GetTextureID("vgui/gradient-l")

	self.liquidBar.Paint = function(this, w, h)
		if self.liquidLevel then
			local barW = Lerp(self.liquidLevel/100, 0, w)

			
			surface.SetDrawColor(244, 149, 15)
			surface.DrawRect(0, 0, barW, h)

			surface.SetDrawColor(186, 114, 14)
			surface.SetTexture(gradientLeft)
			surface.DrawTexturedRect(0, 0, barW, h)

			surface.SetDrawColor(40, 40, 40)
			surface.DrawRect(barW, 0, w - barW, h)

			draw.SimpleText(self.liquidLevel.."%", "prSmallFont", w/2, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

	self.barLbl = self.storageInventory:Add("DLabel")
	self.barLbl:Dock(BOTTOM)
	self.barLbl:SetFont("prSmallFont")
	self.barLbl:SetText("Cleaning Solution")
	self.barLbl:DockMargin(0, 0, 0, -3)
	self.barLbl:SizeToContents()
end

function PANEL:SetStorageMoney(money)
	if (!self.storageMoney:IsVisible()) then
		self.storageMoney:SetVisible(true)
		self.storageInventory:SetTall(self.storageInventory:GetTall() + self.storageMoney:GetTall() + 3)
	end

	self.storageMoney:SetMoney(money)
end

local gradient = surface.GetTextureID("vgui/gradient-u")

function PANEL:Paint(width, height)
	surface.SetDrawColor(0, 0, 0, 230)
	surface.DrawRect(0, 0, width, height)

	surface.SetDrawColor(30, 30, 30, 150)
	surface.SetTexture(gradient)
	surface.DrawTexturedRect(0, 0, width, height)

	ix.util.DrawBlurAt(0, 0, width, height)

	for _, v in ipairs(self:GetChildren()) do
		v:PaintManual()
	end
end

function PANEL:Remove()
	self:SetAlpha(255)
	self:AlphaTo(0, self:GetFadeTime(), 0, function()
		BaseClass.Remove(self)
	end)
end

function PANEL:OnRemove()
	if (!IsValid(ix.gui.menu)) then
		self.storageInventory:Remove()
		ix.gui.inv1:Remove()
	end
end


vgui.Register("ixStorageView", PANEL, "Panel")
