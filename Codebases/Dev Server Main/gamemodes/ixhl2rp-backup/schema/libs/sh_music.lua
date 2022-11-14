/*
	Struct: Song
	String Name - The name of the song.
	String Album - The album the song is from.
	String Game - The game the song is from.

	String Intensity - A rating from 0-10 of the song's intensity. Zero is regular, chill roleplay. 10 is fighting off the entirety of the Citadel's overwatch forces.
	String[] Tags - A list of tags for the song, possible tags listed below.
*/

/*
	Possible Tags:
	-- Relaxed
	-- Upbeat
	-- Intense
	-- Xenian
	-- Combine
	-- Action
	-- Stinger
	-- Chords (Consisting of mainly just simple chords.)
	-- Classical
	-- Mysterious
    -- Industrial
    -- Long
    -- Short
    -- Gritty
    -- Combat
    -- Foreboding
    -- Trespassing
    -- Chase
    -- Vortal
    -- Somber
    -- Military
    -- Ambient
*/

ix.music = ix.music or {}
ix.music.songs = {
	{
		["name"] = "Exposing Hostile",
		["album"] = "Half-Life: Alyx (Chapter 1, \"Breaking & Entering\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

		["intensity"] = 7,
		["tags"] = {"Upbeat", "Intense", "Action"}
	},
    {
        ["name"] = "Coetaneous Entanglement",
		["album"] = "Half-Life: Alyx (Chapter 1, \"Breaking & Entering\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",
        
		["intensity"] = 4,
        ["tags"] = {"Gritty", "Mysterious", "Combine", "Long"}
    },
    {
        ["name"] = "Construction Strider",
		["album"] = "Half-Life: Alyx (Chapter 1, \"Breaking & Entering\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

		["intensity"] = 3,
        ["tags"] = {"Short", "Combine"}
    },
    {
        ["name"] = "Engage. Quell. Inquire.",
		["album"] = "Half-Life: Alyx (Chapter 1, \"Breaking & Entering\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

		["intensity"] = 6,
        ["tags"] = {"Intense", "Combine", "Foreboding"}
    },
    {
        ["name"] = "Insubordination Relocation",
		["album"] = "Half-Life: Alyx (Chapter 1, \"Breaking & Entering\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

		["intensity"] = 2,
        ["tags"] = {"Foreboding", "Combine", "Mysterious"}
    },
    {
        ["name"] = "City 17 Strider",
		["album"] = "Half-Life: Alyx (Chapter 1, \"Breaking & Entering\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

		["intensity"] = 3,
        ["tags"] = {"Short", "Combine", "Foreboding"}
    },
    {
        ["name"] = "Thity Seven After Six",
		["album"] = "Half-Life: Alyx (Chapter 1, \"Breaking & Entering\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

		["intensity"] = 0,
        ["tags"] = {"Classical", "Relaxed"}
    },
    {
        ["name"] = "Quaranta Giorni",
		["album"] = "Half-Life: Alyx (Chapter 2, \"The Quarantine Zone\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

		["intensity"] = 6,
        ["tags"] = {"Foreboding", "Intense", "Gritty", "Long", "Combine", "Mysterious", "Industrial"}
    },
    {
        ["name"] = "Xombies",
		["album"] = "Half-Life: Alyx (Chapter 2, \"The Quarantine Zone\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

		["intensity"] = 6,
        ["tags"] = {"Gritty", "Foreboding", "Intense"}
    },
    {
        ["name"] = "Only One",
		["album"] = "Half-Life: Alyx (Chapter 2, \"The Quarantine Zone\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

		["intensity"] = 1,
        ["tags"] = {"Mysterious", "Xenian"}
    },
    {
        ["name"] = "Matter of Perspective",
		["album"] = "Half-Life: Alyx (Chapter 2, \"The Quarantine Zone\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

		["intensity"] = 2,
        ["tags"] = {"Xenian", "Mysterious", "Foreboding"}
    },
    {
        ["name"] = "Severed from the Vortessence",
		["album"] = "Half-Life: Alyx (Chapter 2, \"The Quarantine Zone\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

		["intensity"] = 3,
        ["tags"] = {"Mysterious", "Alien"}
    },
    {
        ["name"] = "Is Or Will Be?",
		["album"] = "Half-Life: Alyx (Chapter 3, \"Is or Will Be?\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

		["intensity"] = 3,
        ["tags"] = {"Mysterious", "Long", "Xenian", "Vortal"}
    },
    {
        ["name"] = "What Did it Taste Like?",
		["album"] = "Half-Life: Alyx (Chapter 3, \"Is or Will Be?\")",
		["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

		["intensity"] = 3,
        ["tags"] = {"Mysterious", "Long", "Xenian", "Vortal"}
    },
    {
        ["name"] = "I Love This Gun",
        ["album"] = "Half-Life: Alyx (Chapter 2, \"The Quarantine Zone\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 1,
        ["tags"] = {"Long", "Foreboding", "Trespassing", "Mysterious"}
    },
    {
        ["name"] = "Extra-Dimensional Darkness",
        ["album"] = "Half-Life: Alyx (Chapter 3, \"Is or Will Be?\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 1,
        ["tags"] = {"Long", "Foreboding", "Gritty", "Chords", "Trespassing"}
    },
    {
        ["name"] = "Quantum Cubicles",
        ["album"] = "Half-Life: Alyx (Chapter 3, \"Is or Will Be?\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 1,
        ["tags"] = {"Long", "Foreboding", "Chords", "Gritty", "Trespassing"}
    },
    {
        ["name"] = "Infestation Control",
        ["album"] = "Half-Life: Alyx (Chapter 3, \"Is or Will Be?\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Combine", "Short", "Foreboding", "Gritty", "Trespassing"}
    },
    {
        ["name"] = "Deployed and Designated to Prosecute",
        ["album"] = "Half-Life: Alyx (Chapter 3, \"Is or Will Be?\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Intense", "Chase", "Action", "Trespassing", "Combine"}
    },
    {
        ["name"] = "Infestation Control",
        ["album"] = "Half-Life: Alyx (Chapter 3, \"Is or Will Be?\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Combine", "Short", "Foreboding", "Gritty", "Trespassing"}
    },
    {
        ["name"] = "B3PblBONACHOCTb",
        ["album"] = "Half-Life: Alyx (Chapter 3, \"Is or Will Be?\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 2,
        ["tags"] = {"Combine", "Foreboding", "Gritty", "Mysterious"}
    },
    {
        ["name"] = "Anti-Citizen",
        ["album"] = "Half-Life: Alyx (Chapter 3, \"Is or Will Be?\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 7,
        ["tags"] = {"Intense", "Action", "Chase", "Combine", "Combat", "Intense"}
    },
    {
        ["name"] = "Tri-Vector Pre-Reverberation",
        ["album"] = "Half-Life: Alyx (Chapter 3, \"Is or Will Be?\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Foreboding", "Mysterious", "Alien"}
    },
    {
        ["name"] = "Harsh Industrial Train Crash",
        ["album"] = "Half-Life: Alyx (Chapter 3, \"Is or Will Be?\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Intense", "Combine", "Chase", "Trespassing", "Gritty"}
    },
    {
        ["name"] = "The Advisors",
        ["album"] = "Half-Life: Alyx (Chapter 3, \"Is or Will Be?\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Foreboding", "Combine", "Mysterious", ""}
    },
    {
        ["name"] = "Prisoner Pod",
        ["album"] = "Half-Life: Alyx (Chapter 3, \"Is or Will Be?\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Combine", "Gritty", "Intense", "Chase", "Action", "Vortal"}
    },
    {
        ["name"] = "Charger",
        ["album"] = "Half-Life: Alyx (Chapter 4, \"Superweapon\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Combine", "Foreboding", "Gritty", "Short", "Mysterious"}
    },
    {
        ["name"] = "Scanning Hostile Biodats",
        ["album"] = "Half-Life: Alyx (Chapter 4, \"Superweapon\")",
        ["game"] = "Half-Life: Alyx",

        ["intensity"] = 8,
        ["tags"] = {"Combine", "Combat", "Action", "Chase", "Intense", "Stinger"}
    },
    {
        ["name"] = "Substation",
        ["album"] = "Half-Life: Alyx (Chapter 4, \"Superweapon\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Combine", "Gritty", "Foreboding"}
    },
    {
        ["name"] = "Alien Flora",
        ["album"] = "Half-Life: Alyx (Chapter 5, \"The Northern Star\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 0,
        ["tags"] = {"Xenian", "Mysterious", "Gritty"}
    },
    {
        ["name"] = "Alien Fauna",
        ["album"] = "Half-Life: Alyx (Chapter 5, \"The Northern Star\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 1,
        ["tags"] = {"Xenian", "Mysterious", "Gritty", "Stinger"}
    },
    {
        ["name"] = "Requiem Vortessence",
        ["album"] = "Half-Life: Alyx (Chapter 5, \"The Northern Star\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 2,
        ["tags"] = {"Vortal", "Gritty", "Mysterious", "Xenian"}
    },
    {
        ["name"] = "Lightning Dog",
        ["album"] = "Half-Life: Alyx (Chapter 5, \"The Northern Star\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 5,
        ["tags"] = {"Stinger", "Xenian", "Combat", "Action", "Gritty"}
    },
    {
        ["name"] = "Arachnophobia",
        ["album"] = "Half-Life: Alyx (Chapter 5, \"The Northern Star\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 2,
        ["tags"] = {"Mysterious", "Xenian", "Long"}
    },
    {
        ["name"] = "Rabid Lightning",
        ["album"] = "Half-Life: Alyx (Chapter 5, \"The Northern Star\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Xenian", "Combat", "Stinger", "Chase", "Action"}
    },
    {
        ["name"] = "Extract Resonate Isolate",
        ["album"] = "Half-Life: Alyx (Chapter 5, \"The Northern Star\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 2,
        ["tags"] = {"Vortal", "Mysterious", "Gritty"}
    },
    {
        ["name"] = "Anti-Civil Activities",
        ["album"] = "Half-Life: Alyx (Chapter 5, \"The Northern Star\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 5,
        ["tags"] = {"Combine", "Action", "Chase", "Gritty"}
    },
    {
        ["name"] = "Vortessence Lux",
        ["album"] = "Half-Life: Alyx (Chapter 6, \"Arms Race\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 1,
        ["tags"] = {"Vortal", "Mysterious", "Gritty"}
    },
    {
        ["name"] = "Hacking",
        ["album"] = "Half-Life: Alyx (Chapter 6, \"Arms Race\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Combine", "Action", "Short"}
    },
    {
        ["name"] = "Outbreak is Uncontained",
        ["album"] = "Half-Life: Alyx (Chapter 6, \"Arms Race\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 7,
        ["tags"] = {"Action", "Combat", "Chase", "Stinger", "Combine", "Gritty", "Intense"}
    },
    {
        ["name"] = "Processing Tripmines",
        ["album"] = "Half-Life: Alyx (Chapter 6, \"Arms Race\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Stinger", "Foreboding", "Gritty"} 
    },
    {
        ["name"] = "Xenfestation Control",
        ["album"] = "Half-Life: Alyx (Chapter 7, \"Jeff\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 2,
        ["tags"] = {"Xenian", "Mysterious", "Chords"} 
    },
    {
        ["name"] = "Sunset Vault",
        ["album"] = "Half-Life: Alyx (Chapter 7, \"Jeff\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 0,
        ["tags"] = {"Xenian", "Chords", "Somber"} 
    },
    {
        ["name"] = "Ear Like Mozart",
        ["album"] = "Half-Life: Alyx (Chapter 7, \"Jeff\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 1,
        ["tags"] = {"Foreboding", "Xenian", "Mysterious", "Long"} 
    },
    {
        ["name"] = "Jeff",
        ["album"] = "Half-Life: Alyx (Chapter 7, \"Jeff\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 2,
        ["tags"] = {"Stinger", "Foreboding", "Xenian"} 
    },
    {
        ["name"] = "Elevatormuzik",
        ["album"] = "Half-Life: Alyx (Chapter 7, \"Jeff\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 2,
        ["tags"] = {"Long", "Foreboding"} 
    },
    {
        ["name"] = "Trash Compactor Waltz",
        ["album"] = "Half-Life: Alyx (Chapter 7, \"Jeff\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Classical"} 
    },
    {
        ["name"] = "Quantum Antlion Tunnel",
        ["album"] = "Half-Life: Alyx (Chapter 7, \"Jeff\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Stinger", "Foreboding"} 
    },
    {
        ["name"] = "Cats",
        ["album"] = "Half-Life: Alyx (Chapter 8, \"Captivity\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Classical", "Foreboding"} 
    },
    {
        ["name"] = "Beasts of Prey",
        ["album"] = "Half-Life: Alyx (Chapter 8, \"Captivity\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Combine", "Intense", "Chase", "Action", "Stinger"} 
    },
    {
        ["name"] = "Insects and Reptiles",
        ["album"] = "Half-Life: Alyx (Chapter 8, \"Captivity\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Mysterious", "Classical"} 
    },
    {
        ["name"] = "The Last Substation",
        ["album"] = "Half-Life: Alyx (Chapter 9, \"Revelations\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 5,
        ["tags"] = {"Stinger", "Combine", "Foreboding"} 
    },
    {
        ["name"] = "Trans-Human Crossfire",
        ["album"] = "Half-Life: Alyx (Chapter 9, \"Revelations\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 7,
        ["tags"] = {"Combine", "Action", "Chase", "Combat", "Long", "Stinger"} 
    },
    {
        ["name"] = "Let Me Talk To Your Super-Advisor",
        ["album"] = "Half-Life: Alyx (Chapter 9, \"Revelations\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 5,
        ["tags"] = {"Combine", "Foreboding"} 
    },
    {
        ["name"] = "Terin #6",
        ["album"] = "Half-Life: Alyx (Chapter 9, \"Revelations\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Long", "Foreboding", "Intense", "Action", "Chase", "Combine"} 
    },
    {
        ["name"] = "Infestation Ambiance",
        ["album"] = "Half-Life: Alyx (Chapter 10, \"Breaking and Entering\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 2,
        ["tags"] = {"Foreboding", "Alien", "Stinger", "Gritty"} 
    },
    {
        ["name"] = "A Gentle Docking",
        ["album"] = "Half-Life: Alyx (Chapter 10, \"Breaking and Entering\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Intense", "Action", "Chase"} 
    },
    {
        ["name"] = "Overload Protocol",
        ["album"] = "Half-Life: Alyx (Chapter 10, \"Breaking and Entering\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Combine", "Classical", "Foreboding"} 
    },
    {
        ["name"] = "Cauterizer",
        ["album"] = "Half-Life: Alyx (Chapter 10, \"Breaking and Entering\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 8,
        ["tags"] = {"Action", "Combat", "Chase", "Intense", "Combine", "Long"} 
    },
    {
        ["name"] = "P1",
        ["album"] = "Half-Life: Alyx (Chapter 10, \"Breaking and Entering\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 5,
        ["tags"] = {"Action", "Chase", "Combine", "Long"} 
    },
    {
        ["name"] = "Gravity Perforation Detail",
        ["album"] = "Half-Life: Alyx (Chapter 10, \"Breaking and Entering\")",
        ["game"] = "Half-Life: Alyx",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Action", "Chase", "Combat", "Combine", "Long", "Stinger", "Gritty", "Intense"} 
    },
    {
        ["name"] = "Hazardous Environments",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Action", "Intense", "Short"}
    },
    {
        ["name"] = "CP Violation",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Action", "Intense", "Short", "Combat", "Chase"}
    },
    {
        ["name"] = "The Innsbruck Experiment",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 5,
        ["tags"] = {"Action", "Intense", "Short", "Chase"}
    },
    {
        ["name"] = "Brane Scan",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Trespassing", "Short", "Chase"}
    },
     {
        ["name"] = "Dark Energy",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Short", "Chase", "Combat", "Action", "Intense"}
    },
    {
        ["name"] = "Requiem for Ravenholm",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Stinger", "Short", "Foreboding"}
    },
    {
        ["name"] = "Pulse Phase",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 5,
        ["tags"] = {"Short", "Foreboding", "Intense", "Gritty", "Industrial"}
    },
    {
        ["name"] = "Ravenholm Reprise",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Short", "Foreboding", "Gritty", "Industrial", "Mysterious"}
    },
    {
        ["name"] = "Probably Not a Problem",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Combine", "Short", "Foreboding", "Mysterious"}
    },
    { 
        ["name"] = "Calabi-Yau Model",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 2,
        ["tags"] = {"Short", "Foreboding", "Mysterious", "Xenian"}
    },
    { 
        ["name"] = "Slow Light",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 1,
        ["tags"] = {"Short", "Foreboding", "Mysterious"}
    },
    { 
        ["name"] = "Apprehension and Evasion",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 7,
        ["tags"] = {"Intense", "Chase", "Action", "Trespassing", "Combine", "Gritty"}
    },
    { 
        ["name"] = "Our Resurrected Teleport",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 1,
        ["tags"] = {"Gritty", "Industrial", "Combine"}
    },
    { 
        ["name"] = "Miscount Detected",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Intense", "Combine", "Foreboding", "Short"}
    },
    { 
        ["name"] = "Triage at Dawn",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Gritty", "Somber", "Short"}
    },
    { 
        ["name"] = "Combine Harvester",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Foreboding", "Short", "Combine", "Gritty"}
    },
    { 
        ["name"] = "Lab Practicum",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 1,
        ["tags"] = {"Mysterious", "Chords", "Vortal"}
    },
    { 
        ["name"] = "Nova Prospekt",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Gritty", "Chords"}
    },
    { 
        ["name"] = "Broken Symmetry",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 1,
        ["tags"] = {"Mysterious", "Chords", "Short"}
    },
    { 
        ["name"] = "LG Orbifold",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Intense", "Action", "Combat", "Chase"}
    },  
    { 
        ["name"] = "You're Not Supposed To Be Here",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Intense", "Action", "Combat", "Chase"}
    },  
    { 
        ["name"] = "Suppression Field",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Mysterious", "Chords", "Foreboding", "Short"}
    },  
    { 
        ["name"] = "Hard Fought",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Action", "Combat", "Chase", "Intense", "Short"}
    },  
    { 
        ["name"] = "Particle Ghost",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Gritty", "Combine", "Mysterious", "Short"}
    },  
    { 
        ["name"] = "Neutrino Trap",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Gritty", "Chords", "Foreboding", "Short"}
    },  
    { 
        ["name"] = "Zero Point Energy Field",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Gritty", "Mysterious", "Foreboding", "Short"}
    },  
    { 
        ["name"] = "Echoes of a Resonance Cascade",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 1,
        ["tags"] = {"Mysterious", "Chords"}
    },  
    { 
        ["name"] = "Xen Relay",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Gritty", "Mysterious", "Foreboding", "Short"}
    }, 
    { 
        ["name"] = "Tracking Device",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 6,
        ["tags"] = {"Upbeat", "Intense", "Short"}
    },
    { 
        ["name"] = "Singularity (2004)",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Mysterious", "Short", "Gritty", "Combine"}
    },
    { 
        ["name"] = "Dirac Shore",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Mysterious", "Short", "Xenian"}
    },
    { 
        ["name"] = "Escape Array",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Short", "Gritty"}
    },
    { 
        ["name"] = "Tau-9",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 3,
        ["tags"] = {"Foreboding", "Upbeat"}
    },
    { 
        ["name"] = "Something Secret Steers Us",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 7,
        ["tags"] = {"Intense", "Action", "Combat", "Gritty"}
    },
    { 
        ["name"] = "Triple Entanglement",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Gritty", "Trespassing", "Short"}
    },
    { 
        ["name"] = "Biozeminade Fragment",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 4,
        ["tags"] = {"Gritty", "Combat", "Action", "Short"}
    },
    { 
        ["name"] = "Lambda Core",
        ["album"] = "Half-Life 2 (Original Game Soundtrack)",
        ["game"] = "Half-Life 2",
        ["artist"] = "Valve",

        ["intensity"] = 8,
        ["tags"] = {"Combat", "Action", "Intense", "Chase", "Gritty"}
    },
    {
        ["name"] = "Metallic Monks",
        ["album"] = "Fallout OST",
        ["game"] = "Fallout: A Post-Nuclear Roleplaying Game",
        ["artist"] = "Mark Morgan",
        ["path"] = "music/pr/fallout/metallicmonks.mp3",
        ["area"] = "nexus",

        ["intensity"] = 0,
        ["tags"] = {"Mysterious", "Relaxed", "Military", "Ambient"}
    },
    {
        ["name"] = "Vats of Goo",
        ["album"] = "Fallout OST",
        ["game"] = "Fallout: A Post-Nuclear Roleplaying Game",
        ["artist"] = "Mark Morgan",
        ["path"] = "music/pr/fallout/vatsofgoo.mp3",
        ["area"] = "NO AREA",

        ["intensity"] = 0,
        ["tags"] = {"Mysterious", "Relaxed", "Military", "Ambient"}
    },
    {
        ["name"] = "Dawn",
        ["album"] = "Third / Dawn (2018)",
        ["artist"] = "Hiatus",
        ["path"] = "music/pr/hiatusdawn.mp3",

        ["intensity"] = 0,
        ["tags"] = {"Relaxed", "Ambient", "Somber"}
    },
    {
        ["name"] = "Away",
        ["path"] = "music/pr/away.mp3",

        ["intensity"] = 0,
        ["tags"] = {"Relaxed", "Ambient"}
    },
    {
        ["name"] = "Freezing But Warm",
        ["path"] = "music/pr/freezingbutwarm.mp3",

        ["intensity"] = 0,
        ["tags"] = {"Relaxed", "Ambient"}
    },
    {
        ["name"] = "Machina",
        ["path"] = "music/pr/machina.mp3",

        ["intensity"] = 0,
        ["tags"] = {"Relaxed", "Ambient"}
    },
    {
        ["name"] = "Room With No View",
        ["path"] = "music/pr/roomwithnoview.mp3",

        ["intensity"] = 0,
        ["tags"] = {"Relaxed", "Ambient"}
    },
    {
        ["name"] = "Singularity",
        ["path"] = "music/pr/singularity.mp3",

        ["intensity"] = 0,
        ["tags"] = {"Relaxed", "Ambient"}
    },
    {
        ["name"] = "Tired of Life",
        ["path"] = "music/pr/tiredoflife.mp3",

        ["intensity"] = 0,
        ["tags"] = {"Relaxed", "Ambient"}
    },
    {
        ["name"] = "You Are the Blood",
        ["artist"] = "The Castanets",
        ["game"] = "Hotline Miami 2",
        ["path"] = "music/pr/youaretheblood.wav",

        ["intensity"] = 3,
        ["tags"] = {"Somber", "Stinger"}
    },
    {
        ["name"] = "We'll Meet Again",
        ["artist"] = "Johnny Cash",
        ["path"] = "music/pr/wellmeetagainjohnnycash.wav",

        ["intensity"] = 3,
        ["tags"] = {"Somber", "Stinger"}
    },
}

