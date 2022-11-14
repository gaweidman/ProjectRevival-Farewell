
-- Here is where all of your clientside hooks should go.

-- Disables the crosshair permanently.
function Schema:CharacterLoaded(character)
	self:ExampleFunction("@serverWelcome", character:GetName())
end

function Schema:LoadFonts()
	
end

surface.CreateFont("ixFalloutTitle", {
	font = "Overseer",
	extended = true, 
	size = 150, 
	weight = 50,
	blursize = 0,
	scanlines = 0,
	italic = true
})

surface.CreateFont("ixFalloutButtons", {
	font = "Monofonto",
	extended = false, 
	size = 45,
	weight = 100,
	antialias = true,
	blursize = 0,
	scanlines = 0
})
