
local PLUGIN = PLUGIN

netstream.Hook("ixWritingEdit", function(client, itemID, text, pickupOthers, editableOthers)
	text = tostring(text):sub(1, PLUGIN.maxLength)

	local character = client:GetCharacter()
	local item = ix.item.instances[itemID]

	-- we don't check for entity since data can be changed in the player's inventory
	if (character and item and item.base == "base_writing") then
		local owner = item:GetData("owner", 0)

		if ((owner == 0 or owner == character:GetID()) and text:len() > 0 and not (itemID == nil)) then
			item:SetText(text, character, true)
			item:SetPickupable(pickupOthers)
			item:SetEditable(editableOthers)
		elseif ((owner != character:GetID() and owner != 0) and text:len() > 0 and not (itemID == nil)) then
			item:SetText(text, character, false)
		end
	elseif (character and text:len() > 0 and itemID == nil) then
		if not character:GetInventory():Add("printedpaper", 1, {
			["text"] = text,
			["owner"] = character:GetID()
		}) then
			ix.item.Spawn("printedpaper", client, nil, Angle(0, 0, 0), {
				["text"] = text,
				["owner"] = character:GetID()
			})
		end
	end
end)

function PLUGIN:SaveData()
	local printers = {}
	for k, v in ipairs(ents.FindByClass("ix_printer")) do
		printers[#printers + 1] = {
			["pos"] = v:GetPos(),
			["angles"] = v:GetAngles(),
			["canMove"] = v:GetPhysicsObject():IsMotionEnabled(),
			["paperCount"] = v.paperCount
		}
	end

	ix.data.Set("printers", printers)

	local pins = {}
	for k, v in ipairs(ents.FindByClass("gmod_nail")) do
		pins[#pins + 1] = {
			["pos"] = v:GetPos(),
			["angles"] = v:GetAngles(),
			["parent"] = v:GetParent().ixItemID
		}
	end


end

function PLUGIN:LoadData()
	local printers = ix.data.Get("printers", {})
	for k, v in ipairs(printers) do
		local printer = ents.Create("ix_printer")
		printer:SetPos(v.pos)
		printer:SetAngles(v.angles)

		printer:Spawn()
		printer:GetPhysicsObject():EnableMotion(v.canMove)
		printer.paperCount = v.paperCount
	end
end