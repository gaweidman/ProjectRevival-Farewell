ITEM.name = "High School Runner"

ITEM.author = "Bill Kenley"

ITEM.model = "models/props_lab/bindergreen.mdl"

ITEM.description = "The single greatest book ever written."

ITEM.category = "Books"

-- The attribute the book increases.
ITEM.attrib = "agi"

-- The amount given to a book's attribute.
ITEM.incAmount = 3

-- The series of books a book belongs to.
ITEM.series = "High School Runner"

-- The number of a book in a certain series. You can't read further in a line of books until you read the previous volumes.
ITEM.volume = 1 

function ITEM:PopulateTooltip(tooltip)
    local tip = tooltip:AddRow("author")
    tip:SetBackgroundColor(derma.GetColor("Success", tooltip))
    tip:SetText("Written by "..self.author..".")
    tip:SetFont("DermaDefault")
    tip:SizeToContents()
end