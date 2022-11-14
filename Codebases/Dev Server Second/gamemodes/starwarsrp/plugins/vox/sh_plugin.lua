PLUGIN.name = "VOX Announcer"
PLUGIN.author = "Black Tea"
PLUGIN.desc = "HL1 Classic VOX Announcer."

nut.util.Include("cl_vox.lua")

if (CLIENT) then
	surface.CreateFont("nut_VOXText", {
		font = "Courier New",
		size = 22,
		weight = 800
	})
	
	function PLUGIN:BuildHelpOptions(data, tree)
		data:AddHelp("VOX List", function()
			return "https://dl.dropboxusercontent.com/u/77744658/voxtext.txt"
		end, "icon16/comment.png")
	end
else
	resource.AddWorkshop("232356231")
end

function PLUGIN:IsVOXAllowed(client)
	return client:IsAdmin() -- Change this if you need so.
end

local prefixes = {"/vox", "/v", "/announce"} -- Change this if you need so.
local voxname = "VOX"
local textFilter = {
	"bizwarn",
	"bloop",
	"delay",
	"beep",
	"bell",
	"blip",
	"boop",
	"buzz",
	"dadeda",
	"deeoo",
	"doop",
	"flatline",
	"fuzz",
	"_commna",
	"_period",
}

local slen = string.len
local sleft = string.Left
local sright = string.Right
local srep = string.Replace

nut.chat.Register("vox", {
	onChat = function(speaker, text)
		voxBroadcast(text)
		-- filter text
		text = string.gsub( text, "[0-9!=.-]", "" )
	
		for _, word in ipairs( textFilter ) do
			text = srep( text, word .. " ", "" )	
			text = srep( text, word, "" )	
		end

		local index = 1
		while (text[index] == " ") do
			index = index + 1	
		end
		text = sright(text, slen(text)-(index-1))

		index = 0
		while (text[slen(text)-index] == " ") do
			index = index + 1	
		end
		text = sleft(text, slen(text)-(index))

		chat.AddText(Color(133, 133, 133), voxname .. ": ".. string.upper(text) .. "." )
	end,
	prefix = prefixes,
	canHear = function(speaker, listener)
		return true
	end,
	canSay = function(speaker)
		if nut.schema.Call("IsVOXAllowed", speaker) != false then
			return true
		end

		nut.util.Notify("You're not permitted to broadcast VOX.", speaker)
	end,
	font = "nut_VOXText"
})