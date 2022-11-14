local PLUGIN = PLUGIN

PLUGIN.name = "Languages"
PLUGIN.author = "Subleader"
PLUGIN.description = "Allows the player to speak in a different language."

-- Add a flag for your language
ix.flag.Add("W", "Shyriiwook", function(client, bGiven)
end)
ix.flag.Add("D", "Droid", function(client, bGiven)
end)
ix.flag.Add("T", "Tusken", function(client, bGiven)
end)
ix.flag.Add("J", "Jawa", function(client, bGiven)
end)
ix.flag.Add("R", "Rodian", function(client, bGiven)
end)
ix.flag.Add("C", "Chiss", function(client, bGiven)
end)
ix.flag.Add("U", "Unknown", function(client, bGiven)
end)




-- Language function
local function CreateLangCommand (commandName, flagName, format, dropFormat)
	do
		local COMMAND = {}
		COMMAND.arguments = ix.type.text

		function COMMAND:OnRun(client, message)
			if (client:GetCharacter():HasFlags(flagName)) then

				if (client:GetCharacter():GetFaction() != FACTION_DROID and flagName == "D") then
					return "You cannot speak droid because you aren't one!"
				end
				
				ix.chat.Send(client, commandName, message)
				ix.chat.Send(client, commandName.."_drop", message)
			else
				return "You don't know that language!"
			end
		end

		ix.command.Add(commandName, COMMAND)
	end

	do
		local CLASS = {}
		CLASS.color = ix.config.Get("chatColor")
		CLASS.format = "%s "..format.." \"%s\""
		if (commandName == "dr") then
			CLASS.indicator = "Beeping"
		end
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
CreateLangCommand ("dr", "D", "says in Droid", "makes a series of beeping noises.") -- Command, Flag, Format, Format when no flag
CreateLangCommand ("jw", "J", "says in Jawa", "says something in Jawa.") -- Command, Flag, Format
CreateLangCommand ("tu", "T", "says in Tusken", "says something in Tusken.") -- Command, Flag, Format
CreateLangCommand ("uk", "U", "says in an unknown language", "says something in an unknown language.") -- Command, Flag, Format
CreateLangCommand ("wo", "W", "says in Shyriiwook", "says something in Shyriiwook.") -- Command, Flag, Format
CreateLangCommand ("ro", "R", "says in Rodian", "says something in Rodian.") -- Command, Flag, Format
CreateLangCommand ("ch", "C", "says in Chiss", "says something in Chiss.") -- Command, Flag, Format
