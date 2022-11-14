PLUGIN.name = "Disable Spray"
PLUGIN.author = "Pokernut, Frosty"
PLUGIN.description = "Disables player spray."

ix.config.Add("disableSpray", true, "Whether or not player spray is enabled.", nil, {
	category = "appearance"
})


if ix.config.Get("disableSpray", true) then
	if CLIENT then
		hook.Add( "PlayerBindPress", "disableSpray", function( ply, bind, pressed )
			if ( string.find( bind, "impulse 201" )) then return true end
		end )
	end
end