ix.option.Add("enableBGMusic", ix.type.bool, true, {
    category = "Immersion",
    phrase = "Enable Background Music",
    description = "Enable or disable the dynamic background music.",
    OnChanged = function(oldVal, newVal)
        if CLIENT then
            if ix.music.overrideUntil and ix.music.overrideUntil > CurTime()then 
                return
            end
            if newVal == false then
                if IsValid(ix.music.curChannel) then
                    ix.music.curChannel:Stop()
                    ix.music.curChannel = nil
                end

                ix.music.doneTime = -1
                if IsValid(ix.music.nextChannel) then
                    ix.music.nextChannel:Stop()
                    ix.music.nextChannel = nil
                end
            else
                ix.music.PlayNextSong(true)
            end
        end
    end
})

ix.option.Add("bgMusicVolume", ix.type.number, 100, {
    category = "Immersion",
    phrase = "Background Music Volume",
    description = "Enable or disable the dynamic background music.",
    max = 150,
    min = 0,
    OnChanged = function(oldVal, newVal)
        if CLIENT then
            if IsValid(ix.music.curChannel) then
                ix.music.curChannel:SetVolume(newVal/100)
            end
        end
    end
})

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
    COMMAND.adminOnly = true

	function COMMAND:OnRun(client, message)
        if !ix.music.SongExists(message) then
            client:Notify("That is not a valid song!")
            return
        end

        client:Notify("Overriding song...")

		net.Start("prMusicOverride")
            net.WriteString(message)
        net.Broadcast()
	end

	ix.command.Add("OverrideSong", COMMAND)
