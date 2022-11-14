
PLUGIN.name = "Blacklist"
PLUGIN.author = "Dobytchick, Frosty"
PLUGIN.description = "This plugin dds a blacklist. Do not remove those who are in it, because they can harm your servers"

local blacklist =
{
-- ["STEAM_0:0:000000000"] = {reason =     ""},
}
if SERVER then
	function PLUGIN:PlayerAuthed(client, steamid, uniqueid)
		if blacklist[client:SteamID()] then
			client:Kick("You are on the blacklist of the server, Reason:" ..blacklist[client:SteamID()].reason)
			lient:Ban(0, false)
		end
	end
end