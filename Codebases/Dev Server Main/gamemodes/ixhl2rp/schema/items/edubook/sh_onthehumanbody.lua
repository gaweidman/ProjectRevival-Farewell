ITEM.name = "The Human Body"

ITEM.author = "Daniel Free, PhD, Donald Thompson, PhD, et al"

ITEM.model = "models/props_lab/bindergraylabel01a.mdl"

ITEM.description = "An introductory textbook to medical practice."

ITEM.category = "Books"

-- The attribute the book increases.
ITEM.attrib = "medical"

-- The amount given to a book's attribute.
ITEM.incAmount = 10

-- The series of books a book belongs to.
ITEM.series = "Human Body"

-- The number of a book in a certain series. You can't read further in a line of books until you read the previous volumes.
ITEM.volume = 1 

function ITEM:PopulateTooltip(tooltip)
    local tip = tooltip:AddRow("author")
    tip:SetBackgroundColor(derma.GetColor("Success", tooltip))
    tip:SetText("Written by "..self.author..".")
    tip:SetFont("DermaDefault")
    tip:SizeToContents()
end