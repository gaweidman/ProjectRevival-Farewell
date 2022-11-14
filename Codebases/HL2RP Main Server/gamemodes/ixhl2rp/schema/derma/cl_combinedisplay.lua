
local PANEL = {}

AccessorFunc(PANEL, "font", "Font", FORCE_STRING)
AccessorFunc(PANEL, "maxLines", "MaxLines", FORCE_NUMBER)

function PANEL:Init()
	if (IsValid(ix.gui.combine)) then
		ix.gui.combine:Remove()
	end

	self.lines = {}

	self:SetMaxLines(6)
	self:SetFont("ixCMBLabel")

	self:SetPos(6, 6)
	self:SetSize(ScrW(), self.maxLines * 20)
	self:ParentToHUD()

	ix.gui.combine = self
end

-- Adds a line to the combine display. Set expireTime to 0 if it should never be removed.
function PANEL:AddLine(text, colorArg, expireTime, ...)
	if (#self.lines >= self.maxLines) then
		for k, info in ipairs(self.lines) do
			if (info.expireTime != 0) then
				table.remove(self.lines, k)
			end
		end
	end

	local color = colorArg or color_white
	
	if color.r != 255 or color.g != 255 or color.b != 255 then
		LocalPlayer():EmitSound("buttons/button16.wav")
	end

	-- check for any phrases and replace the text
	if (text:sub(1, 1) == "@") then
		text = L(text:sub(2), ...)
	end

	local index = #self.lines + 1

	self.lines[index] = {
		text =  " -  " .. text,
		color = color or color_white,
		expireTime = (expireTime != 0 and (CurTime() + (expireTime or 8)) or 0),
		character = 1
	}

	return index
end

function PANEL:RemoveLine(id)
	if (self.lines[id]) then
		table.remove(self.lines, id)
	end
end

function PANEL:Think()
	local x, _ = self:GetPos()
	local y = 4 + ix.gui.bars:GetTall()

	self:SetPos(x, y)
end

function PANEL:Paint(width, height)
	local textHeight = draw.GetFontHeight(self.font)
	local y = 0

	surface.SetFont(self.font)

	for k, info in ipairs(self.lines) do
		if (info.expireTime != 0 and CurTime() >= info.expireTime) then
			table.remove(self.lines, k)
			continue
		end

		if (info.character < info.text:len()) then
			info.character = info.character + 1
		end

		surface.SetTextColor(info.color)
		surface.SetTextPos(0, y)
		surface.DrawText(info.text:sub(1, info.character))

		y = y + textHeight
	end

	surface.SetDrawColor(Color(0, 0, 0, 255))

	
end

local green = Color(0, 255, 0)
local locationCol = Color(185, 185, 232)

vgui.Register("ixCombineDisplay", PANEL, "Panel")

if (IsValid(ix.gui.combine)) then
	vgui.Create("ixCombineDisplay")
end