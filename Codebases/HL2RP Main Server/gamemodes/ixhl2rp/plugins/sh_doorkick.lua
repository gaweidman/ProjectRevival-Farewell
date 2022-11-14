PLUGIN.name = "Kick Door"
PLUGIN.author = "Riggs"
PLUGIN.description = "Adds a Kick Door Function."

ix.config.Add("strneeded", 5, "How much Strenght needed to kick open a door.", nil, {
	data = {min = 0, max = 30.0, decimals = 1},
	category = "Doorkick"
})

ix.config.Add("staminaneeded", 60, "How much Stamina needed to kick open a door.", nil, {
	data = {min = 0, max = 100.0, decimals = 1},
	category = "Doorkick"
})

ix.config.Add("staminadrain", 60, "How much stamina will be drained when kicking a door open.", nil, {
	data = {min = 0, max = 100.0, decimals = 1},
	category = "Doorkick"
})

ix.config.Add("doorspeed", 500, "How much stamina will be drained when kicking a door open.", nil, {
	data = {min = 100, max = 1000.0, decimals = 1},
	category = "Doorkick"
})

ix.config.Add("doorchance", 0.4, "The chance of busting the door open.", nil, {
	data = {min = 0.0, max = 1.0, decimals = 1},
	category = "Doorkick"
})

ix.config.Add("combineonly", true, "Wheter or not, if kicking a door is restricted to Combine Only.", nil, {
	category = "Doorkick"
})


ix.command.Add("kickdoor", {
    description = "Kick a door infront of you.",

	OnRun = function(self, client, arguments)
		local entity = client:GetEyeTrace().Entity
		local current = client:GetLocalVar("stm", 0)
	if (client:IsValid()) then
		if (client:HasBiosignal()) then
					if (IsValid(entity) and entity:GetClass() == "prop_door_rotating" and !entity:GetNetVar("disabled")) then
						if (client:GetPos():Distance(entity:GetPos())< 100) then	
							if (client:GetCharacter():GetAttribute("str", 0) > ix.config.Get("strneeded", 10)) then
								if(current > ix.config.Get("stamina needed", 80)) then	
									client:Notify("You are now kicking this door.")
									client:ConsumeStamina(ix.config.Get("staminadrain", 60))
									if client:IsWepRaised() then
										client:ToggleWepRaised()
									end
									if (client:Team() == FACTION_MPF) then
										client:ForceSequence("adoorkick")
										timer.Simple( 0.6, function() entity:Fire("setspeed", ix.config.Get("doorspeed", 500)) end)
										timer.Simple( 1, function() entity:Fire("setspeed", "100") end)
										timer.Simple( 0.7, function() entity:Fire("unlock") end)
										timer.Simple( 0.7, function() entity:Fire("openawayfrom", name) end)
										timer.Simple( 0.7, function() entity:EmitSound("physics/wood/wood_panel_break1.wav") end)
										timer.Simple( 1.2, function() client:ForceSequence("point") end)
										timer.Simple( 1.2, function() client:EmitSound("npc/metropolice/pointer0"..math.random(1,6)..".wav") end)
										timer.Simple( 1.3, function() client:ToggleWepRaised() end)
									elseif (client:Team() == FACTION_OTA) then
										client:ForceSequence("melee_gunhit")
										timer.Simple( 0.6, function() entity:Fire("setspeed", ix.config.Get("doorspeed", 500)) end)
										timer.Simple( 1, function() entity:Fire("setspeed", "100") end)
										timer.Simple( 0.6, function() entity:Fire("unlock") end)
										timer.Simple( 0.6, function() entity:Fire("openawayfrom", name) end)
										timer.Simple( 0.6, function() entity:EmitSound("physics/wood/wood_panel_break1.wav") end)
										timer.Simple( 0.9, function() client:ForceSequence("signal_advance") end)
										timer.Simple( 1, function() client:EmitSound("npc/combine_soldier/vo/movein.wav") end)
										timer.Simple( 1.2, function() client:ToggleWepRaised() end)
									end
								else
									client:Notify("You don't have enough stamina to kick this Door.")
								end
							else
								client:Notify("You are not capable of kicking this Door.")
							end
						else
							client:Notify("You are not close enough to the Door.")
						end
					else
						client:Notify("You are not looking at a Door.")
					end
					if (IsValid(entity) and entity:GetClass() == "func_door" or entity:GetClass() == "func_door_rotating" and !entity:GetNetVar("disabled")) then
						if (client:GetPos():Distance(entity:GetPos())< 100) then
							client:Notify("You cannot open this specific door!")
						end
					end
		else
			if not (ix.config.Get("combineonly", false)) then
				if math.random() < ix.config.Get("doorchance", 1) then
					if (IsValid(entity) and entity:GetClass() == "prop_door_rotating" and !entity:GetNetVar("disabled")) then
						if (client:GetPos():Distance(entity:GetPos())< 100) then	
							if (client:GetCharacter():GetAttribute("str", 0) > ix.config.Get("strneeded", 10)) then
								if(current > ix.config.Get("stamina needed", 80)) then
									if client:IsWepRaised() then
										client:ToggleWepRaised()
									end
									client:Notify("You are now kicking this door.")
									client:ConsumeStamina(ix.config.Get("staminadrain", 60))
									client:ForceSequence("MeleeAttack01")
									timer.Simple( 0.1, function() entity:Fire("setspeed", ix.config.Get("doorspeed", 500)) end)
									timer.Simple( 0.5, function() entity:Fire("setspeed", "100") end)
									timer.Simple( 0.4, function() entity:Fire("unlock") end)
									timer.Simple( 0.4, function() entity:Fire("openawayfrom", name) end)
									timer.Simple( 0.4, function() entity:EmitSound("physics/wood/wood_panel_break1.wav") end)
									timer.Simple( 0.5, function() client:ToggleWepRaised() end)
								end
							else
								client:Notify("You are not capable of kicking this Door.")
							end
						else
							client:Notify("You are not close enough to the Door.")
						end
					else
						client:Notify("You are not looking at a Door.")
					end
				else
					client:Notify("You have failed kicking this door open, try again.")
				end
			else
				client:Notify("Only Civil Protection Units are trained to kick open doors.")
			end
		end
    end
end})