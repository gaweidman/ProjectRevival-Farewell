
netstream.Hook("ixViewPaper", function(itemID, text, pickupOthers, editableOthers, editing, handwritten)
	print("test")
	local panel = vgui.Create("ixImprovedPaper")

	panel:SetItemID(itemID)
	panel:SetText(text)
	panel:SetupCheckboxes(pickupOthers, editableOthers)
	panel:SetEditing(editing)

	if handwritten then
		panel:SetFont("ixHandWriting")
	else
		panel:SetFont("ixPrinted")
	end
end)
