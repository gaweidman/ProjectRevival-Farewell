ITEM.name = "Cars for Dummies, Vol. 2"

ITEM.author = "James Albright & Madeline Smith"

ITEM.model = "models/props_lab/binderblue.mdl"

ITEM.description = "A book about cars for the moderately acquainted."

ITEM.category = "Books"

-- The attribute the book increases.
ITEM.attrib = "eng"

-- The amount given to a book's attribute.
ITEM.incAmount = 4

-- The series of books a book belongs to.
ITEM.series = "Cars for Dummies"

-- The number of a book in a certain series. You can't read further in a line of books until you read the previous volumes.
ITEM.volume = 2

function ITEM:PopulateTooltip(tooltip)
    local tip = tooltip:AddRow("author")
    tip:SetBackgroundColor(derma.GetColor("Success", tooltip))
    tip:SetText("Written by "..self.author..".")
    tip:SetFont("DermaDefault")
    tip:SizeToContents()
end