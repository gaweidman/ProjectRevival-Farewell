
AddCSLuaFile("cl_init.lua")
DeriveGamemode("helix")

hook.Add( "PlayerSpray", "DisablePlayerSpray", function( ply )
	return false
end )