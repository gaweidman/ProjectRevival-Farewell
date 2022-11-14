
PLUGIN.name = "Toggle Duck"
PLUGIN.author = "Pokernut, Frosty"
PLUGIN.description = "Add Toggle Duck/Crouch function."

ix.lang.AddTable("english", {
	toggleduck = "Toggle Duck",
	optToggleDuck = "Toggle Duck",
	optdToggleDuck = "Toggle Duck/Crouch function.",
})
ix.lang.AddTable("korean", {
	toggleduck = "앉기 토클",
	optToggleDuck = "앉기 토클",
	optdToggleDuck = "앉는 키를 계속 누르고 있지 않고 한번만 눌러도 앉은 상태가 유지됩니다.",
})

if (CLIENT) then
	ix.option.Add("toggleDuck", ix.type.bool, true, {
		category = "toggleduck"
	})
end

hook.Add( "PlayerBindPress", "ToggleDuck", function( client, bind, pressed )
	
	if (ix.option.Get("toggleDuck", true) == false) then return end
	
	if ( string.find( bind, "+duck" ) and ( client:Crouching() == false ) ) and !client:InVehicle() then 	  	   
	   client:ConCommand( "+duck" )
	elseif ( string.find( bind, "+duck" ) ) and ( client:Crouching() == true ) and !client:InVehicle() then 	   
	   client:ConCommand( "-duck" )
	end 

end )

hook.Add( "PlayerSpawn", "-duckspawn", function( client )
   client:ConCommand( "-duck" )
end )

hook.Add( "PlayerLeaveVehicle", "-duckwhenLeaveVehicle", function( client, veh )
   client:ConCommand( "-duck" )
end )

hook.Add( "PlayerEnteredVehicle", "-duckwhenEnterVehicle", function( client, veh )
   client:ConCommand( "-duck" )
end )

local function DoStand()
  RunConsoleCommand( "-duck" )
end

cvars.AddChangeCallback( "toggleduck", function( toggleduck, value_old, value_new )
	DoStand()
end )