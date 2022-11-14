local PLUGIN = PLUGIN

PLUGIN.name = "Languages"
PLUGIN.author = "Subleader"
PLUGIN.description = "Allows the player to speak in a different language."

-- Add a flag for your language
ix.flag.Add("F", "French", function(client, bGiven)
end)
ix.flag.Add("A", "Arabic", function(client, bGiven)
end)
ix.flag.Add("G", "German", function(client, bGiven)
end)
ix.flag.Add("S", "Spanish", function(client, bGiven)
end)
ix.flag.Add("I", "Italian", function(client, bGiven)
end)
ix.flag.Add("R", "Russian", function(client, bGiven)
end)
ix.flag.Add("P", "Polish", function(client, bGiven)
end)
ix.flag.Add("X", "Intelligent Race X", function(client, bGiven)
end)
ix.flag.Add("x", "Intelligent Xenian", function(client, bGiven)
end)




-- Language function
local function CreateLangCommand (commandName, flagName, format, dropFormat)
	do
		local COMMAND = {}
		COMMAND.arguments = ix.type.text

		function COMMAND:OnRun(client, message)
			if client:GetCharacter():HasFlags(flagName) then
				ix.chat.Send(client, commandName, message)
				ix.chat.Send(client, commandName.."_drop", message)
			end
		end

		ix.command.Add(commandName, COMMAND)
	end

	do
		local CLASS = {}
		CLASS.color = ix.config.Get("chatColor")
		CLASS.format = "%s "..format.." \"%s\""
		function CLASS:CanHear(speaker, listener)
			local chatRange = ix.config.Get("chatRange", 280)
			return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange) and listener:GetCharacter():HasFlags(flagName)
		end
		ix.chat.Register(commandName, CLASS)
	end

	do
		local CLASS = {}
		CLASS.color = ix.config.Get("chatColor")
		CLASS.format = "%s "..dropFormat

		function CLASS:CanHear(speaker, listener)
			local chatRange = ix.config.Get("chatRange", 280)
			return (speaker:GetPos() - listener:GetPos()):LengthSqr() <= (chatRange * chatRange) and !listener:GetCharacter():HasFlags(flagName)
		end
		ix.chat.Register(commandName.."_drop", CLASS)
	end
end

-- Create your language here
CreateLangCommand ("fr", "F", "says in French", "says something in French") -- Command, Flag, Format, Format when no flag
CreateLangCommand ("ar", "A", "says in Arabic", "says something in Arabic") -- Command, Flag, Format
CreateLangCommand ("ge", "G", "says in German", "says something in German") -- Command, Flag, Format
CreateLangCommand ("sp", "S", "says in Spanish", "says something in Spanish") -- Command, Flag, Format
CreateLangCommand ("ita", "I", "says in Italian", "says something in Italian") -- Command, Flag, Format
CreateLangCommand ("ru", "R", "says in Russian", "says something in Russian") -- Command, Flag, Format
CreateLangCommand ("po", "P", "says in Polish", "says something in Polish") -- Command, Flag, Format
CreateLangCommand ("rx", "X", "says in a series of chittering noises", "says makes chittering noises.")
CreateLangCommand ("xe", "X", "says in a series of screeches", "says something in a series of chitters")