end

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
        if client:SteamID64() != "76561198066461105" then
            client:Notify("This command isn't for you.")
            return
        end

        net.Start("prMusicOverride")
            net.WriteString("You Are the Blood")
        net.Broadcast()

        ix.chat.Send(client, "event", "Jonathan\'s left shoulder jerks upward suddenly in a spasm. His head jerks toward his shoulder. He loses his grip on Rick.")
        timer.Simple(2, function() 
            ix.chat.Send(client, "event", "Rick falls.")
            timer.Simple(2.25, function()
                ix.chat.Send(client, "event", "Jonathan\'s spasm ends as quickly as it starts, but Rick is already falling. He can\'t be caught. Jonathan reaches for his arm, but can\'t. Jonathan\'s eyes widen in fear.")
                timer.Simple(2.5, function()
                    ix.chat.Send(client, "event", "Rick hits the cold, tile floor. A large thud rings around, breaking the stillness with the force of a train.")
                    timer.Simple(2.5, function()
                        ix.chat.Send(client, "event", "Jonathan bends down to pick him back up.")
                        timer.Simple(1.5, function()
                            ix.chat.Send(client, "event", "\"Oh my gosh, Dad, I\'m so sorry, I had a-\"")
                            timer.Simple(2, function()
                                ix.chat.Send(client, "event", "Rick\'s eyes are wide. A combination of fear and glassiness fills them. His body is stiff, his head or eyes don\'t move to look at Jonathan. He\'s trembling.")
                                timer.Simple(2.5, function()
                                    ix.chat.Send(client, "event", "\"Dad?\"")
                                    timer.Simple(1.25, function()
                                        ix.chat.Send(client, "event", "The trembling turns to shaking. Rick is seizing.")
                                        timer.Simple(2, function()
                                            ix.chat.Send(client, "event", "Jonathan speaks quietly, under his breath. \"No..\"")
                                            timer.Simple(2, function()
                                                    ix.chat.Send(client, "event", "Rick isn\'t responsive as Jonathan speaks. He quietly gasps short, shallow breaths. No words leave Rick's mouth. Just gasping. His arm weakly reaches out to the corner of the counter with all of his pill bottles.")
                                                    timer.Simple(3, function()
                                                        ix.chat.Send(client, "event", "Rick\'s arm slowly lowers. His seizure induced twitches gradually slow until he\'s no longer moving.")
                                                        timer.Simple(3.5, function()
                                                            ix.chat.Send(client, "event", "Jonathan only now notices the tears streaming down his face.")
                                                            timer.Simple(2, function()
                                                                ix.chat.Send(client, "event", "\"No, it\'s okay… dad, you\'re okay, you\'ll be okay… Dad… Dad...\"")
                                                                timer.Simple(2, function()
                                                                    ix.chat.Send(client, "event", "Jonathan\'s voice quiets to a whisper.")
                                                                    timer.Simple(2, function()
                                                                        ix.chat.Send(client, "event", "\"I\'m sorry, dad, I\'m sorry, I\'m so sorry, I\'m sorry…\"")
                                                                        timer.Simple(2, function()
                                                                            ix.chat.Send(client, "event", "His voice gives way to tears. He sits on the ground beside Rick\'s now lifeless body. He leans forward and cries like never before in his life.")
                                                                        end)
                                                                    end)
                                                                end)
                                                            end)
                                                        end)
                                                    end)
                                                end)
                                            end)
                                        end)
                                    end)
                                end)
                            end)
                        end)
                    end)
                end)
            end)
	end

    

	ix.command.Add("ItWasntYourFault", COMMAND)
