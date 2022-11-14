
-- Here is where all of your clientside functions should go.

-- Example client function that will print to the chatbox.
function Schema:ExampleFunction(text, ...)
	if (text:sub(1, 1) == "@") then
		text = L(text:sub(2), ...)
	end

	LocalPlayer():ChatPrint(text)
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
	weight = 0.00001,
	antialias = true,
	blursize = 0,
	scanlines = 0,
	bold = false,
	shadow = true
})

surface.CreateFont("TestFont1", {
	font = "Roboto",
	extended = false, 
	size = 45,
	weight = 100,
	antialias = true,
	blursize = 0,
	scanlines = 0
})

surface.CreateFont("TestFont2", {
	font = "Roboto",
	extended = false, 
	size = 45,
	weight = 1000,
	antialias = true,
	blursize = 0,
	scanlines = 0
})

surface.CreateFont("TestFont4", {
	font = "Coolvetica",
	extended = false, 
	size = 18,
	weight = 2000,
	antialias = true,
	blursize = 0,
	scanlines = 0
})