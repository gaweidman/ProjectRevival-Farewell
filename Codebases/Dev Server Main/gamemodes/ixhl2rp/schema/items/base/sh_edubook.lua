ITEM.name = "Lifting for Dummies Vol. 1"

ITEM.model = "models/props_lab/binderblue.mdl"

ITEM.description = "A book about how to lift."

ITEM.category = "Books"

-- The attribute the book increases.
ITEM.attrib = "str"

-- The amount given to a book's attribute.
ITEM.incAmount = 1

-- The series of books a book belongs to.
ITEM.series = "Lifting for Dummies"

ITEM.author = "Ben Dover"

-- The number of a book in a certain series. You can't read further in a line of books until you read the previous volumes.
ITEM.volume = 1 

ITEM.functions.read = {
    name = "Read",
    tip = "Read the book.",
    icon = "icon16/book_open.png",
    OnRun = function(item)

        local char = item:GetOwner():GetCharacter()
        local booksRead = char:GetData("booksRead", {})

        for k, v in ipairs(char:GetData("booksRead", {})) do

            if v.name == item.name then
                item:GetOwner():Notify("You've already read this book!")
                return false
            end

        end
        
        if item.volume > 1 then
            
            local volumeSum = Schema:AddFact(item.volume, false)
            for k, v in ipairs(booksRead) do
                if v.series == item.series then
                   volumeSum = volumeSum - v.volume
                end
            end

            if volumeSum != item.volume then
                item:GetOwner():Notify("You haven't read all the books in the series before this one!")
                return false
            end

        end

        if(char:GetAttribute(item.attrib, 0) + item.incAmount < ix.config.Get("maxAttributes", 60)) then
            char:SetAttrib(attrib, char:GetAttribute(item.attrib, 0) + item.incAmount)
        else
            char:SetAttrib(item.attrib, ix.config.get("maxAttributes", 60))
        end

        newBooksRead = booksRead
        newBooksRead[#booksRead+1] = {
            series = item.series,
            volume = item.volume,
            name = item.name
        }
        char:SetData("booksRead", newBooksRead)

        --char:GetInventory():Add(item:GetID())
        item:GetOwner():Notify("You read the book. You feel like you learned something.")

        return false
    end
}