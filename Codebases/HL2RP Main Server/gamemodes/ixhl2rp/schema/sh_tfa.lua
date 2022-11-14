-- These are TFA integrations for Helix, this isn't all of TFA, not remotely.
ix.tfa = {}
ix.tfa.ammoTypes = {
	-- USP Match Ammo
	["45_acp"] = { -- We're going to use this as the AP variant of 9mm ammo.
		Name = ".45 ACP",
		ShortName = "45ACP",
		WeaponTable = {},
		CanAttach = function(wep)
            return true
			--return wep:GetClass() == "tfa_projecthl2_usp" and wep:GetOwner():GetAmmoCount("45_acp") > 0
		end,
        CustomBulletCallback = function(wep, attacker, trace, dmginfo)
            local baseDmg = dmginfo:GetDamage()
            local dmgType = dmginfo:GetDamageType()
            local inflictor = dmginfo:GetInflictor()
            local attacker = dmginfo:GetAttacker()
            local weaponClass = wep:GetClass()
            local target = trace.Entity
            local isPulse = weaponClass == "tfa_projecthl2_ar2" or weaponClass == "tfa_projrev_hl2_ar1" or weaponClass == "tfa_projrev_hl2_ismg"

            local dmgFactor = self.dmgFactor or 1
            local dmgOffset = self.dmgOffset or 0
            local dtFactor = self.dtFactor or 1
            local dtOffset = self.dtOffset or 0

            if !string.find(weaponClass, "hl2") then return end
            if dmginfo:IsDamageType(DMG_DIRECT) then return end

            if !IsValid(target) then return end
            if !target:IsNPC() and !target:IsPlayer() then return end

            local targetDT = ent:GetDT()

            local newDmg, armorAbsorbed = ix.util.CalcDamageEx(target, baseDmg*dmgFactor + dmgOffset, dmgType, isPulse, targetDT*dtFactor + dtOffset)

            dmginfo:SetDamage(newDmg)
        end 
	}, 

	["9mm_hp"] = {
		Name = ".9mm Hollow Point",
		ShortName = "9MMHP",
		WeaponTable = {
			Primary = {
				Damage = function( wep, stat ) return stat * 1.75 end,
				ArmorMod = function( wep, stat ) return stat*3 end
			}
		},
		CanAttach = function(wep)
			return wep:GetClass() == "tfa_projecthl2_usp"
		end
	},

	["9mm_ap"] = {
		Name = ".9mm Hollow Point",
		ShortName = "9MMHP",
		WeaponTable = {
			Primary = {
				Damage = function( wep, stat ) return stat * 1.75 end,
				ArmorMod = function( wep, stat ) return stat*3 end
			}
		},
		CanAttach = function(wep)
			return wep:GetClass() == "tfa_projecthl2_usp" and wep:GetOwner():GetAmmoCount("9mm_ap") > 0
		end
	},

	-- MP7 Ammo
	["mp7_hp"] = {
		Name = "4.5x30 Hollow Point",
		ShortName = "MP7HP",
		WeaponTable = {
			Primary = {
				Damage = function( wep, stat ) return stat * 1.75 end,
				ArmorMod = function( wep, stat ) return stat*3 end
			}
		},
		CanAttach = function(wep)
			return wep:GetClass() == "tfa_projecthl2_smg" and wep:GetOwner():GetAmmoCount("mp7_hp") > 0
		end
	},

	-- SPAS-12 Ammo
	["12g_birdshot"] = {
		Name = "12 Gauge Birdshot",
		ShortName = "12GBR",
		WeaponTable = {
			Primary = {
				Damage = function( wep, stat ) return stat * 0.5 end,
				Spread = function( wep, stat ) return stat * 1.25 end,
				NumShots = function( wep, stat ) return stat * 1.25 end,
			}
		},
		CanAttach = function(wep)
			return wep:GetClass() == "tfa_projecthl2_spas12" and wep:GetOwner():GetAmmoCount("12g_birdshot") > 0
		end
	},
	
	-- .357 ammo
	["357_38"] = {
		Name = ".38 Special",
		ShortName = "38SP",
		WeaponTable = {
			Primary = {
				Damage = function( wep, stat ) return stat * 0.66 end,
			}
		},
		CanAttach = function(wep)
			return wep:GetClass() == "tfa_projecthl2_357" and wep:GetOwner():GetAmmoCount("357_38") > 0
		end
	},

	-- MP5K ammo
	["mp5k_hp"] = {
		Name = "9x19 Parabellum HP",
		ShortName = "919HP",
		WeaponTable = {
			Primary = {
				Damage = function( wep, stat ) return stat * 1.75 end,
				ArmorMod = function( wep, stat ) return stat*3 end
			}
		},
		CanAttach = function(wep)
			return wep:GetClass() == "tfa_projrev_mp5k" and wep:GetOwner():GetAmmoCount("mp5k_hp") > 0
		end
	},

	["mp5k_ap"] = {
		Name = "9x19 Parabellum AP",
		ShortName = "919AP",
		WeaponTable = {
			Primary = {
				Damage = function( wep, stat ) return stat * 0.9 end,
				ArmorMod = function( wep, stat ) return stat - 8 end
			}
		},
		CanAttach = function(wep)
			return wep:GetClass() == "tfa_projrev_hl2_mp5k" and wep:GetOwner():GetAmmoCount("mp5k_ap") > 0
		end
	},

	-- Pulse Ammo
	["ar2_hp"] = {
		Name = "Shifted",
		ShortName = "PULHP",
		WeaponTable = {
			Primary = {
				Damage = function( wep, stat ) return stat * 0.9 end,
				ArmorMod = function( wep, stat ) return stat - 8 end
			}
		},
		CanAttach = function(wep)
			local validWeapons = {"tfa_projecthl2_ar2", "tfa_projrev_hl2_ar1", "tfa_projrev_hl2_ismg"}
			return table.HasValue(validWeapons, wep:GetClass()) and wep:GetOwner():GetAmmoCount("ar2_hp") > 0
		end
	},
	["ar2_ap"] = {
		Name = "",
		ShortName = "PULAP",
		WeaponTable = {
			Primary = {
				Damage = function( wep, stat ) return stat * 0.9 end,
				ArmorMod = function( wep, stat ) return stat - 8 end
			}
		},
		CanAttach = function(wep)
			local validWeapons = {"tfa_projecthl2_ar2", "tfa_projrev_hl2_ar1", "tfa_projrev_hl2_ismg"}
			return table.HasValue(validWeapons, wep:GetClass()) and wep:GetOwner():GetAmmoCount("ar2_ap") > 0
		end
	},
	["pulseflare"] = {
		Name = "Pulse Flares",
		ShortName ="PULIN",
		WeaponTable = {
			Primary = {
				Damage = function(wep, stat) return stat * 0.9 end,
				ArmorMod = function(wep, stat) return stat end
			}
		},
		CanAttach = function(wep)
			local validWeapons = {"tfa_projecthl2_ar2", "tfa_projrev_hl2_ar1"}
			return table.HasValue(validWeapons, wep:GetClass()) and wep:GetOwner():GetAmmoCount("ar2_inc") > 0
		end
	}
}

hook.Add("TFA_Attachment_Attached", "HL2TFAAmmoSwitch", function(wep, attachmentID, attachmentTbl, category, attachmentIndex, isForced)
    if category == "ammo" and string.find(wep.Base, "hl2") then
        local ammoType = attachmentID

        wep:SetVar("ActiveAmmoType", ammoType)
    end
end)

for uniqueID, ATTACHMENT in pairs(ix.tfa.ammoTypes) do
	TFA.Attachments.Register(uniqueID, ATTACHMENT)
	game.AddAmmoType({
		name = uniqueID,
		tracer = TRACER_LINE_AND_WHIZ
	})
end