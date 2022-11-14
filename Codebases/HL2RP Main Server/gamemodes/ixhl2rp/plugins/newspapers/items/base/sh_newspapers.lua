ITEM.name = "Newspaper Base"
ITEM.desc = "A newspaper."
ITEM.category = "literature"
ITEM.model = "models/props_junk/garbage_newspaper001a.mdl"
ITEM.contents = ""
ITEM.functions.Read = {
	OnClick = function(item)
		local frame = vgui.Create("DFrame")
		frame:SetSize(540, 680)
		frame:SetTitle(item.name)
		frame:MakePopup()
		frame:Center()

		frame.html = frame:Add("DHTML")
		frame.html:Dock(FILL)
		frame.html:SetHTML([[<html><body style="background-color: #ECECEC; color: #282B2D; font-family: 'Book Antiqua', Palatino, 'Palatino Linotype', 'Palatino LT STD', Georgia, serif; font-size 16px; text-align: justify;">]]..item.contents..[[</body></html>]])
	end,
	OnRun = function(item)
		return false
	end,
	icon = "icon16/book_open.png"
}