end

function ix.music.GetSongTable(name)
    for k, v in ipairs(ix.music.songs) do
        if v.name == name then
            return v
        end
    end
end

function ix.music.GetRelaxed()
    local songs = {}
    for k, v in ipairs(ix.music.songs) do
        if table.HasValue(v.tags) then
            songs[#songs + 1] = v.path
        end
    end
end

function ix.music.GetByTag(tag, inclAreaSpecific)
    local inclArea = inclAreaSpecific or false
    local songs = {}
    for k, v in ipairs(ix.music.songs) do
        if !inclArea and v.area != nil then continue end
        if table.HasValue(v.tags, tag) then
            songs[#songs + 1] = v
        end
    end

    return songs
end

function ix.music.GetByArea(area)
    local inclArea = inclAreaSpecific or false
    local songs = {}
    for k, v in ipairs(ix.music.songs) do
        if !v.area then continue end
        if string.find(string.lower(area), v.area) then
            songs[#songs + 1] = v
        end
    end

    return songs
end

function ix.music.GetSongPath(name)
    for k, v in ipairs(ix.music.songs) do
        if v.name == name then
            return v.path
        end
    end
end

function ix.music.SongExists(name)
    for k, v in ipairs(ix.music.songs) do
        if v.name == name then
            return true
        end
    end

    return false
end

function ix.music.SetOverride(song)
    ix.music.overrideUntil = CurTime() + SoundDuration(ix.music.GetSongPath(song))
end

local bgSongs = {
    "music/pr/freezingbutwarm.mp3",
    "music/pr/hiatusdawn.mp3",
    "music/pr/machina.mp3",
    "music/pr/roomwithnoview.mp3",
    "music/pr/singularity.mp3",
    "music/pr/tiredoflife.mp3"
}

if CLIENT then
    hook.Add("Think", "MusicManage", function()
        if !IsValid(ix.music.curChannel) then return end
        if ix.music.doneTime != nil and ix.music.doneTime != -1 and CurTime() >= ix.music.doneTime then
            if IsValid(ix.music.curChannel) then
                ix.music.curChannel:Stop()
            end

            if IsValid(ix.music.nextChannel) then
                ix.music.curChannel = ix.music.nextChannel
                ix.music.doneTime = ix.music.nextDoneTime
                ix.music.fadeTime = ix.music.nextFadeTime

                ix.music.curSong = ix.music.nextSong

                ix.music.nextChannel = nil
            end 
        

        elseif !ix.music.TryingPlaySong and IsValid(ix.music.curChannel) and ix.music.fadeTime != nil and ix.music.fadeTime != -1 and CurTime() >= ix.music.fadeTime then
            if !IsValid(ix.music.nextChannel) then
                if (ix.music.overrideUntil and ix.music.overrideUntil <= CurTime()) or !ix.music.overrideUntil then 
                    ix.music.PlayNextSong()
                end
                ix.music.TryingPlaySong = true
                return
            end

            local maxVolume = ix.option.Get("bgMusicVolume", 1)
         
            ix.music.curChannel:SetVolume(Lerp((CurTime() - ix.music.fadeTime)/3, maxVolume/100, 0))
            ix.music.nextChannel:SetVolume(Lerp((CurTime() - ix.music.fadeTime)/3, maxVolume/100, 1))
        end
    end)

    local playerMeta = FindMetaTable("Player")

    function ix.music.PlayNextSong(noFade)
        local ply = LocalPlayer()
        noFade = noFade or false
        local songTbl

        local area = ply:GetArea()

        local areaSongs = ix.music.GetByArea(area)

        if #areaSongs == 0 then
            local ambientSongs = ix.music.GetByTag("Ambient")
            songTbl = table.Random(ambientSongs)
            ix.music.PlaySong(songTbl.name, false, false or noFade)
        else
            songTbl = table.Random(areaSongs)
            ix.music.PlaySong(songTbl.name, true, false or noFade)
        end
    end

    function ix.music.PlaySong(songName, randomizeStart, noFade)
        local ply = LocalPlayer()
        noFade = noFade or false
        local songPath = ix.music.GetSongPath(songName)
        songPath = "sound/"..songPath
     
        if noFade then
            sound.PlayFile(songPath, "noblock noplay", function(station, errCode, errStr)
                if ( IsValid( station ) ) then
                    if IsValid(ix.music.curChannel) then
                        ix.music.curChannel:Stop()
                    end

                    if IsValid(ix.music.nextChannel) then
                        ix.music.nextChannel:Stop()
                    end

                    ix.music.curSong = ix.music.GetSongTable(songName)

                    local songLength =  station:GetLength()

                    local songPos = 0

                    if randomizeStart then
                       songPos = math.Rand(0, songLength/2)
                       station:SetTime(songPos)
                    end

                    ix.music.curChannel = station
                    station:Play()

                    ix.music.TryingPlaySong = false

                 
                    ix.music.doneTime = CurTime() + station:GetLength() + songPos
                    ix.music.fadeTime = ix.music.doneTime - 3
                else
                    print(errCode, errStr)
                    LocalPlayer():Notify("Error playing music! Check the console for details.")
               
                end
            end)
        else
            sound.PlayFile(songPath, "noblock noplay", function(station, errCode, errStr)
                if ( IsValid( station ) ) then
                    if IsValid(ix.music.curChannel) then
                        ix.music.doneTime = CurTime() + 3
                        ix.music.fadeTime = CurTime()
                    end

                    if IsValid(ix.music.nextChannel) then
                        ix.music.nextChannel:Stop()
                    end

                    ix.music.nextSong = ix.music.GetSongTable(songName)

                    ix.music.nextChannel = station
                    station:Play()
                    station:SetVolume(0)

                    ix.music.TryingPlaySong = false

                    ix.music.nextDoneTime = CurTime() + station:GetLength()
                    ix.music.nextFadeTime = ix.music.nextDoneTime - 3
                else
                    print(errCode, errStr)
                    LocalPlayer():Notify("Error playing music! Check the console for details.")


                end
            end)
        end
    end
end

function ix.music.PlayingAreaSong(area)
    if ix.music.curSong.area == nil then return false end
    local pos = string.find(string.lower(area), ix.music.curSong.area)
    return pos != nil
end

function ix.music.AreaHasSong(area)
    for k, v in ipairs(ix.music.songs) do
        if !v.area then continue end
        if string.find(string.lower(area), v.area) then
            return true
        end
    end
    
    return false
end

hook.Add("SetupAreaProperties", "musicarea", function()
	ix.area.AddType("music")
end)

if CLIENT then

    hook.Add("OnAreaChanged", "nexusmusic", function(oldID, newID)
        if ix.option.Get("enableBGMusic", false) and IsValid(ix.music.curSong) and (ix.music.AreaHasSong(newID) and !ix.music.PlayingAreaSong(newID)) or (ix.music.AreaHasSong(oldID) != ix.music.AreaHasSong(newID)) then
            if (ix.music.overrideUntil and ix.music.overrideUntil <= CurTime()) or !ix.music.overrideUntil then 
                ix.music.PlayNextSong()
            end
        end
    end)

    net.Receive("prMusicOverride", function(len)
        local song = net.ReadString()
        ix.music.PlaySong(song, false, true)
        ix.music.SetOverride(song)
    end)

end

if SERVER then
    util.AddNetworkString("prMusicOverride")
end