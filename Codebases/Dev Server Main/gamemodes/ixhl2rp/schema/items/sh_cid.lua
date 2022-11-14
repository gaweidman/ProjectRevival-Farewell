
ITEM.name = "Citizen ID"
ITEM.model = Model("models/dorado/tarjeta2.mdl")
ITEM.description = "A citizen identification card with ID #%s, assigned to %s."

function ITEM:GetDescription()
	return string.format(self.description, self:GetData("id", "00000"), self:GetData("name", "nobody"))
end

function ITEM:PopulateTooltip(tooltip)
	--local notice = tooltip:AddRow("obselenotice")

	tooltip:GetRow("name"):SetZPos(1)
	tooltip:GetRow("description"):SetZPos(3)

	--notice:SetText("CID cards have been replaced by identibands and can no longer be used for identification.")
	--notice:SetBackgroundColor(Color(150, 64, 64))
	--notice:SetFont("BudgetLabel")
	--notice:SetZPos(2)
--	notice:SizeToContents() 
end
