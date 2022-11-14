
AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "Antlion Larvae Hive"
ENT.Category = "HL2 RP"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.bNoPersist = true

if (SERVER) then
	
	function ENT:Initialize()
		self:SetModel( "models/props_hive/nest_med_flat.mdl" )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetUseType( SIMPLE_USE )
	end
	
	function ENT:Use(client, caller)
        local char = client:GetCharacter()
        local inv = char:GetInventory()

        if (!inv:HasItem("grubviale")) then
            client:Notify("You don't have any empty grub vials!")
            return
        end

        client:SetAction("Searching for Grubs	...", 4)
        ix.util.EmitQueuedSounds(client, {
            "weapons/usp/usp_silencer_off.wav",
            "weapons/bugbait/bugbait_squeeze"..math.random(1,3)..".wav",
            "weapons/bugbait/bugbait_squeeze"..math.random(1,3)..".wav"
        }, 0, 0.5)
        
        client:DoStaredAction(self , function() -- On Success

			if (math.random(1, 10) < 5) then
				local vialItem = inv:HasItem("grubviale"):Remove()

				if (!inv:Add("grubvialf")) then -- This is just in case they get an item between these two lines of code. Unlikely, but just in case.
					ix.item.Spawn("grubvialf", client)
				end

				ix.util.EmitQueuedSounds(client, {
					"npc/antlion_grub/agrub_alert"..math.random(1,3)..".wav",
					"weapons/usp/usp_silencer_on.wav"
				})

				client:Notify("You find an antlion grub.")

				entity:Remove()
			else
				client:EmitSound("weapons/usp/usp_silencer_on.wav")
				client:Notify("You don't find an antlion grub.")	
			end
        end, 4, function() -- On Failure
            client:SetAction()
        end)
	end

end