local PLUGIN = PLUGIN
PLUGIN.name = "Better Armor"
PLUGIN.author = "Subleader, Alex Grist, and Frosty"
PLUGIN.desc = "Compatible with bad air and localized damage, plus it adds damage resistance"

ix.util.Include("cl_plugin.lua")

function PLUGIN:EntityTakeDamage( target, dmginfo )
	if ( target:IsPlayer() ) then
		if ( target:GetNetVar("resistance") == true ) then
			if (dmginfo:IsDamageType(DMG_BULLET)) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_bullet"))
			elseif (dmginfo:IsDamageType(DMG_SLASH)) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_slash"))
			elseif (dmginfo:IsDamageType(DMG_SHOCK)) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_shock"))
			elseif (dmginfo:IsDamageType(DMG_BURN)) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_burn"))
			elseif (dmginfo:IsDamageType(DMG_RADIATION)) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_radiation"))
			elseif (dmginfo:IsDamageType(DMG_ACID)) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_acid"))
			elseif (dmginfo:IsExplosionDamage()) then
				dmginfo:ScaleDamage(target:GetNWFloat("dmg_explosive"))
			end
		end
	end
end

function PLUGIN:PlayerHurt( client, attacker, health, damageTaken )
	if (client:IsPlayer()) then
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		local items = inventory:GetItems()
		
		for k, v in pairs(items) do
			if (v:GetData("equip")) then
				if (v.base == "base_armor") then
					local durability = v:GetData("Durability", 100)
					
					if (durability > 0) then
						v:SetData("Durability", math.max(durability - (damageTaken/2)))
					elseif (durability == 0 or durability < 0) then
						v:RemoveOutfit(client)
						v:SetData("Durability", 0)
					end
				end
				
				if (v.base == "base_weapons") then
					local durability = v:GetData("Durability", 100)
					
					if (durability > 0) then
						v:SetData("Durability", math.max(durability - (damageTaken/6)))
					elseif (durability == 0 or durability < 0) then
						v:Unequip(client)
						v:SetData("Durability", 0)
					end
				end
			end
		end
	end
end

function PLUGIN:KeyPress(client, key)
	if (SERVER) then
		if (key == IN_ATTACK) then
			local weapon = client:GetActiveWeapon()
			
			if (weapon and weapon:Clip1() and weapon:GetNextPrimaryFire() <= CurTime()) then
				if (client:IsPlayer()) then
					local character = client:GetCharacter()
					local inventory = character:GetInventory()
					local items = inventory:GetItems()
					
					for k, v in pairs(items) do
						if (v:GetData("equip")) then
							if (v.base == "base_weapons" and v.class == weapon:GetClass()) then
								local durability = v:GetData("Durability", 100)
								
								if (durability > 0) then
									v:SetData("Durability", math.max(durability - math.random(1, 5)))
								elseif (durability == 0 or durability < 0) then
									v:Unequip(client)
									v:SetData("Durability", 0)
								end
							end
						end
					end
				end
			end
		end
	end
end

ix.command.Add("Gasmask", {
	description = "Wear or unwear your gasmask.",
	adminOnly = false,
	OnRun = function(self, client)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		local items = inventory:GetItems()
		for k, v in pairs(items) do
			if (v.base == "base_armor") and (v.gasmask == true) then
				if client:GetNetVar("gasmask") then
					client:SetNetVar("gasmask", false)
					client:NotifyLocalized("gasmaskRemoved")
				else
					client:SetNetVar("gasmask", true)
					client:NotifyLocalized("gasmaskEquipped")
				end
			end
		end
	end
})
