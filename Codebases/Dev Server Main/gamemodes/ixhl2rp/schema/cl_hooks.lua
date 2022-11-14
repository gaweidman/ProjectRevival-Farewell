VORTHUD = {}

local eventEffectStartTime = -1
local overlayMat

ix.fonts = {}

VORTHUD.BARWIDTH = 50
VORTHUD.XMARGIN = 50
VORTHUD.YMARGIN = 50
VORTHUD.TEXTMARGIN = 25
VORTHUD.ANIMDURATION = 0.25    -- This one is pretty ambiguous by the name, but it means the length of time it takes for vortessence increase or decrease animations to play.
--So at CurTime() + VORTHUD.ANIMDURATION, the animation is done.
VORTHUD.MAXBARHEIGHT = 200

local WAYPOINTSYMBS = {
	[WP_NEUTRAL] = ".",
	[WP_WARNING] = "!",
	[WP_CAUTION] = "o",
	[WP_WAYPOINT] = "x"
}

local WAYPOINTCOLS = {
	[WP_NEUTRAL] = color_white,
	[WP_WARNING] = Color(255, 230, 230),
	[WP_CAUTION] = Color(255, 245, 230),
	[WP_WAYPOINT] = Color(230, 230, 255)
}

function ix.util.LoadWebImages()
	http.Fetch("http://files.revivalhl2rp.site.nfoservers.com/", function(body, size, headers, code)
		--print(body)
		--PrintTable(headers)
		local linkPattern = "<a href=\"([%w%p]+)\""
		local links = {}
		local iteration = 0
		while string.find(body, linkPattern) do
			iteration = iteration + 1
			startPos, endPos, text = string.find(body, linkPattern)

			
			body = string.sub(body, endPos)

			isSortLink = string.find(text, "?")

			if !isSortLink then 
				links[#links + 1] = text
			end

			if iteration > 50 then 
				ErrorNoHalt("detected infinite loop")
				break
			end
		end

		for k, v in ipairs(links) do
			http.Fetch("http://files.revivalhl2rp.site.nfoservers.com/"..v, function(body)
				if !file.Exists("helix/projectrevival/", "DATA") then
					file.CreateDir("helix/projectrevival/")
				end
				file.Write("helix/projectrevival/"..v, body)
			end)
		end
	end, function(errorMsg)
		print(errorMsg)
	end)
end

/*


hook.Add( "PlayerButtonDown", "OpenRadialMenu", function( ply, button )
	if button != KEY_T then return end

	if SERVER or !IsFirstTimePredicted() or IsValid(ix.gui.ActRadial) or !ix.gui.CanOpenRadial then
		return
	end

	local radial = vgui.Create("Panel")
	radial:SetSize(1920, 1090)
	radial:SetPos(0, 0)
	radial:MakePopup()
	radial:SetKeyboardInputEnabled(true)

	function radial:OnKeyCodeReleased(key)
		if key == KEY_T then
			ix.gui.ActRadial:Remove()
			ix.gui.ActRadial = nil
		end
	end

	function radial:OnMouseReleased(button)
		if button == MOUSE_LEFT then
			net.Start("ixCombatAct")
				local selected = FindSelected(ScrW()/2, ScrH()/2, segment_size) + 1
				net.WriteString(optionTranslate[options[selected]])
			net.SendToServer()

			ix.gui.CanOpenRadial = false
			ix.gui.ActRadial:Remove()
			ix.gui.ActRadial = nil
		end
	end
	
	local alignTable = {
		["Advance"] = {
			x = TEXT_ALIGN_CENTER,
			y = TEXT_ALIGN_TOP
		},
		["Right"] = {
			x = TEXT_ALIGN_CENTER,
			y = TEXT_ALIGN_CENTER
		},
		["Left"] = {
			x = TEXT_ALIGN_CENTER,
			y = TEXT_ALIGN_CENTER
		},
		["Stop"] = {
			x = TEXT_ALIGN_CENTER,
			y = TEXT_ALIGN_CENTER
		},
		["Group"] = {
			x = TEXT_ALIGN_CENTER,
			y = TEXT_ALIGN_CENTER,
		},
		["Forward"] = {
			x = TEXT_ALIGN_CENTER,
			y = TEXT_ALIGN_TOP
		},
		["Advance"] = {
			x = TEXT_ALIGN_LEFT,
			y = TEXT_ALIGN_TOP
		},
		["Take Cover"] = {
			x = TEXT_ALIGN_LEFT,
			y = TEXT_ALIGN_CENTER
		}
	}

	radial.Paint = function(panel)
		if !input.IsKeyDown(KEY_T) then
			panel:Remove()
			ix.gui.ActRadial = nil
		end

		ix.util.DrawBlur(panel)

		local selected = FindSelected(x, y, segment_size)

		background()
		
		for i = 0, #options - 1 do
			local option = options[i + 1]
			local a = math.rad(segment_size * i + segment_size / 4)
			local nextA = math.rad(segment_size * (i + 1) + segment_size / 4)
			local halfA =  math.rad(segment_size * (i + 0.5) + segment_size / 4)

			local x = x + math.cos(a) * r
			local y = y + math.sin(a) * r

			local nextX = halfScrW + math.cos(nextA) * r
			local nextY = halfScrH + math.sin(nextA) * r

			local halfX = halfScrW + math.cos(halfA) * r
			local halfY = halfScrH + math.sin(halfA) * r
			
			surface.SetDrawColor(radialLineColor)
			surface.DrawLine(halfScrW, halfScrH, x, y)
			
			local align = alignTable[option]

			draw.SimpleText(
				option, "DermaLarge", halfX + (halfScrW - halfX)*0.45, halfY + (halfScrH - halfY)*0.45,
				selected == i and radialTextColorSel or radialTextColor,
				align.x, align.y
			)

			
		end

		outline()
		wedge:SetRotation(selected * segment_size +  segment_size / 4)
		wedge()	

		
	end

	ix.gui.ActRadial = radial
	

end)

*/

hook.Add( "PlayerButtonUp", "CloseRadialMenu", function( ply, button )
	if button != KEY_T then return end

	if CLIENT and not IsFirstTimePredicted() then
		return
	end

	ix.gui.CanOpenRadial = true
end)

hook.Add( "KeyRelease", "SubmitCombatAct", function(ply, button)
	if button != IN_ATTACK or !IsValid(ix.gui.ActRadial) or SERVER then return end

	
	
end)

local halfScrW, halfScrH = ScrW()/2, ScrH()/2

hook.Add("HUDPaint", "PaintActRadial", function()


end)

ix.util.LoadWebImages()

concommand.Add("testwebimages", function()
	ix.util.LoadWebImages()
end)

function Schema:ShouldShowPlayerOnScoreboard(client)
	if !IsValid(client) then return end
	local localChar = LocalPlayer():GetCharacter()

	if char then
		if char:GetFaction() == FACTION_OTA and localChar and !localChar:HasBiosignal() then
			return false
		end
	end
end

hook.Add("LoadFonts", "ixFontOverrides", function(font, genericFont)
	font = "Khand Light"
	surface.CreateFont("pr3D2DFont", {
		font = "Khand Light",
		size = 128,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prCMB3D2DFont", {
		font = "Combine_alphabet",
		size = 128,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prDINB3D2DFont", {
		font = "DIN 2014 Bold",
		size = 128,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prDIN3D2DFont", {
		font = "DIN 2014",
		size = 128,
		extended = true,
		weight = 100
	})
	
	surface.CreateFont("prDINCond3D2DFont", {
		font = "DIN Condensed",
		size = 128,
		extended = true,
		weight = 100
	})
	
	surface.CreateFont("prPRIcons3D2DFont", {
		font = "pr-icons", 
		size = 128,
		extended = true,
		weight = 100
	})

	surface.CreateFont("pr3D2DMediumFont", {
		font = font,
		size = 48,
		extended = true,
		weight = 100
	})

	surface.CreateFont("pr3D2DSmallFont", {
		font = font,
		size = 24,
		extended = true,
		weight = 400
	})

	surface.CreateFont("prSmallHeadingFont", {
		font = "Khand Medium",
		size = 34,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prSmallMenuFont", {
		font = "Khand Light",
		size = 28,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prSmallFont", {
		font = "Khand Light",
		size = 32,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prMediumMenuFont", {
		font = "Khand Regular",
		size = 45,
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixCharNameFont", {
		font = "Khand SemiBold",
		size = 100,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prFieldsMenuThickFont", {
		font = "Khand Medium",
		size = 45,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prFieldsMenuFont", {
		font = "Khand Light",
		size = 45,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prSmallMenuBtnFont", {
		font = "Khand Light",
		size = 25,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prSmallTextEntryFont", {
		font = "Roboto Th",
		size = 18,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prSubTitleFont", {
		font = font,
		size = ScreenScale(16),
		extended = true,
		weight = 100
	})

	surface.CreateFont("prSmallTitleFont", {
		font = "Khand Light",
		size = math.max(ScreenScale(12), 24),
		extended = true,
		weight = 100
	})

	surface.CreateFont("prMenuMiniFont", {
		font = "Khand Light",
		size = 22,
		weight = 300,
	})

	surface.CreateFont("prMenuButtonFont", {
		font = "Khand Regular",
		size = ScreenScale(16),
		extended = false,
		weight = 100
	})

	surface.CreateFont("prMenuButtonFontSmall", {
		font = "Khand Light",
		size = ScreenScale(10),
		extended = true,
		weight = 100
	})

	surface.CreateFont("prMenuButtonFontThick", {
		font = "Khand Medium",
		size = ScreenScale(16),
		extended = true,
		weight = 100
	})

	surface.CreateFont("prMenuButtonLabelFont", {
		font = "Khand Medium",
		size = 60,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prMenuButtonHugeFont", {
		font = "Khand Medium",
		size = ScreenScale(24),
		extended = true,
		weight = 100
	})

	surface.CreateFont("prToolTipText", {
		font = font,
		size = 30,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prMonoSmallFont", {
		font = "Consolas",
		size = 20,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prMonoMediumFont", {
		font = "Consolas",
		size = 28,
		extended = true,
		weight = 10
	})

	-- The more readable font.

	surface.CreateFont("prBigFont", {
		font = font,
		size = 36,
		extended = true,
		weight = 1000
	})

	surface.CreateFont("prCategoryHeadingFont", {
		font = "Khand Medium",
		size = 40,
		extended = true,
		weight = 100
	})

	surface.CreateFont("prNoticeFont", {
		font = "Khand Regular",
		size = math.max(ScreenScale(11), 32),
		weight = 100,
		extended = true,
		antialias = true
	})

	surface.CreateFont("prNoticeBarFont", {
		font = "Khand Medium",
		size = 32,
		weight = 100,
		extended = true,
		antialias = true
	})

	surface.CreateFont("prMediumLightFont", {
		font = font,
		size = 30,
		extended = true,
		weight = 200
	})

	surface.CreateFont("prMediumThickFont", {
		font = "Khand Regular",
		size = 30,
		extended = true,
		weight = 200
	})

	surface.CreateFont("prScreenHelpFont", {
		font = "Khand Regular",
		size = 55,
		extended = true,
		weight = 200
	})

	surface.CreateFont("prMediumLightBlurFont", {
		font = font,
		size = 30,
		extended = true,
		weight = 200,
		blursize = 4
	})

	surface.CreateFont("prGenericFont", {
		font = font,
		size = 20,
		extended = true,
		weight = 1000
	})

	surface.CreateFont("prSmallTitleFont", {
		font = "Khand Light",
		size = 45,
		extended = true,
		weight = 200
	})

	surface.CreateFont("ixMinimalTitleFont", {
		font = "Roboto",
		size = math.max(ScreenScale(8), 22),
		extended = true,
		weight = 800
	})

	surface.CreateFont("prBigFont", {
		font = font,
		size = math.max(ScreenScale(6), 17),
		extended = true,
		weight = 500
	})

	surface.CreateFont("prItemDescFont", {
		font = font,
		size = math.max(ScreenScale(6), 17),
		extended = true,
		shadow = true,
		weight = 500
	})

	surface.CreateFont("prBigBoldFont", {
		font = font,
		size = math.max(ScreenScale(8), 20),
		extended = true,
		weight = 800
	})

	surface.CreateFont("prItemBoldFont", {
		font = font,
		shadow = true,
		size = math.max(ScreenScale(8), 20),
		extended = true,
		weight = 800
	})

	-- Introduction fancy font.
	font = "Roboto Th"

	surface.CreateFont("ixIntroTitleFont", {
		font = font,
		size = math.min(ScreenScale(128), 128),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIntroTitleBlurFont", {
		font = font,
		size = math.min(ScreenScale(128), 128),
		extended = true,
		weight = 100,
		blursize = 4
	})

	surface.CreateFont("ixIntroSubtitleFont", {
		font = font,
		size = ScreenScale(24),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIntroSmallFont", {
		font = font,
		size = ScreenScale(14),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIconsSmall", {
		font = "fontello",
		size = 22,
		extended = true,
		weight = 500
	})

	surface.CreateFont("prSmallTitleIcons", {
		font = "fontello",
		size = math.max(ScreenScale(11), 23),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIconsMedium", {
		font = "fontello",
		extended = true,
		size = 28,
		weight = 500
	})

	surface.CreateFont("ixIconsMenuButton", {
		font = "fontello",
		size = ScreenScale(14),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIconsBig", {
		font = "fontello",
		extended = true,
		size = 48,
		weight = 500
	})

	surface.CreateFont("7SegDisplayBig", {
		font = "DSEG7 Classic Mini",
		extended = true,
		size = 60,
	})

	surface.CreateFont("ixPRIcons", {
		font = "pr-icons",
		extended = true,
		size = math.max(ScreenScale(4), 18)
	})

	surface.CreateFont("ixPRIconsSmall", {
		font = "pr-icons",
		extended = true,
		size = 14
	})

	surface.CreateFont("ixPRIconsTooltip", {
		font = "pr-icons",
		extended = true,
		size = 22
	})

	surface.CreateFont("ixPRIconsField", {
		font = "pr-icons",
		extended = false,
		size = 24
	})

	surface.CreateFont("ixPRIconsBar", {
		font = "pr-icons",
		extended = false,
		size = 21
	})

	surface.CreateFont("ixPRIconsChat", {
		font = "pr-icons",
		extended = true,
		size = math.max(ScreenScale(11), 32) * ix.option.Get("chatFontScale", 1)
	})

	surface.CreateFont("ixPRIconsBig", {
		font = "pr-icons",
		extended = true,
		size = 59
	})

	surface.CreateFont("HUDText", {
		font = "Not Verdana Bold",
		extended = false,
		size = 19,
		weight = 2000,
		antialias = true
	})

	surface.CreateFont("HUDTextGlow", {
		font = "Verdana Bold",
		size = 19,
		weight = 700,
		blursize = 2,
		scanlines = 2,
		antialias = true,
		additive = 1
	})

	surface.CreateFont("HUDNumbers", {
		font = "HalfLife2",
		size = 74,
		weight = 0,
		blursize = 0,
		antialias = 1,
	})

	surface.CreateFont("HUDNumbersGlow", {
		font = "HalfLife2",
		size = 74,
		weight = 0,
		blursize = 4,
		scanlines = 2,
		antialias = 1,
		additive = 1
	})

	surface.CreateFont("ixFormHeader", {
		font = "Roboto Bold",
		size = 45,
		extended = true,
		weight = 800
	})

	surface.CreateFont("ixBarcode", {
		font = "Libre Barcode 39",
		size = 30,
		extended = true,
		weight = 100
	})
	
end)

ix.fonts["AlyxSemibold"] = {
	height = 20
}

ix.fonts["AlyxBig"] = {
	height = 31
}

ix.fonts["AlyxAmmoBig"] = {
	height = 31
}

function Schema:LoadFonts(font, genericFont)
	surface.CreateFont("ix3D2DFont", {
		font = "Roboto",
		size = 128,
		extended = true,
		weight = 100
	})

	surface.CreateFont("ix3D2DMediumFont", {
		font = font,
		size = 48,
		extended = true,
		weight = 100
	})

	surface.CreateFont("ix3D2DSmallFont", {
		font = font,
		size = 24,
		extended = true,
		weight = 400
	})

	surface.CreateFont("ixTitleFont", {
		font = font,
		size = ScreenScale(30),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixSubTitleFont", {
		font = font,
		size = ScreenScale(16),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixMenuMiniFont", {
		font = "Roboto",
		size = math.max(ScreenScale(4), 18),
		weight = 300,
	})

	surface.CreateFont("ixMenuButtonFont", {
		font = "Roboto Th",
		size = ScreenScale(14),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixMenuButtonFontSmall", {
		font = "Roboto Th",
		size = ScreenScale(10),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixMenuButtonFontThick", {
		font = "Roboto",
		size = ScreenScale(14),
		extended = true,
		weight = 300
	})

	surface.CreateFont("ixMenuButtonLabelFont", {
		font = "Roboto Th",
		size = 28,
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixMenuButtonHugeFont", {
		font = "Roboto Th",
		size = ScreenScale(24),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixToolTipText", {
		font = font,
		size = 20,
		extended = true,
		weight = 500
	})

	surface.CreateFont("ixMonoSmallFont", {
		font = "Consolas",
		size = 12,
		extended = true,
		weight = 800
	})

	surface.CreateFont("ixMonoMediumFont", {
		font = "Consolas",
		size = 22,
		extended = true,
		weight = 800
	})

	-- The more readable font.
	font = genericFont

	surface.CreateFont("ixBigFont", {
		font = font,
		size = 36,
		extended = true,
		weight = 1000
	})

	surface.CreateFont("ixMediumFont", {
		font = font,
		size = 25,
		extended = true,
		weight = 1000
	})

	surface.CreateFont("ixNoticeFont", {
		font = font,
		size = math.max(ScreenScale(8), 18),
		weight = 100,
		extended = true,
		antialias = true
	})

	surface.CreateFont("ixMediumLightFont", {
		font = font,
		size = 25,
		extended = true,
		weight = 200
	})

	surface.CreateFont("ixMediumLightBlurFont", {
		font = font,
		size = 25,
		extended = true,
		weight = 200,
		blursize = 4
	})

	surface.CreateFont("ixGenericFont", {
		font = font,
		size = 20,
		extended = true,
		weight = 1000
	})

	surface.CreateFont("ixChatFont", {
		font = font,
		size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = 600,
		antialias = true
	})

	surface.CreateFont("ixChatFontItalics", {
		font = font,
		size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = 600,
		antialias = true,
		italic = true
	})

	surface.CreateFont("ixChatFontMono", {
		font = "Consolas",
		size = math.max(ScreenScale(7), 17) * ix.option.Get("chatFontScale", 1),
		extended = true,
		weight = 600,
		antialias = true
	})


	surface.CreateFont("ixSmallTitleFont", {
		font = "Roboto Th",
		size = math.max(ScreenScale(12), 24),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixMinimalTitleFont", {
		font = "Roboto",
		size = math.max(ScreenScale(8), 22),
		extended = true,
		weight = 800
	})

	surface.CreateFont("ixSmallFont", {
		font = font,
		size = math.max(ScreenScale(6), 17),
		extended = true,
		weight = 500
	})

	surface.CreateFont("ixItemDescFont", {
		font = font,
		size = math.max(ScreenScale(6), 17),
		extended = true,
		shadow = true,
		weight = 500
	})

	surface.CreateFont("ixSmallBoldFont", {
		font = font,
		size = math.max(ScreenScale(8), 20),
		extended = true,
		weight = 800
	})

	surface.CreateFont("prScreenHelpFont", {
		font = font,
		size = 68,
		extended = true,
		weight = 800
	})

	surface.CreateFont("ixItemBoldFont", {
		font = font,
		shadow = true,
		size = math.max(ScreenScale(8), 20),
		extended = true,
		weight = 800
	})

	-- Introduction fancy font.
	font = "Roboto Th"

	surface.CreateFont("ixIntroTitleFont", {
		font = font,
		size = math.min(ScreenScale(128), 128),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIntroTitleBlurFont", {
		font = font,
		size = math.min(ScreenScale(128), 128),
		extended = true,
		weight = 100,
		blursize = 4
	})

	surface.CreateFont("ixIntroSubtitleFont", {
		font = font,
		size = ScreenScale(24),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIntroSmallFont", {
		font = font,
		size = ScreenScale(14),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIconsSmall", {
		font = "fontello",
		size = 22,
		extended = true,
		weight = 500
	})

	surface.CreateFont("ixSmallTitleIcons", {
		font = "fontello",
		size = math.max(ScreenScale(11), 23),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIconsMedium", {
		font = "fontello",
		extended = true,
		size = 28,
		weight = 500
	})

	surface.CreateFont("ixIconsMenuButton", {
		font = "fontello",
		size = ScreenScale(14),
		extended = true,
		weight = 100
	})

	surface.CreateFont("ixIconsBig", {
		font = "fontello",
		extended = true,
		size = 48,
		weight = 500
	})

	surface.CreateFont("ixHandwritingFont", {
		font = "Shadows Into Light",
		extended = true,
		size = 20,
		weight = 500
	})

	surface.CreateFont("ixCMBLabel", {
		font = "Courier New",
		size = 20,
		extended = true,
		weight = 500,
		outline = true,
		antialias = false
	})

	surface.CreateFont("ixCMBLabelBig", {
		font = "Courier New",
		size = 20,
		extended = true,
		weight = 2,
		outline = true
	})

	surface.CreateFont("ixCMBLabelWorld", {
		font = "Courier New",
		size = 17,
		weight = 300,
		outline = false
	})

	surface.CreateFont("ixHandWriting", {
		font = "Shadows Into Light Two",
		size = 25,
		extended = true,
		weight = 1000
	})

	surface.CreateFont("ixPrinted", {
		font = "PT Serif",
		size = 25,
		extended = true,
		weight = 1000
	})
end

VORTHUD.INORGANICNPCS = {
	"models/combine_camera/combine_camera.mdl",
	"models/manhack.mdl",
	"models/combine_scanner.mdl",
	"models/roller.mdl",
	"models/roller_spikes.mdl",
	"models/roller_vehicledriver.mdl",
	"models/combine_turrets/floor_turret.mdl",
	"models/combine_turrets/ceiling_turret.mdl"
}

local spriteTexture = Material("sprites/glow04_noz")
local maxHealthColor = Color(0, 255, 0)

local render_SetMaterial = render.SetMaterial -- this supposedly helps performance
local render_DrawSprite = render.DrawSprite
local render_DrawBeam = render.DrawBeam

vortessenceBarColor = Color(41, 184, 0)
drainedBarColor = Color(4, 18, 0)
transcendantBarColor = Color(132, 0, 255)
drainedBarColorTranscendant = Color(68, 0, 68)

oldVortessencePixels = -1
newVortessencePixels = -1

oldMaxVortessence = -1
newMaxVortessence = -1

start = -1

 
hook.Add("HUDPaint", "ixSchemaPaintHUD", function()

	local localPlayer =  LocalPlayer()

	if localPlayer:IsStaff() and ix.option.Get("drawCinematicOverlays", true) then
		return
	end


	if localPlayer:GetNetVar("ShowBlackScreen", false) then
		surface.SetDrawColor(0, 0, 0, 255)
		surface.DrawRect(0, 0, ScrW(), ScrH())
	end

	local topText = localPlayer:GetNetVar("TopText", false)

	if topText then
		draw.SimpleText(topText, "ixSubTitleFont", ScrW()/2, ScrH() /4, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	if localPlayer:GetNetVar("ScreenText", nil) then
		draw.SimpleText(localPlayer:GetNetVar("ScreenText"), "ixTitleFont", ScrW()/2, ScrH()/2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	if localPlayer:GetNetVar("CenterSubtitle", nil) then
		draw.SimpleText(localPlayer:GetNetVar("CenterSubtitle"), "ixSubTitleFont", ScrW()/2, ScrH()/2 + 35, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
	end

	if localPlayer:GetNetVar("DrawLoading", false) then
		draw.SimpleText("Loading...", "ixSubTitleFont", ScrW()/2, ScrH() - 200, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	local client = LocalPlayer()
	local char = client:GetCharacter()
	if ( !IsValid( localPlayer ) ) then return end

	for num, ply in ipairs(player.GetAll()) do 
		if ply == client then continue end

		if ply.CurrentMsgLines then
			local maxDist = ix.config.Get("chatRange")
			local distance = client:GetPos():Distance(ply:GetPos())

			if distance <= ply.CurrentMsgDistance then
				local drawPos
				drawPos = ply:GetPos()
				local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
				if (bone) then
					drawPos = ply:GetBonePosition(bone)
					drawPos.z = drawPos.z + 10
				else
					local bottomBound, topBound = ply:GetModelBounds()

					drawPos.z = drawPos.z + topBound.z - bottomBound.z
				end

				local screenPosition = (drawPos):ToScreen()
				local x, y = screenPosition.x, screenPosition.y

				local drawColor = ply.CurrentMsgColor
				local outlineColor = color_black
				drawColor.a = 255*(1 - (distance/ply.CurrentMsgDistance))
				outlineColor.a = drawColor.a

				--draw.SimpleTextOutlined(ply.LastMessage, "ixChatFont", x, y, ix.config.Get("chatColor"), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
				for k, text in ipairs(ply.CurrentMsgLines) do
					draw.SimpleTextOutlined(text, ply.CurrentMsgFont, x, y - #ply.CurrentMsgLines*22 + (k)*28, drawColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, outlineColor)
				end
			end
		end
	end

	local useBind = string.upper(input.LookupBinding( "use" ))
	local walkBind = string.upper(input.LookupBinding( "walk" ))

	if localPlayer:GetLocalVar("IsPlacing", false) then
		draw.SimpleTextOutlined(string.format("Press %s to Place", useBind), "prScreenHelpFont", ScrW()/2, ScrH() - 59, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		draw.SimpleTextOutlined(string.format("Press %s+%s to Stop Placing", walkBind, useBind), "prScreenHelpFont", ScrW()/2, ScrH() - 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	end

end)



hook.Add( "RenderScreenspaceEffects", "FormEnhanceOverlay", function()
	local client = LocalPlayer()

	local fadeBlueEndTime = client:GetNetVar("fadeBlueEndTime", -1)    

	if client:IsTranscendant() and CurTime() > fadeBlueEndTime and fadeBlueEndTime != -1 then
		DrawMaterialOverlay( "effects/vortblue_overlay", 1 )
	elseif !client:IsTranscendant() and CurTime() < fadeBlueEndTime and fadeBlueEndTime != -1 then
		DrawMaterialOverlay( "effects/transcendant/vortblue_overlay", 1 )
	end

	--DrawMaterialOverlay( "effects/formenhance/invuln_overlay_green", 1 )
	

end )

local healBeamTexture = Material("sprites/tp_beam001")
local spriteTexture = Material("sprites/glow04_noz")
local healBeamColor = Color(81, 221, 126, 255)
local healthIndicatorColor = Color(0, 221, 0, 255)
local maxHealthColor = Color(0, 255, 0)



hook.Add( "PostDrawOpaqueRenderables", "VortigauntHealBeams", function()
	for k, v in ipairs(player.GetAll()) do 
		local client = v
		local char = client:GetCharacter()
		local healTarget = client:GetNetVar("HealTarget", -1)
		local curTime = CurTime()

		if healTarget != -1 then
			healTarget = Entity(healTarget)
			local weapon = client:GetActiveWeapon()
			local drawHealBeams = weapon:GetNetVar("DrawHealBeams", false)

			if drawHealBeams and healTarget != NULL then
				leftWristPos = client:GetBonePosition(client:LookupBone("ValveBiped.hand1_L"))
				rightWristPos = client:GetBonePosition(client:LookupBone("ValveBiped.hand1_R"))
				local destinationPos, hc1pos, hc2pos, hc3pos, hc4pos, hc5pos = healTarget:GetHealthPosVectors()
				local distanceL = leftWristPos:Distance(destinationPos)
				local distanceR = rightWristPos:Distance(destinationPos)
				local distance = client:GetPos():Distance(healTarget:GetPos())
				local curTime = CurTime()
				local scaledCurTime = curTime
		
				local renderTransparency = math.Clamp(255*math.Clamp(curTime - weapon:GetNetVar("StartDrawHealBeamTime"), 0, 1)*7, 0, 255)
		
				healBeamColor.a = renderTransparency
		
				render_SetMaterial(healBeamTexture)
				render_DrawBeam(leftWristPos, destinationPos, 10, scaledCurTime + distanceL/64, scaledCurTime - distanceL/64, healBeamColor)
				render_DrawBeam(rightWristPos, destinationPos, 10, scaledCurTime + distanceR/64, scaledCurTime - distanceR/64, healBeamColor)

				if client:EntIndex() == LocalPlayer():EntIndex() and !client:GetNetVar("xrayMode", false) then
					local basePos, hc1pos, hc2pos, hc3pos, hc4pos, hc5pos = healTarget:GetHealthPosVectors()

					local renderTransparency = math.Clamp(255*math.Clamp(curTime - weapon:GetNetVar("StartDrawHealBeamTime"), 0, 1)*7, 0, 255)

					local H, S, V = ColorToHSV(maxHealthColor)
					local health = healTarget:Health()
					local maxHealth = healTarget:GetMaxHealth()

					spriteColor = HSVToColor((H - 115 + math.floor(115*(health/maxHealth))), S, V)

					spriteColor.a = renderTransparency

					if !client:GetNetVar("xrayMode", false) then
						render_SetMaterial(spriteTexture)
						render_DrawSprite(basePos, 8, 8, spriteColor)
					end
				end
			end
		end
	end
end )

hook.Add( "RenderScreenspaceEffects", "VortalEyeColor", function()
	local client = LocalPlayer()
	local char = client:GetCharacter()
	local shiftTimer = client:GetNetVar("xrayShiftTimer", nil)

	if char and char:GetFaction() == FACTION_ALIEN and char:GetClass() == CLASS_FREEVORT and shiftTimer then
		local xrayEnabled =  client:GetNetVar("xrayMode", false)

		local sat
		if xrayEnabled then
			sat = Lerp((CurTime() - shiftTimer) / 0.5, 1, 0)
		else
			sat = Lerp((CurTime() - shiftTimer) / 0.5, 0, 1)
		end

		local colorMod = {
			[ "$pp_colour_addr" ] = 0.,
			[ "$pp_colour_addg" ] = 0.,
			[ "$pp_colour_addb" ] = 0,
			[ "$pp_colour_brightness" ] = 0,
			[ "$pp_colour_contrast" ] = 1,
			[ "$pp_colour_colour" ] = sat,
			[ "$pp_colour_mulr" ] = 0,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		}

		DrawColorModify(colorMod )

		cam.Start3D()
			local pos = client:GetPos()
			local sat
			if xrayEnabled then
				sat = Lerp((CurTime() - shiftTimer) / 0.5, 0, 1)
			else
				sat = Lerp((CurTime() - shiftTimer) / 0.5, 1, 0)
			end
			if xrayEnabled and sat == 1 then

				-- Reset everything to known good
				render.SetStencilWriteMask( 0xFF )
				render.SetStencilTestMask( 0xFF )
				render.SetStencilReferenceValue( 0 )
				render.SetStencilCompareFunction( STENCIL_ALWAYS )
				render.SetStencilPassOperation( STENCIL_KEEP )
				render.SetStencilFailOperation( STENCIL_KEEP )
				render.SetStencilZFailOperation( STENCIL_KEEP )
				render.ClearStencil()

				-- Enable stencils
				render.SetStencilEnable( true )
				-- Set the reference value to 1. This is what the compare function tests against
				render.SetStencilReferenceValue( 1 )
				-- Only draw things if their pixels are currently 1. Currently this is nothing.
				render.SetStencilCompareFunction( STENCIL_EQUAL )
				-- If something fails to draw to the screen, set the pixels it would have drawn to 1
				-- This includes if it's behind something.
				render.SetStencilFailOperation( STENCIL_REPLACE )
	
				
				-- Draw our entities. They will not draw, because everything is 0
				for _, ent in ipairs( player.GetAll() ) do
					if ent:GetPos():Distance(pos) <= 400 then
						ent:DrawModel()
					end
				end

				-- If we were to re-draw our entities, we'd see them, but otherwise they're invisible.
				-- If we flush the screen, we can show the "holes" they've left in the stencil buffer
				render.ClearBuffersObeyStencil( 0, 255, 0, 255*sat, false )

				-- Let everything render normally again
				render.SetStencilEnable( false )
			end
		cam.End3D()
	end
end )

hook.Add( "PostDrawOpaqueRenderables", "VortalEyePlayers", function()
	local client = LocalPlayer()
	local char = client:GetCharacter()
	local xrayEnabled = client:GetNetVar("xrayMode", false)
	local shiftTimer = client:GetNetVar("xrayShiftTimer", nil)
	local pos = client:GetPos()

	if char and char:GetFaction() == FACTION_ALIEN and char:GetClass() == CLASS_FREEVORT and shiftTimer then

		local sat
		if xrayEnabled then
			sat = Lerp((CurTime() - shiftTimer) / 0.5, 0, 1)
		else
			sat = Lerp((CurTime() - shiftTimer) / 0.5, 1, 0)
		end
		if xrayEnabled and sat == 1 then

			-- Reset everything to known good
			render.SetStencilWriteMask( 0xFF )
			render.SetStencilTestMask( 0xFF )
			render.SetStencilReferenceValue( 0 )
			render.SetStencilCompareFunction( STENCIL_ALWAYS )
			render.SetStencilPassOperation( STENCIL_KEEP )
			render.SetStencilFailOperation( STENCIL_KEEP )
			render.SetStencilZFailOperation( STENCIL_KEEP )
			render.ClearStencil()

			-- Enable stencils
			render.SetStencilEnable( true )
			-- Set the reference value to 1. This is what the compare function tests against
			render.SetStencilReferenceValue( 1 )
			-- Only draw things if their pixels are currently 1. Currently this is nothing.
			render.SetStencilCompareFunction( STENCIL_EQUAL )
			-- If something fails to draw to the screen, set the pixels it would have drawn to 1
			-- This includes if it's behind something.
			render.SetStencilFailOperation( STENCIL_REPLACE )
 
			
			-- Draw our entities. They will not draw, because everything is 0
			for _, ent in ipairs( player.GetAll() ) do
				if ent:GetPos():Distance(pos) <= 400 then
					--ent:DrawModel()
				end
			end

			-- If we were to re-draw our entities, we'd see them, but otherwise they're invisible.
			-- If we flush the screen, we can show the "holes" they've left in the stencil buffer
			render.ClearBuffersObeyStencil( 255, 255, 255, 255*sat, false )

			-- Let everything render normally again
			render.SetStencilEnable( false )
		end
	end
end )

hook.Add( "PreDrawHalos", "VortalEyeHalos", function()
	local client = LocalPlayer()
	local char = client:GetCharacter()
	local xrayEnabled = client:GetNetVar("xrayMode", false)
	local shiftTimer = client:GetNetVar("xrayShiftTimer", nil)
	local pos = client:GetPos()

	if char and char:GetFaction() == FACTION_ALIEN and char:GetClass() == CLASS_FREEVORT and shiftTimer then

		local sat
		if xrayEnabled then
			sat = Lerp((CurTime() - shiftTimer) / 0.5, 0, 1)
		else
			sat = Lerp((CurTime() - shiftTimer) / 0.5, 1, 0)
		end
		if xrayEnabled and sat == 1 then
			local players = {}
			for _, ent in ipairs( player.GetAll() ) do
				if ent:GetPos():Distance(pos) <= 400 then
					players[#players + 1] = ent
				end
			end

			halo.Add(players, color_white, 2, 2, 1, true, true)

		end
	end
end )

local green = Color(0, 255, 0)
local locationCol = Color(185, 185, 232)

hook.Add("HUDPaint", "CombineHUD", function()
	local ply = LocalPlayer()
	local char = ply:GetCharacter()

	if !char then return end
	if !char:IsCombine() then return end

	for k, v in ipairs(ents.FindByClass("ix_cmbwaypoint")) do
		local pos = v:GetPos()
		local screenData = pos:ToScreen()

		local msg = v:GetNetVar("Message", "Biosignal Lost")
		local msgType = v:GetNetVar("Type", WP_WARNING)
		local msgSign = WAYPOINTSYMBS[msgType]
		local color = WAYPOINTCOLS[msgType]

		local dist = math.Round(LocalPlayer():GetPos():Distance(pos)/39.37, 1)

		if dist%1 == 0 then
			dist = tostring(dist)..".0"
		end
		
		
		draw.SimpleTextOutlined(msg, "ixCMBLabelWorld", screenData.x, screenData.y, color,  TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
		--draw.SimpleTextOutlined("< "..msgSign.." >", "ixCMBLabelWorld", screenData.x, screenData.y, color,  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		draw.SimpleTextOutlined("("..dist.." m)", "ixCMBLabelWorld", screenData.x, screenData.y, color,  TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)

	end

	local scrW = ScrW()

	surface.SetFont("ixCMBLabelBig")
	local socioW, socioH = surface.GetTextSize("Sociostatus: ")
	local colorW, colorH = surface.GetTextSize("Green")

	local w, h = draw.SimpleText("Sociostatus: ", "ixCMBLabelBig", scrW/2 - (socioW + colorW)/2, 5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0, color_black )
	w, h = draw.SimpleText("Green", "ixCMBLabelBig", scrW/2 - (socioW + colorW)/2 + w, 5, green, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 0, color_black )

	local area = LocalPlayer():GetArea()

	if area == nil or area == "" then
		return
	end
	
	draw.SimpleText("Location: "..area, "ixCMBLabelBig", scrW/2, h + 5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 0, color_black )
end)

function Schema:GetPlayerIcon(client)
	local userGroup = client:GetUserGroup()
	if userGroup == "supporter" then
		return "icon16/emoticon_smile.png"
	elseif userGroup == "vip" then
		return "icon16/heart.png"
	elseif userGroup == "supervip" then
		return "icon16/star.png"
	elseif userGroup == "gamer" then
		return "icon16/computer.png"
	elseif userGroup == "epicgamer" then
		return "icon16/controller.png"
	elseif userGroup == "truegamer" then
		return "icon16/joystick.png"
	end
end

function Schema:PopulateItemTooltip(tip, item)
	if LocalPlayer():IsStaff() then
		local id = tip:AddRow("itemid")
		id:SetText("Item ID: "..item:GetID())
	end
end

function Schema:PopulateCharacterInfo(client, character, tooltip)
	local otherClient = character:GetPlayer()
	-- Red blood tooltip display.
	if (client:GetNetVar("redBloody")) then
		local panel = tooltip:AddRow("redBloody")
		panel:SetBackgroundColor(Color(171, 31, 31))
		panel:SetText("Covered in red blood.")
		panel:SizeToContents()
	end
	--[[
	elseif (IsValid(tooltip:GetRow("redBloody")) then
		tooltip:GetRow("redBloody"):Remove()
		tooltip:GetRow("redBloody"):SizeToContents()
	end
	]]--

	-- Yellow blood tooltip display.
	if (character:GetData("yellowBloody", false)) then
		local panel = tooltip:AddRow("yellowbloody")
		panel:SetBackgroundColor(Color(197, 214, 43))
		panel:SetText("Covered in yellow-green blood.")
		panel:SizeToContents()
	end
	--[[
	elseif (IsValid(tooltip:GetRow("yellowBloody")) then
		tooltip:GetRow("yellowBloody"):Remove()
		tooltip:GetRow("yellowBloody"):SizeToContents()
	end
	]]--

	if otherClient:Armor() > 0 then
		local armorPanel = tooltip:AddRowAfter("armor", "health")
		armorPanel:SetBackgroundColor(Color(30, 70, 180))

		if (otherClient:Armor() > 0 and otherClient:Armor() <= 20) then
			armorPanel:SetText("Barely Armored")
		elseif (otherClient:Armor() > 20 and otherClient:Armor() <= 50) then
			armorPanel:SetText("Somewhat Armored")
		elseif (otherClient:Armor() > 50 and otherClient:Armor() <= 100) then
			armorPanel:SetText("Armored")
		elseif (otherClient:Armor() > 100 and otherClient:Armor() <= 150) then
			armorPanel:SetText("Heavily Armored")
		elseif (otherClient:Armor() > 150 and otherClient:Armor() <= 200) then
			armorPanel:SetText("Very Heavily Armored")
		elseif (otherClient:Armor() > 200) then
			armorPanel:SetText("Extremely Heavily Armored")
		end

		armorPanel:SizeToContents()
	end

	-- Ziptie display.
	if (client:IsRestricted()) then
		local panel = tooltip:AddRowAfter("name", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText(L("tiedUp"))
		panel:SizeToContents()
	elseif (client:GetNetVar("tying")) then
		local panel = tooltip:AddRowAfter("name", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText(L("beingTied"))
		panel:SizeToContents()
	elseif (client:GetNetVar("untying")) then
		local panel = tooltip:AddRowAfter("name", "ziptie")
		panel:SetBackgroundColor(derma.GetColor("Warning", tooltip))
		panel:SetText(L("beingUntied"))
		panel:SizeToContents()
	end

end



hook.Remove("PostDrawEffects", "CinematicDraws")

local COMMAND_PREFIX = "/"

function Schema:ChatTextChanged(text)
	if (LocalPlayer():IsCombine()) then
		local key = nil

		if (text == COMMAND_PREFIX .. "radio ") then
			key = "r"
		elseif (text == COMMAND_PREFIX .. "w ") then
			key = "w"
		elseif (text == COMMAND_PREFIX .. "y ") then
			key = "y"
		elseif (text:sub(1, 1):match("%w")) then
			key = "t"
		end

		if (key) then
			netstream.Start("PlayerChatTextChanged", key)
		end
	end
end

function Schema:FinishChat()
	netstream.Start("PlayerFinishChat")
end

function Schema:CanPlayerJoinClass(client, class, info)
	return false
end

function Schema:CharacterLoaded(character)
	if (character:IsCombine()) then
		vgui.Create("ixCombineDisplay")
	elseif (IsValid(ix.gui.combine)) then
		ix.gui.combine:Remove()
	end
end

function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	return true
end

local COLOR_BLACK_WHITE = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1.5,
	["$pp_colour_colour"] = 0,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local combineOverlay = ix.util.GetMaterial("effects/combine_binocoverlay")
local scannerFirstPerson = false

function Schema:RenderScreenspaceEffects()
	local colorModify = {}
	colorModify["$pp_colour_colour"] = 0.77
	colorModify["$pp_colour_addg"] = 0.005

	if (system.IsWindows()) then
		colorModify["$pp_colour_brightness"] = -0.02
		colorModify["$pp_colour_contrast"] = 1.2
	else
		colorModify["$pp_colour_brightness"] = 0
		colorModify["$pp_colour_contrast"] = 1
	end

	if (scannerFirstPerson) then
		COLOR_BLACK_WHITE["$pp_colour_brightness"] = 0.05 + math.sin(RealTime() * 10) * 0.01
		colorModify = COLOR_BLACK_WHITE
	end

	DrawColorModify(colorModify)

	local faction = LocalPlayer():Team()

	if (faction == FACTION_MPF or faction == FACTION_OTA) then

		combineOverlay:SetFloat("$alpha", 0.5)
		combineOverlay:SetInt("$ignorez", 1)

		render.SetMaterial(combineOverlay)
		render.DrawScreenQuad()
	end

	--local timeFrac = math.ease.InOutQuint((CurTime()*0.5)%1)

	local advisorPainTab = {
		[ "$pp_colour_addr" ] = 0.1,
		[ "$pp_colour_addg" ] = 0,
		[ "$pp_colour_addb" ] = 0,
		[ "$pp_colour_brightness" ] = -0.1,
		[ "$pp_colour_contrast" ] = 1.15,
		[ "$pp_colour_colour" ] = 1,
		[ "$pp_colour_mulr" ] = 0,
		[ "$pp_colour_mulg" ] = 0,
		[ "$pp_colour_mulb" ] = 0
	}

	local curTime = CurTime()
	if curTime < eventEffectStartTime + 3 then
		DrawMaterialOverlay(overlayMat)
		DrawMaterialOverlay("effects/advisor_fx_001")
		--DrawMaterialOverlay("effects/tp_eyefx/tp_eyefx", Lerp(timeFrac, 0, 0.05))
	end

	--DrawMaterialOverlay("effects/tp_eyefx/tp_eyefx", timeFrac/20)
	--DrawMaterialOverlay("effects/tp_eyefx/tpeye", 0)
	--DrawMaterialOverlay("effects/advisor_fx_001", 0)
	--DrawMaterialOverlay("effects/advisor_fx_002", 0)
	--DrawMaterialOverlay("effects/advisor_fx_003", 0)
	
	/*

	

	*/
	--DrawColorModify( advisorColorTab )
	--DrawMaterialOverlay("effects/tp_eyefx/tpeye3", 0)
	/*



	DrawBloom(0.8, 2, 
	25, 25, 
	20, 
	1, 
	1, 1, 1)

	*/
	
	
end

function Schema:PreDrawOpaqueRenderables()
	local viewEntity = LocalPlayer():GetViewEntity()

	if (IsValid(viewEntity) and viewEntity:GetClass():find("scanner")) then
		self.LastViewEntity = viewEntity
		self.LastViewEntity:SetNoDraw(true)

		scannerFirstPerson = true
		return
	end

	if (self.LastViewEntity != viewEntity) then
		if (IsValid(self.LastViewEntity)) then
			self.LastViewEntity:SetNoDraw(false)
		end

		self.LastViewEntity = nil
		scannerFirstPerson = false
	end
end

function Schema:ShouldDrawCrosshair()
	if (scannerFirstPerson) then
		return false
	end
end

function Schema:AdjustMouseSensitivity()
	if (scannerFirstPerson) then
		return 0.3
	end
end

-- creates labels in the status screen
function Schema:CreateCharacterInfo(panel)
	if (LocalPlayer():Team() == FACTION_CITIZEN) then
		panel.cid = panel:Add("ixListRow")
		panel.cid:SetList(panel.list)
		panel.cid:Dock(TOP)
		panel.cid:DockMargin(0, 0, 0, 8)
	end
end

-- populates labels in the status screen
function Schema:UpdateCharacterInfo(panel)
	if (LocalPlayer():Team() == FACTION_CITIZEN) then
		panel.cid:SetLabelText(L("citizenid"))
		panel.cid:SetText(string.format("##%s", LocalPlayer():GetCharacter():GetData("cid") or "UNKNOWN"))
		panel.cid:SizeToContents()
	end
end

function Schema:BuildBusinessMenu(panel)
	local bHasItems = false

	for k, _ in pairs(ix.item.list) do
		if (hook.Run("CanPlayerUseBusiness", LocalPlayer(), k) != false) then
			bHasItems = true

			break
		end
	end

	return bHasItems
end

function Schema:PopulateHelpMenu(tabs)
	-- sorry, this is for alphabetization
	tabs["voices"] = {
		title = "Voice Lines",
		populate = function(container)
			local classes = {}

			for k, v in pairs(Schema.voices.classes) do
				if (v.condition(LocalPlayer())) then
					classes[#classes + 1] = k
				end
			end

			if (#classes < 1) then
				local info = container:Add("DLabel")
				info:SetFont("prSmallFont")
				info:SetText("You do not have access to any voice lines!")
				info:SetContentAlignment(5)
				info:SetTextColor(color_white)
				info:SetExpensiveShadow(1, color_black)
				info:Dock(TOP)
				info:DockMargin(0, 0, 0, 8)
				info:SizeToContents()
				info:SetTall(info:GetTall() + 16)

				info.Paint = function(_, width, height)
					surface.SetDrawColor(ColorAlpha(derma.GetColor("Error", info), 160))
					surface.DrawRect(0, 0, width, height)
				end

				return
			end

			table.sort(classes, function(a, b)
				return a < b
			end)

			for _, class in ipairs(classes) do
				local category = container:Add("Panel")
				category:Dock(TOP)
				category:DockMargin(0, 0, 0, 8)
				category:DockPadding(8, 8, 8, 8)
				category.Paint = function(_, width, height)
					surface.SetDrawColor(Color(0, 0, 0, 66))
					surface.DrawRect(0, 0, width, height)
				end

				local categoryLabel = category:Add("DLabel")
				categoryLabel:SetFont("prMediumThickFont")
				categoryLabel:SetText(class:upper())
				categoryLabel:Dock(FILL)
				categoryLabel:SetTextColor(color_white)
				categoryLabel:SetExpensiveShadow(1, color_black)
				categoryLabel:SizeToContents()
				category:SizeToChildren(true, true)

				for command, info in SortedPairs(self.voices.stored[class]) do
					local title = container:Add("DLabel")
					title:SetFont("prMediumLightFont")
					title:SetText(command:upper())
					title:Dock(TOP)
					title:SetTextColor(ix.config.Get("color"))
					title:SetExpensiveShadow(1, color_black)
					title:SizeToContents()

					local description = container:Add("DLabel")
					description:SetFont("prMediumLightFont")
					description:SetText(info.text)
					description:Dock(TOP)
					description:SetTextColor(color_white)
					description:SetExpensiveShadow(1, color_black)
					description:SetWrap(true)
					description:SetAutoStretchVertical(true)
					description:SizeToContents()
					description:DockMargin(0, 0, 0, 8)
				end
			end
		end
	}
end

function Schema:MessageReceived(client, info)
	local flexBones = {
		"jaw_drop",
		"left_part",
		"right_part",
		"left_mouth_drop",
		"right_mouth_drop",
		"lower_lip",
		"right_stretcher",
		"left_stretcher",
		"right_funneler",
		"left_funneler",
		"right_puckerer",
		"left_puckerer",
		"bite"
	}

	local hasAllBones = true

	for k, v in ipairs(flexBones) do
		if client:GetFlexIDByName(v) == nil then 
			hasAllBones = false
			break 
		end
	end


	if info.chatType == "ic" or info.chatType == "y" or info.chatType == "w" or info.chatType == "radio_eavesdrop" or info.chatType == "radio" then


		if client == LocalPlayer() then return end
		if client:GetNoDraw() then return end

		local typeClass = ix.chat.classes[info.chatType]
		local font = typeClass.font or "prChatFont"
		local lines = ix.util.WrapText(info.text, 500, font)

		

		client.TotalMsgLines = lines
		client.LastMessageTime = CurTime()
		

		client.CurrentMsgColor = type(typeClass) == "table" and (typeClass.GetColor and typeClass:GetColor(client, info.text) or typeClass.color) or ix.config.Get("chatColor")
		client.CurrentMsgFont = font

		local totalTime = 0

		if #client.TotalMsgLines > 3 then
			totalTime = ((#client.TotalMsgLines - #client.TotalMsgLines%3)/3)*10
			totalTime = totalTime + math.floor(math.Clamp(#table.concat(client.TotalMsgLines, "", #client.TotalMsgLines - 3)*0.1, 3, 10))
		else
			totalTime = math.floor(math.Clamp(#table.concat(client.TotalMsgLines, "")*0.1, 3, 10))
		end

		client.CurrentMsgLines = {}


		client.CurrentMsgDistance = type(typeClass.CanHear) != "function" and typeClass.CanHear or ix.config.Get("chatRange") 

		local time = client.LastMessageTime

	
		timer.Remove("MessageDisplayCycles")
		if #client.CurrentMsgLines > 3 then 
			timer.Create("MessageDisplayCycles", 10, math.ceil(#lines/3), function()
				if client.LastMessageTime != time then timer.Remove("MessageDisplayCycles") return end 
				client.CurrentMsgLines = {}
				if timer.RepsLeft("MessageDisplayCycles") == 0 then
					client.CurrentMsgLines = client.TotalMsgLines
					timer.Simple(math.floor(math.Clamp(#table.concat(client.TotalMsgLines, "")*0.1, 3, 10)), function()
						if client.LastMessageTime == time and IsValid(client) then 
							client.CurrentMsgLines = nil
						end
					end)

					client.CurrentMsgLines[1] = table.remove(client.TotalMsgLines, 1)
					client.CurrentMsgLines[2] = table.remove(client.TotalMsgLines, 1)
					client.CurrentMsgLines[3] = table.remove(client.TotalMsgLines, 1)
				else
					client.CurrentMsgLines[1] = table.remove(client.TotalMsgLines, 1)
					client.CurrentMsgLines[2] = table.remove(client.TotalMsgLines, 1)
					client.CurrentMsgLines[3] = table.remove(client.TotalMsgLines, 1)
				end
			end)
		else
			timer.Simple(math.floor(math.Clamp(#table.concat(client.TotalMsgLines, "")*0.1, 3, 10)), function()
				if client.LastMessageTime == time and IsValid(client) then 
					client.CurrentMsgLines = nil
				end
			end)
			client.CurrentMsgLines[1] = table.remove(client.TotalMsgLines, 1)
			client.CurrentMsgLines[2] = table.remove(client.TotalMsgLines, 1)
			client.CurrentMsgLines[3] = table.remove(client.TotalMsgLines, 1)

		end

		/*


		local numCycles = totalTime + math.random(5, 10)

		local closeTimes = {}

		for i=1, numCycles do
			closeTimes[i] = (totalTime/numCycles)*i

		end
		
		for i=1, numCycles - 1 do
			local negative = (math.random(2) == 2) and i != 1
			local offset = (totalTime/numCycles)*math.Rand(0, 0.2)
			closeTimes[i] = closeTimes[i] + (negative and offset*-1 or offset)
			
		end

		for i = 1, numCycles do
			closeTimes[i] = closeTimes[i] + client.LastMessageTime 
		end

		*/


		client.MsgCloseTimes = closeTimes
	end
end

netstream.Hook("CombineDisplayMessage", function(text, color, arguments)
	if (IsValid(ix.gui.combine)) then
		ix.gui.combine:AddLine(text, color, nil, unpack(arguments))
	end
end)

netstream.Hook("PlaySound", function(sound)
	surface.PlaySound(sound)
end)

netstream.Hook("Frequency", function(oldFrequency)
	Derma_StringRequest("Frequency", "What would you like to set the frequency to?", oldFrequency, function(text)
		ix.command.Send("SetFreq", text)
	end)
end)

netstream.Hook("ViewData", function(target, cid, data)
	Schema:AddCombineDisplayMessage("@cViewData")
	vgui.Create("ixViewData"):Populate(target, cid, data)
end)

netstream.Hook("ViewObjectives", function(data)
	Schema:AddCombineDisplayMessage("@cViewObjectives")
	vgui.Create("ixViewObjectives"):Populate(data)
end)

netstream.Hook("OpenImprovedViewData", function(target, data)
	print("about to add message")
	Schema:AddCombineDisplayMessage("@cViewData")
	print("about to open viewdata")
	vgui.Create("ixImprovedViewData"):Populate(target, data)
end)

net.Receive("prAptAction", function(len)
	local action = net.ReadUInt(32)

	if action == APTACT_OPEN then
		local aptSize = net.ReadUInt(32)
		local apartments = util.JSONToTable(util.Decompress(net.ReadData(aptSize)))
		ix.gui.debug = vgui.Create("ixApartmentManager")
		ix.gui.debug.buildingName = buildingName
		ix.gui.debug.apartments = apartments
	end
end)

net.Receive("ixOpenRadioMenu", function(len)
	local frequency = tonumber(net.ReadString())
	local volume = net.ReadUInt(7)

	local frame = vgui.Create("ixRadioEntMenu")
	frame:Populate(frequency, volume)
end)


net.Receive("ixStorageOpen", function()
	if (IsValid(ix.gui.menu)) then
		net.Start("ixStorageClose")
		net.SendToServer()
		return
	end

	local id = net.ReadUInt(32)
	local entity = net.ReadEntity()
	local name = net.ReadString()
	local data = net.ReadTable()

	local inventory = ix.item.inventories[id]

	if (IsValid(entity) and inventory and inventory.slots) then
		local localInventory = LocalPlayer():GetCharacter():GetInventory()
		local panel = vgui.Create("ixStorageView")

		if (localInventory) then
			panel:SetLocalInventory(localInventory)
		end

		panel:SetStorageID(id)
		panel:SetStorageTitle(name)
		panel:SetStorageInventory(inventory)

		if (data.money) then
			if (localInventory) then
				panel:SetLocalMoney(LocalPlayer():GetCharacter():GetMoney())
			end

			panel:SetStorageMoney(data.money)
		end
	end
end)

net.Receive("prSearchAsk", function(len)
	local client = net.ReadEntity()
	local target = LocalPlayer()
	Derma_Query(
		"A member of the "..ix.faction.Get(target:GetCharacter():GetFaction()).name.." faction is trying to search you. Do you allow them?",
		"Search",
		"Yes", function()
			net.Start("prSearchResponse")
				net.WriteEntity(client)
				net.WriteEntity(target)
				net.WriteBool(false)	
			net.SendToServer()
		end,
		"No", function()
			net.Start("prSearchResponse")
				net.WriteEntity(client)
				net.WriteEntity(target)
				net.WriteBool(true)	
			net.SendToServer()
		end
	)
end)

net.Receive("prCharacterUpdate", function(len)
	local idempKey = net.ReadString()

	local payload = {}
	payload.attributes = {
		strength = 5,
		agility = 5,
		intelligence = 5,
		constitution = 5
	}
	payload.specSkills = {}
	payload.traits = {}
	local skillPanels = {}

	local panel = vgui.Create("DFrame")
	panel:SetSize(1200, 700)
	panel:Center()
	panel:MakePopup()

	local frame = panel

	panel = panel:Add("DScrollPanel")
	panel:Dock(FILL)

	local lbl = panel:Add("DLabel")
	lbl:SetText("This character was made before the rerelease, so we have a few things to update about them.")
	lbl:Dock(TOP)

	lbl = panel:Add("DLabel")
	lbl:Dock(TOP)
	lbl:DockMargin(0, 24, 0, 0)
	lbl:SetText("Attributes")

	local pointsLeftVal = 3
	local pointsLeftLbl = panel:Add("DLabel")
	pointsLeftLbl:Dock(TOP)
	pointsLeftLbl:SetText("3 Points Left")

	for k, v in pairs(ix.attributes.list) do
		payload.attributes[k] = payload.attributes[k] or 5
		local attribBar = panel:Add("prAttributeAdjust")
		attribBar:SetText(v.name)
		attribBar:SetDescription(v.description)
		attribBar:Dock(TOP)
		attribBar:DockMargin(0, 0, 0, 15)

		attribBar.uniqueID = k

		function attribBar:CanIncrease()
			local pointTotal = 0
			for uniqueID, attribVal in pairs(payload.attributes) do
				pointTotal = pointTotal + attribVal
			end

			return pointTotal < (ix.attributes.creationPoints + table.Count(ix.attributes.list)*5)
		end

		function attribBar:PostClick(change)
			
			payload.attributes[self.uniqueID] = (payload.attributes[self.uniqueID] or 5) + change

			local pointTotal = 0
			for uniqueID, attribVal in pairs(payload.attributes) do
	
				pointTotal = pointTotal + attribVal
			end

			local pointsLeftVal = ix.attributes.creationPoints + table.Count(ix.attributes.list)*5 - pointTotal

			if pointsLeftVal == 1 then
				pointsLeftLbl:SetText(pointsLeftVal.." Point Left")
			else
				pointsLeftLbl:SetText(pointsLeftVal.." Points Left")
			end

			for k, v in pairs(skillPanels) do 
				v:SetupDisplayValue(table.HasValue(payload.specSkills, k))
			end
		end
	end

	local heading = panel:Add("DLabel")
	heading:Dock(TOP)
	heading:SetFont("ixCharNameFont")
	heading:SetText("Skills")
	heading:SizeToContents()
	heading:DockMargin(0, 0, 0, -22)

	local subtitle = panel:Add("DLabel")
	subtitle:Dock(TOP)
	subtitle:SetFont("prSubTitleFont")
	subtitle:SetText("Select up to two skills to have higher starting values.")
	subtitle:SizeToContents()
	subtitle:DockMargin(0, 0, 0, -7)

	local skillCountLbl = panel:Add("DLabel")
	skillCountLbl:Dock(TOP)
	skillCountLbl:SetFont("prSubTitleFont")
	skillCountLbl:SetText("2 Skills Left")
	skillCountLbl:SizeToContents()

	local specChecks = {}

	

	for k, skillTbl in ipairs(ix.skills.listSorted) do
		local skillPnl = panel:Add("Panel")
		skillPanels[k] = skillPnl
		skillPnl:Dock(TOP)
		skillPnl:DockMargin(0, 0, 0, 15)
		skillPnl.skill = skillTbl.uniqueID

		local headerPnl = skillPnl:Add("DPanel")
		headerPnl:Dock(TOP)
		headerPnl:SetTall(40)
		--headerPnl:SetBackgroundColor(Color(32, 32, 32, 100))

		local header = headerPnl:Add("ixLabel")
		header:Dock(FILL)
		header:SetText(skillTbl.name)
		header:SetFont("prMenuButtonFontSmall")
		header:SizeToContents()
		header:SetContentAlignment(5)	

		local contentPnl = skillPnl:Add("Panel")
		contentPnl:Dock(FILL)
		contentPnl:DockPadding(5, 8, 5, 8)

		contentPnl.Paint = function(panel, w,  h)
			surface.SetDrawColor(20, 20, 20)
			surface.DrawOutlinedRect(0, -1, w, h + 1)
		end
		
		local desc = contentPnl:Add("DLabel")
		desc:Dock(TOP)
		desc:SetWrap(true)
		desc:SetFont("prToolTipText")
		desc:SetText(skillTbl.description)

		local boost = contentPnl:Add("DLabel")
		boost:Dock(TOP)
		boost:SetWrap(true)
		boost:SetFont("prToolTipText")
		boost:DockMargin(0, 8, 0, 0)
		boost:SetText((skillTbl.boosts.smallBoost == nil) and (" - Large boost from "..skillTbl.boosts.largeBoost..".") or (" - Large boost from "..skillTbl.boosts.largeBoost..", small boost from "..skillTbl.boosts.smallBoost.."."))

		local specCheck = contentPnl:Add("prCheckboxLabel")
		specCheck:Dock(TOP)
		specCheck:SetTall(30)
		specCheck:SetText("Specialize")
		specCheck:SetFont("prToolTipText")

		specCheck.skill = skillTbl.uniqueID

		function specCheck:CanChangeValue(value)
			if !value then 
				return true
			else
				return #payload.specSkills < 2
			end
		end

		specChecks[skillTbl.uniqueID] = specCheck

		local skillPnlH = 40

		local contentPnlH = 16

		for k, v in ipairs(contentPnl:GetChildren()) do
			local marginL, marginT, marginR, marginB = v:GetDockMargin()
			contentPnlH = contentPnlH + v:GetTall() + marginT + marginB
		end

		skillPnlH = skillPnlH + contentPnlH

		skillPnl:SetTall(skillPnlH)

		local skillVal = contentPnl:Add("ixLabel")
		skillVal:SetSize(contentPnlH, contentPnlH)
		skillVal:SetPos(1200 - 3 - contentPnlH)
		skillVal:SetFont("prMenuButtonHugeFont")

		function skillPnl:SetupDisplayValue(addBoost)
			local boost = addBoost and 15 or 0 
			if skillTbl.boosts.smallBoost != nil then
				skillVal:SetText(ix.skills.CalculateBase(skillTbl.uniqueID, payload.attributes[string.lower(skillTbl.boosts.largeBoost)] or 5, payload.attributes[string.lower(skillTbl.boosts.smallBoost)] or 5) + boost)
			else
				skillVal:SetText(ix.skills.CalculateBase(skillTbl.uniqueID, payload.attributes[string.lower(skillTbl.boosts.largeBoost)] or 5) + boost)
			end
		end

		function specCheck:OnChanged(newValue)
			local specOffset = 0
			hasValue = table.HasValue(payload.specSkills, self.skill)
			if newValue then
				if !hasValue then
					table.insert(payload.specSkills, self.skill)
				end
				skillVal:SetTextColor(Color(231, 123, 56))
				specOffset = 15
			else
				if hasValue then
					table.RemoveByValue(payload.specSkills, self.skill)
				end
				skillVal:SetTextColor(color_white)
			end

			skillPnl:SetupDisplayValue(newValue)

			if 2 - #payload.specSkills == 1 then
				skillCountLbl:SetText(2 - #payload.specSkills.." Skill Left")
			else
				skillCountLbl:SetText(2 - #payload.specSkills.." Skills Left")
			end
		end	

		timer.Simple(0, function()
			specCheck:SetChecked(table.HasValue(payload.specSkills, skillTbl.uniqueID))
			skillPnl:SetupDisplayValue(specCheck:GetChecked())
		end)
		
	end

	heading = panel:Add("DLabel")
	heading:Dock(TOP)
	heading:SetFont("ixCharNameFont")
	heading:SetText("Traits")
	heading:SizeToContents()
	heading:DockMargin(0, 0, 0, -22)

	subtitle = panel:Add("DLabel")
	subtitle:Dock(TOP)
	subtitle:SetFont("prSubTitleFont")
	subtitle:SetText("Select up to two traits, perks that have both positive and negative effects.")
	subtitle:SizeToContents()
	subtitle:DockMargin(0, 0, 0, -7)

	countLbl = panel:Add("DLabel")
	countLbl:Dock(TOP)
	countLbl:SetFont("prSubTitleFont")
	countLbl:SetText("2 Traits Left")
	countLbl:SizeToContents()

	for k, traitTbl in ipairs(ix.traits.list) do
		local traitPnl = panel:Add("Panel")
		traitPnl:Dock(TOP)
		traitPnl:DockMargin(0, 0, 0, 15)
		traitPnl.trait = k
	
		local headerPnl = traitPnl:Add("DPanel")
		headerPnl:Dock(TOP)
		headerPnl:SetTall(40)
		--headerPnl:SetBackgroundColor(Color(32, 32, 32, 100))
	
		local header = headerPnl:Add("ixLabel")
		header:Dock(FILL)
		header:SetText(traitTbl.name)
		header:SetFont("prMenuButtonFontSmall")
		header:SizeToContents()
		header:SetContentAlignment(5)	
	
		local contentPnl = traitPnl:Add("Panel")
		contentPnl:Dock(FILL)
		contentPnl:DockPadding(5, 8, 5, 8)
	
		contentPnl.Paint = function(panel, w,  h)
			surface.SetDrawColor(20, 20, 20)
			surface.DrawOutlinedRect(0, -1, w, h + 1)
		end
		
		local desc = contentPnl:Add("DLabel")
		desc:Dock(TOP)
		desc:SetWrap(true)
		desc:SetFont("prToolTipText")
		desc:SetText(traitTbl.description)
	
		local checkbox = contentPnl:Add("prCheckboxLabel")
		checkbox:Dock(TOP)
		checkbox:SetTall(30)
		checkbox:SetText("Specialize")
		checkbox:SetFont("prToolTipText")
	
		checkbox.trait = k
	
		function checkbox:CanChangeValue(value)
			if !value then 
				return true
			else
				return #payload.traits < 2
			end
		end
	
		local traitPnlH = 40
	
		local contentPnlH = 16
	
		for k, v in ipairs(contentPnl:GetChildren()) do
			local marginL, marginT, marginR, marginB = v:GetDockMargin()
			contentPnlH = contentPnlH + v:GetTall() + marginT + marginB
		end
	
		traitPnlH = traitPnlH + contentPnlH
	
		traitPnl:SetTall(traitPnlH)
	
		function checkbox:OnChanged(newValue)
			hasValue = table.HasValue(payload.traits, self.trait)
			if newValue then
				if !hasValue then
					table.insert(payload.traits, self.trait)
				end
			else
				if hasValue then
					table.RemoveByValue(payload.traits, self.trait)
				end
			end
	
			if 2 - #payload.traits == 1 then
				countLbl:SetText(2 - #payload.traits.." Trait Left")
			else
				countLbl:SetText(2 - #payload.traits.." Traits Left")
			end
		end	
	
		timer.Simple(0, function()
			checkbox:SetChecked(table.HasValue(payload.traits, k))
		end)
		
	end

	local createButton = panel:Add("DButton")
	createButton:Dock(TOP)
	createButton:SetTall(ScrH()/15)
	createButton.Paint = function(this, w, h)
		surface.SetDrawColor(56, 56, 56)
		surface.DrawRect(0, 0, w, h)

		if this:IsHovered() or this:IsChildHovered() then
			surface.SetDrawColor(0, 0, 0, 50)
			surface.DrawRect(0, 0, w, h)
			if this:IsDown() then
				surface.DrawRect(0, 0, w, h)
			end
		end
	end
	createButton:SetFont("prCategoryHeadingFont")
	createButton:SetText("Update Character")
	createButton.DoClick = function(this)
		Derma_Query("Are you ready to update your character? This action cannot be undone.", "Update Character",
		"Yes", function()
			local tableStr = util.TableToJSON(payload)
			local compressed = util.Compress(tableStr)
			net.Start("prCharacterUpdateResponse")
				net.WriteUInt(#compressed, 32)
				net.WriteData(compressed)
			net.SendToServer()

			frame:Remove()
		end,
		
		"No", function() end)
	end

	for k, v in ipairs(panel:GetChildren()) do
		panel:AddItem(v)
	end
end)

net.Receive("prCivTerminal", function(len)
	local action = net.ReadUInt(32)

	if action == 1 then
		ix.gui.debug = vgui.Create("ixCitizenTerminal")
	end
end)

net.Receive("ixPadlockCode", function(length)
	local setPassword = net.ReadBool()
	local lockEnt = net.ReadInt(32)
	local err = net.ReadBool()

	print("lock", lockEnt)

	if !setPassword then
		Derma_StringRequest(
			"Locked Door",
			"Enter the combination.",
			"",
			function(val)
				net.Start("ixPadlockSend")
					net.WriteBool(false)
					net.WriteInt(lockEnt, 32)
					net.WriteString(val)
				net.SendToServer()
			end)
		else
			if err then
				Derma_Query("That combination is too long!", 
					"Error", 
					"OK", 
					function()
						Derma_StringRequest(
						"Locked Door",
						"What should this lock's combination be?",
						"",
						function(val)
							net.Start("ixPadlockSend")
								net.WriteBool(true)
								net.WriteInt(lockEnt, 32)
								net.WriteString(val)
							net.SendToServer()
						end)
					end)
			else
				Derma_StringRequest("Locked Door",
					"What should this lock's combination be?",
					"",
					function(val)
						net.Start("ixPadlockSend")
							net.WriteBool(true)
							net.WriteInt(lockEnt, 32)
							net.WriteString(val)
						net.SendToServer()
					end)
			end
	end
end)