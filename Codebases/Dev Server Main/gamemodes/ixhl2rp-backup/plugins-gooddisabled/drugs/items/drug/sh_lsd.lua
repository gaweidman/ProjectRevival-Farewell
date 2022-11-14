ITEM.name = "LSD"
ITEM.description = "Some LSD, product quality is questionable these days."
ITEM.model = Model("models/jellik/lsd.mdl")
ITEM.category = "Drugs"
ITEM.width = 1
ITEM.height = 1

ITEM.functions.Eat = {
	sound = "npc/barnacle/barnacle_gulp1.wav",
	OnRun = function(itemTable)
		local client = itemTable.player

		local badTrip = math.random(1, 10)

		if badTrip == 10 then -- Bad Trip
			client:Notify("You don't feel so good. This must be a bad trip.")
			self.screenspaceEffects = function()
				DrawColorModify({
					["$pp_colour_addr"] = 0,
					["$pp_colour_addg"] = 0,
					["$pp_colour_addb"] = 0,
					["$pp_colour_brightness"] = -0.18,
					["$pp_colour_contrast"] = 10,
					["$pp_colour_colour"] = 1.35,
					["$pp_colour_mulr"] = 0,
					["$pp_colour_mulg"] = 0,
					["$pp_colour_mulb"] = 0  
				})
			end
		else -- Good Trip
			self.screenspaceEffects = function()

			end
		end
		hook.Run("SetupDrugTimer", client, client:GetCharacter(), itemTable.uniqueID, 1800)
	end
}

--[[
ITEM.screenspaceEffects = function()
	DrawMotionBlur(0.25, 1, 0)
]]--