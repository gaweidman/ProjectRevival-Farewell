ix.lang.AddTable("english", {
    optToggleDevInfo = "Toggle Developer Info",
    optdToggleDevInfo = "Toggles the developer info seen on the top left of your screen.",
	optToggleHUDIcons = "Toggle HUD Icons",
    optdToggleHUDIcons = "Toggles the various HUD icons seen next to the wonderful status.",
	optToggleSwitchMonthDate = "Switch Month and Date",
	optdToggleSwitchMonthDate = "Switches the month and date around for people outside of the US."
})

ix.option.Add("toggleDevInfo", ix.type.bool, true, {
	category = "Val's Stuff",
})
ix.option.Add("toggleHUDIcons", ix.type.bool, true, {
	category = "Val's Stuff",
})
ix.option.Add("toggleSwitchMonthDate", ix.type.bool, false, {
	category = "Val's Stuff",
})

local healthIcon = Material("willardnetworks/hud/hp.png", "smooth unlitgeneric")
local armorIcon = Material("willardnetworks/hud/armor.png", "smooth unlitgeneric")
local staminaIcon = Material("willardnetworks/hud/stamina.png", "smooth unlitgeneric")
local thirstIcon = Material("willardnetworks/hud/thirst.png", "smooth unlitgeneric")
local foodIcon = Material("willardnetworks/hud/food.png", "smooth unlitgeneric")
local crossIcon = Material("willardnetworks/hud/cross.png", "smooth unlitgeneric")
local tempIcon = Material("halfliferp/temperature.png", "smooth unlitgeneric")
local toxicIcon = Material("willardnetworks/hud/toxic.png", "smooth unlitgeneric")

function PLUGIN:HUDPaintBackground()
	if ix.option.Get("toggleDevInfo", true) then
		if ix.option.Get("toggleSwitchMonthDate", false) == true then
			draw.SimpleText(
				"Project Revival  // "..LocalPlayer():SteamID().." // "..os.date("%H:%M:%S // %d/%m/%Y", os.time()),
				"Trebuchet18", 
				32,     -- x
				34,       -- y
				Color(175, 175, 175, 255), 
				TEXT_ALIGN_LEFT, -- x
				TEXT_ALIGN_BOTTOM  -- y
			)
		else
			draw.SimpleText(
				"Project Revival // "..LocalPlayer():SteamID().." // "..os.date("%H:%M:%S // %m/%d/%Y", os.time()),
				"Trebuchet18", 
				32,     -- x
				34,       -- y
				Color(175, 175, 175, 255), 
				TEXT_ALIGN_LEFT, -- x
				TEXT_ALIGN_BOTTOM  -- y
			)
		end
    end
	local diff = 22
	
	-- icons for the various bars
	if ix.option.Get("toggleHUDIcons", true) then
		--render.SetMaterial(healthIcon)
		--render.DrawScreenQuadEx(30, diff * 2 - 3, 16, 16)
		draw.SimpleText("A", "ixPRIconsBar", 38, diff * 2 + 4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--render.SetMaterial(armorIcon)
		--draw.SimpleText("")
		--draw.SimpleText("k", "ixPRIconsBar", 38, diff * 3 + 4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--render.DrawScreenQuadEx(30, diff * 3 - 1.5, 16, 16)
		--render.SetMaterial(staminaIcon)
		draw.SimpleText("e", "ixPRIconsBar", 38, diff * 3 + 4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--render.DrawScreenQuadEx(30, diff * 4, 16, 16)
		--render.SetMaterial(crossIcon)
		--render.DrawScreenQuadEx(30, 100, 16, 16)
		--render.SetMaterial(thirstIcon)
		--render.DrawScreenQuadEx(30, diff * 5, 16, 16)
		draw.SimpleText("o", "ixPRIconsBar", 36, diff * 4 + 4, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--render.SetMaterial(foodIcon)
		draw.SimpleText("t", "ixPRIconsBar", 38, diff * 5 + 6, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		--render.DrawScreenQuadEx(30, diff * 6, 16, 16)
		--render.SetMaterial(tempIcon)
		--render.DrawScreenQuadEx(30, diff * 7, 16, 16)
		--render.SetMaterial(toxicIcon)
		--render.DrawScreenQuadEx(30, 140, 16, 16)
	end
end