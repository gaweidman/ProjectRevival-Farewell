local ITEMS = {}

ITEMS.raw_headcrab_meat = {
	["name"] = "Raw Headcrab Meat",
	["model"] = "models/gibs/xenians/sgib_01.mdl",
	["description"] = "A bloodied, yellow-green piece of headcrab meat.",
	["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 7,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "headcrab_bacteria"..diseaseRoll

            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

        

            if conBonus + safetyRoll < 1 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", diseases)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_fastheadcrab_meat = {
	["name"] = "Raw Fast Headcrab Meat",
	["model"] = "models/gibs/xenians/sgib_03.mdl",
	["description"] = "A bloodied, yellow-green piece of fast headcrab meat.",
	["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 5,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "headcrab_bacteria"..diseaseRoll

            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

        

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", diseases)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_poisonheadcrab_meat = {
	["name"] = "Raw Black Headcrab Meat",
	["model"] = "models/gibs/xenians/sgib_03.mdl",
	["description"] = "A bloodied, yellow-green piece of black headcrab meat.",
	["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 7,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local diseases = client:GetCharacter():GetData("diseaseTable", {})

            diseases = client:GetCharacter():GetData("diseaseTable", {})
            diseases[#diseases+1] = "virome_poison"
            client:GetCharacter():SetData("diseaseTable", diseases)
	
			client:TakeDamage(12)
	
			return true
        end
    }
}


ITEMS.raw_bullsquid_meat = {
	["name"] = "Raw Bullsquid Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A bloodied, yellow-green piece of bullsquid meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 12,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "alien_bacteria"..diseaseRoll
            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_houndeye_meat = {
	["name"] = "Raw Houndeye Meat",
	["model"] = "models/gibs/xenians/mgib_02.mdl",
	["description"] = "A bloodied, yellow-green piece of houndeye meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 9,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "alien_bacteria"..diseaseRoll

            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

        

            if conBonus + safetyRoll < 25 then
                disease[#disease+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_houndeye_leg = {
	["name"] = "Raw Houndeye Leg",
	["model"] = "models/gibs/xenians/mgib_07.mdl",
	["description"] = "A bloodied, yellow-green piece of houndeye meat on a bone.",
	["width"] = 2,
    ["height"] = 1,
    ["hunger"] = 7,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "alien_bacteria"..diseaseRoll

            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

        

            if conBonus + safetyRoll < 25 then
                disease[#disease+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_antlion_meat = {
	["name"] = "Raw Antlion Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A bloodied, yellow-green piece of antlion meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 12,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "antlion_bacteria"..diseaseRoll
            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_antlionworker_meat = {
	["name"] = "Raw Antlion Worker Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A bloodied, yellow-green piece of antlion worker meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 11,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local diseases = client:GetCharacter():GetData("diseaseTable", {})

            diseases = client:GetCharacter():GetData("diseaseTable", {})
            diseases[#diseases+1] = "worker_poison"
            client:GetCharacter():SetData("diseaseTable", diseases)
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_antlionguard_meat = {
	["name"] = "Raw Antlion Guard Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A bloodied, yellow-green piece of antlion guard meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 17,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "antlion_bacteria"..diseaseRoll
            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_antlionguardian_meat = {
	["name"] = "Raw Antlion Guardian Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A bloodied, yellow-green piece of antlion guardian meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 17,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "antlion_bacteria"..diseaseRoll
            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_stukabat_meat = {
	["name"] = "Raw Stukabat Meat",
	["model"] = "models/gibs/xenians/sgib_01.mdl",
	["description"] = "A bloodied, yellow-green piece of stukabat meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 5,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "alien_bacteria"..diseaseRoll
            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_archer_meat = {
	["name"] = "Raw Archer Filet",
	["model"] = "models/gibs/xenians/mgib_03.mdl",
	["description"] = "A bloodied, yellow-green piece of archer meat.",
	["width"] = 2,
    ["height"] = 1,
    ["hunger"] = 7,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "alien_bacteria"..diseaseRoll
            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_controller_meat = {
	["name"] = "Raw Flying Alien Meat",
	["model"] = "models/gibs/xenians/sgib_03.mdl",
	["description"] = "A bloodied, yellow-green piece of flying alien meat.",
	["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 9,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "controller_bacteria"..diseaseRoll
            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_chumtoad_meat = {
	["name"] = "Raw Chumtoad Meat",
	["model"] = "models/gibs/xenians/sgib_03.mdl",
	["description"] = "A bloodied, yellow-green piece of chumtoad meat.",
	["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 5,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "alien_bacteria"..diseaseRoll
            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_pitdrone_meat = {
	["name"] = "Raw Spike Alien Meat",
	["model"] = "models/gibs/xenians/mgib_02.mdl",
	["description"] = "A bloodied, yellow-green piece of spike alien meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 7,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "racex_bacteria"..diseaseRoll
            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_strooper_arm = {
	["name"] = "Raw Big Green Alien Arm",
	["model"] = "models/gibs/xenians/mgib_05.mdl",
	["description"] = "A bloodied, yellow-green piece of a big green alien's arm.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 7,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "racex_bacteria"..diseaseRoll
            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_strooper_meat = {
    ["name"] = "Raw Big Green Alien Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A bloodied, yellow-green piece of big green alien meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 9,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "racex_bacteria"..diseaseRoll
            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_panthereye_leg = {
	["name"] = "Raw Panthereye Leg",
	["model"] = "models/gibs/xenians/mgib_07.mdl",
	["description"] = "A bloodied, yellow-green piece of panthereye meat on a bone.",
	["width"] = 2,
    ["height"] = 1,
    ["hunger"] = 11,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "alien_bacteria"..diseaseRoll

            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

        

            if conBonus + safetyRoll < 25 then
                disease[#disease+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

ITEMS.raw_panthereye_meat = {
	["name"] = "Raw Panthereye Meat",
	["model"] = "models/gibs/xenians/mgib_07.mdl",
	["description"] = "A bloodied, yellow-green piece of panthereye meat.",
	["width"] = 2,
    ["height"] = 1,
    ["hunger"] = 13,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "alien_bacteria"..diseaseRoll

            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

        

            if conBonus + safetyRoll < 25 then
                disease[#disease+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
			client:TakeDamage(12)
	
			return true
        end
    }
}

/*

ITEMS.raw_pyrosquid_meat = {
	["name"] = "Raw Pyrosquid Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A bloodied, yellow-green piece of pyrosquid meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 15,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "alien_bacteria"..diseaseRoll
            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
    
			client:TakeDamage(25)
	
			return true
        end
    }
}

ITEMS.raw_cryosquid_meat = {
	["name"] = "Raw Cryosquid Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A bloodied, yellow-green piece of cryosquid meat.",
	["width"] = 2,
    ["height"] = 2,
     ["hunger"] = 15,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local conBonus = client:GetCharacter():GetAttribute("con", 0)
            local safetyRoll = tostring(math.random(0, 100))
            
            local diseaseRoll = math.random(1, 3)

            local diseases = client:GetCharacter():GetData("diseaseTable", {})
            local disease = "alien_bacteria"..diseaseRoll
            
            diseases = client:GetCharacter():GetData("diseaseTable", {})

            if conBonus + safetyRoll < 25 then
                diseases[#diseases+1] = disease
                client:GetCharacter():SetData("diseaseTable", disease)
            end
	
            client:TakeDamage(12)
            
            --local pos = client:GetPos()
            --local posDmg = client:NearestPoint(pos)
			--local iFreeze = math.Clamp((250 -pos:Distance(posDmg)) /250 *iFreeze, 1, iFreeze)
			client:SetFrozen(200)
	
			return true
        end
    }
}

ITEMS.raw_virosquid_meat = {
	["name"] = "Raw Virosquid Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A bloodied, yellow-green piece of virosquid meat.",
	["width"] = 2,
    ["height"] = 2,
     ["hunger"] = 15,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
            
            local diseases = client:GetCharacter():GetData("diseaseTable", {})

            diseases = client:GetCharacter():GetData("diseaseTable", {})
            diseases[#diseases+1] = "virosquid_poison"
            client:GetCharacter():SetData("diseaseTable", diseases)
	
            client:TakeDamage(12)
            
	
			return true
        end
    }
}
*/


for k, v in pairs(ITEMS) do
	local ITEM = ix.item.Register(k, nil, false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model
	ITEM.description = v.description
	ITEM.category = "Raw Alien Meat"
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.chance = v.chance or 0
    ITEM.isTool = v.tool or false
    ITEM.hunger = v.hunger or 0
    ITEM.functions.Eat = function(item)
        v.eatFunc(item)
        item.player:SetHunger(item.player:GetHunger() + item.hunger)
    end

end

local ITEMS = {}

ITEMS.cooked_headcrab_meat = {
	["name"] = "Cooked Headcrab Meat",
	["model"] = "models/gibs/xenians/sgib_01.mdl",
	["description"] = "A brown, juicy piece of headcrab meat.",
	["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 10,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(10)
            client:RestoreStamina(15)

            return true
        end
    }
}

ITEMS.cooked_fastheadcrab_meat = {
	["name"] = "Cooked Fast Headcrab Meat",
	["model"] = "models/gibs/xenians/sgib_03.mdl",
	["description"] = "A brown, juicy piece of fast headcrab meat.",
	["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 8,
    ["eatFunc"] = {
        OnRun = function(itemTable)        
            client = itemTable.player

            client:Heal(8)
            client:RestoreStamina(35)

			return true
        end
    }
}

ITEMS.cooked_poisonheadcrab_meat = {
	["name"] = "Cooked Black Headcrab Meat",
	["model"] = "models/gibs/xenians/sgib_03.mdl",
	["description"] = "A brown, juicy piece of black headcrab meat.",
	["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 10,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

	        diseases = client:GetCharacter():GetData("diseaseTable", {})
            diseases[#diseases+1] = "virome_poison"
            client:GetCharacter():SetData("diseaseTable", diseases)

            for k, v in pairs(player.GetAll()) do
                if v:IsAdmin() or v:IsSuperAdmin() then
                    v:ChatPrint(client:Nick().." has just eaten virosquid meat!")
                end
            end
			return true
        end
    }
}


ITEMS.cooked_bullsquid_meat = {
	["name"] = "Cooked Bullsquid Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A brown, juicy piece of bullsquid meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 15,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(20)
            client:RestoreStamina(20)
    
            return true
        end
    }
}

ITEMS.cooked_houndeye_meat = {
	["name"] = "Cooked Houndeye Meat",
	["model"] = "models/gibs/xenians/mgib_02.mdl",
	["description"] = "A brown, juicy piece of houndeye meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 12,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(15)
            client:RestoreStamina(15)
            return true
        end
    }
}

ITEMS.cooked_houndeye_leg = {
	["name"] = "Cooked Houndeye Leg",
	["model"] = "models/gibs/xenians/mgib_07.mdl",
	["description"] = "A brown, juicy piece of houndeye meat on a bone.",
	["width"] = 2,
    ["height"] = 1,
    ["hunger"] = 10,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(12)
            client:RestoreStamina(20)
    
            return true
        end
    }
}

ITEMS.cooked_antlion_meat = {
	["name"] = "Cooked Antlion Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A brown, juicy piece of antlion meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 15,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(15)
    
            return true
        end
    }
}

ITEMS.cooked_antlionworker_meat = {
	["name"] = "Cooked Antlion Worker Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A brown, juicy piece of antlion worker meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 14,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            diseases = client:GetCharacter():GetData("diseaseTable", {})
            diseases[#diseases+1] = "worker_poison"
            client:GetCharacter():SetData("diseaseTable", diseases)

            for k, v in pairs(player.GetAll()) do
                if v:IsAdmin() or v:IsSuperAdmin() then
                    v:ChatPrint(client:Nick().." has just eaten virosquid meat!")
                end
            end

            return true
        end
    }
}

ITEMS.cooked_antlionguard_meat = {
	["name"] = "Cooked Antlion Guard Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A brown, juicy piece of antlion guard meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 20,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player
            
            client:Heal(25)
            client:RestoreStamina(30)
            return true
        end
    }
}

ITEMS.cooked_antlionguardian_meat = {
	["name"] = "Cooked Antlion Guardian Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A brown, juicy piece of antlion guardian meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 20,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(35)
            client:RestoreStamina(30)
    
            return true
        end
    }

}

ITEMS.cooked_stukabat_meat = {
	["name"] = "Cooked Stukabat Meat",
	["model"] = "models/gibs/xenians/sgib_01.mdl",
	["description"] = "A brown, juicy piece of stukabat meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 8,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(7)
            client:RestoreStamina(10)
    
            return true
        end
    }
}

ITEMS.cooked_archer_meat = {
	["name"] = "Cooked Archer Filet",
	["model"] = "models/gibs/xenians/mgib_03.mdl",
	["description"] = "A brown, juicy piece of archer meat.",
	["width"] = 2,
    ["height"] = 1,
    ["hunger"] = 10,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(10)
            client:RestoreStamina(15)
    
            return true
        end
    }
}

ITEMS.cooked_controller_meat = {
	["name"] = "Cooked Flying Alien Meat",
	["model"] = "models/gibs/xenians/sgib_03.mdl",
	["description"] = "A brown, juicy piece of flying alien meat.",
	["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 12,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(10)
            client:RestoreStamina(20)
    
            return true
        end
    }
}

ITEMS.cooked_chumtoad_meat = {
	["name"] = "Cooked Chumtoad Meat",
	["model"] = "models/gibs/xenians/sgib_03.mdl",
	["description"] = "A brown, juicy piece of chumtoad meat.",
	["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 8,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(5)
            client:RestoreStamina(5)
    
            return true
        end
    }
}

ITEMS.cooked_pitdrone_meat = {
	["name"] = "Cooked Spike Alien Meat",
	["model"] = "models/gibs/xenians/mgib_02.mdl",
	["description"] = "A brown, juicy piece of spike alien meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 10,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(15)
            client:RestoreStamina(15)
    
            return true
        end
    }
}

ITEMS.cooked_strooper_arm = {
	["name"] = "Cooked Big Green Alien Arm",
	["model"] = "models/gibs/xenians/mgib_05.mdl",
	["description"] = "A brown, juicy piece of a big green alien's arm.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 10,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(10)
            client:RestoreStamina(-15)

            return true
        end
    }
}

ITEMS.cooked_strooper_meat = {
    ["name"] = "Cooked Big Green Alien Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A brown, juicy piece of big green alien meat.",
	["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 12,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client:Heal(15)
            client:RestoreStamina(-25)

            return true
        end
    }
}

ITEMS.cooked_panthereye_leg = {
	["name"] = "Cooked Panthereye Leg",
	["model"] = "models/gibs/xenians/mgib_07.mdl",
	["description"] = "A brown, juicy piece of panthereye meat on a bone.",
	["width"] = 2,
    ["height"] = 1,
    ["hunger"] = 14,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(10)
            client:RestoreStamina(15)

            return true
        end
    }
}

ITEMS.cooked_panthereye_meat = {
	["name"] = "Cooked Panthereye Meat",
	["model"] = "models/gibs/xenians/mgib_07.mdl",
	["description"] = "A brown, juicy piece of panthereye meat.",
	["width"] = 2,
    ["height"] = 1,
    ["hunger"] = 16,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            client:Heal(20)
            client:RestoreStamina(20)

            return true
        end
    }
}

/*

ITEMS.cooked_pyrosquid_meat = {
	["name"] = "Cooked Pyrosquid Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A brown, juicy piece of pyrosquid meat.",
	["width"] = 2,
    ["height"] = 2,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player

            client:Ignite()
	
			return true
        end
    }
}

ITEMS.cooked_cryosquid_meat = {
	["name"] = "Cooked Cryosquid Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A brown, juicy piece of cryosquid meat.",
	["width"] = 2,
    ["height"] = 2,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            local client = itemTable.player
        
			client:SetFrozen(50)
	
			return true
        end
    }
}

ITEMS.cooked_virosquid_meat = {
	["name"] = "Cooked Virosquid Meat",
	["model"] = "models/gibs/xenians/mgib_01.mdl",
	["description"] = "A brown, juicy piece of virosquid meat.",
	["width"] = 2,
    ["height"] = 2,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            diseases = client:GetCharacter():GetData("diseaseTable", {})
            diseases[#diseases+1] = "virosquid_poison"
            client:GetCharacter():SetData("diseaseTable", diseases)
    
            for k, v in pairs(player.GetAll()) do
                if v:IsAdmin() or v:IsSuperAdmin() then
                    v:ChatPrint(client:Nick().." has just eaten virosquid meat!")
                end
            end

            return true
        end
    }
}
*/


for k, v in pairs(ITEMS) do
	local ITEM = ix.item.Register(k, nil, false, nil, true)
	ITEM.name = v.name
	ITEM.model = v.model
    ITEM.material = "models/cs_italy/plaster"
	ITEM.description = v.description
	ITEM.category = "Cooked Alien Meat"
	ITEM.width = v.width or 1
	ITEM.height = v.height or 1
	ITEM.chance = v.chance or 0
    ITEM.isTool = v.tool or false
    ITEM.hunger = v.hunger or 0
    ITEM.functions.Eat = {
        icon = "icon16/cup.png",
        name = "Eat",
        OnRun = function(item)
            local ply = item.player
            local hungerRestore = item.hunger
            if ply:GetCharacter():HasPerk("undevelopedpalette") then
                hungerRestore = hungerRestore - 3
            end

            ply:SetHunger(ply:GetHunger() + hungerRestore)
        end 
    }

end

local ITEMS = {}

ITEMS.burnt_headcrab_meat = {
    ["name"] = "Burnt Headcrab Meat",
    ["model"] = "models/gibs/xenians/sgib_01.mdl",
    ["description"] = "A charred, black piece of headcrab meat.",
    ["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 7,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

ITEMS.burnt_fastheadcrab_meat = {
    ["name"] = "Burnt Fast Headcrab Meat",
    ["model"] = "models/gibs/xenians/sgib_03.mdl",
    ["description"] = "A charred, black piece of fast headcrab meat.",
    ["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 5,
    ["eatFunc"] = {
        OnRun = function(itemTable)        
            return true
        end
    }
}

ITEMS.burnt_poisonheadcrab_meat = {
    ["name"] = "Burnt Black Headcrab Meat",
    ["model"] = "models/gibs/xenians/sgib_03.mdl",
    ["description"] = "A charred, black piece of black headcrab meat.",
    ["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 7,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            diseases = client:GetCharacter():GetData("diseaseTable", {})
            diseases[#diseases+1] = "virome_poison"
            client:GetCharacter():SetData("diseaseTable", diseases)

            for k, v in pairs(player.GetAll()) do
                if v:IsAdmin() or v:IsSuperAdmin() then
                    v:ChatPrint(client:Nick().." has just eaten virosquid meat!")
                end
            end
            return true
        end
    }
}


ITEMS.burnt_bullsquid_meat = {
    ["name"] = "Burnt Bullsquid Meat",
    ["model"] = "models/gibs/xenians/mgib_01.mdl",
    ["description"] = "A charred, black piece of bullsquid meat.",
    ["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 12,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

ITEMS.burnt_houndeye_meat = {
    ["name"] = "Burnt Houndeye Meat",
    ["model"] = "models/gibs/xenians/mgib_02.mdl",
    ["description"] = "A charred, black piece of houndeye meat.",
    ["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 9,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

ITEMS.burnt_houndeye_leg = {
    ["name"] = "Burnt Houndeye Leg",
    ["model"] = "models/gibs/xenians/mgib_07.mdl",
    ["description"] = "A charred, black piece of houndeye meat on a bone.",
    ["width"] = 2,
    ["height"] = 1,
    ["hunger"] = 7,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

ITEMS.burnt_antlion_meat = {
    ["name"] = "Burnt Antlion Meat",
    ["model"] = "models/gibs/xenians/mgib_01.mdl",
    ["description"] = "A charred, black piece of antlion meat.",
    ["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 12,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

ITEMS.burnt_antlionworker_meat = {
    ["name"] = "Burnt Antlion Worker Meat",
    ["model"] = "models/gibs/xenians/mgib_01.mdl",
    ["description"] = "A charred, black piece of antlion worker meat.",
    ["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 11,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client = itemTable.player

            diseases = client:GetCharacter():GetData("diseaseTable", {})
            diseases[#diseases+1] = "worker_poison"
            client:GetCharacter():SetData("diseaseTable", diseases)

            for k, v in pairs(player.GetAll()) do
                if v:IsAdmin() or v:IsSuperAdmin() then
                    v:ChatPrint(client:Nick().." has just eaten virosquid meat!")
                end
            end

            return true
        end
    }
}

ITEMS.burnt_antlionguard_meat = {
    ["name"] = "Burnt Antlion Guard Meat",
    ["model"] = "models/gibs/xenians/mgib_01.mdl",
    ["description"] = "A charred, black piece of antlion guard meat.",
    ["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 17,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

ITEMS.burnt_antlionguardian_meat = {
    ["name"] = "Burnt Antlion Guardian Meat",
    ["model"] = "models/gibs/xenians/mgib_01.mdl",
    ["description"] = "A charred, black piece of antlion guardian meat.",
    ["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 17,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }

}

ITEMS.burnt_stukabat_meat = {
    ["name"] = "Burnt Stukabat Meat",
    ["model"] = "models/gibs/xenians/sgib_01.mdl",
    ["description"] = "A charred, black piece of stukabat meat.",
    ["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 5,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

ITEMS.burnt_archer_meat = {
    ["name"] = "Burnt Archer Meat",
    ["model"] = "models/gibs/xenians/mgib_03.mdl",
    ["description"] = "A charred, black piece of archer meat.",
    ["width"] = 2,
    ["height"] = 1,
    ["hunger"] = 7,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

ITEMS.burnt_controller_meat = {
    ["name"] = "Burnt Flying Alien Meat",
    ["model"] = "models/gibs/xenians/sgib_03.mdl",
    ["description"] = "A charred, black piece of flying alien meat.",
    ["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 9,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

ITEMS.burnt_chumtoad_meat = {
    ["name"] = "Burnt Chumtoad Meat",
    ["model"] = "models/gibs/xenians/sgib_03.mdl",
    ["description"] = "A charred, black piece of chumtoad meat.",
    ["width"] = 1,
    ["height"] = 1,
    ["hunger"] = 5,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            client:Notify("You are overcome with an overwhelming sense of guilt.")
            return true
        end
    }
}

ITEMS.burnt_pitdrone_meat = {
    ["name"] = "Burnt Spike Alien Meat",
    ["model"] = "models/gibs/xenians/mgib_02.mdl",
    ["description"] = "A charred, black piece of spike alien meat.",
    ["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 7,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

ITEMS.burnt_strooper_arm = {
    ["name"] = "Burnt Big Green Alien Arm",
    ["model"] = "models/gibs/xenians/mgib_05.mdl",
    ["description"] = "A charred, black piece of a big green alien's arm.",
    ["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 7,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

ITEMS.burnt_strooper_meat = {
    ["name"] = "Burnt Big Green Alien Meat",
    ["model"] = "models/gibs/xenians/mgib_01.mdl",
    ["description"] = "A charred, black piece of big green alien meat.",
    ["width"] = 2,
    ["height"] = 2,
    ["hunger"] = 9,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

ITEMS.burnt_panthereye_leg = {
    ["name"] = "Burnt Panthereye Leg",
    ["model"] = "models/gibs/xenians/mgib_07.mdl",
    ["description"] = "A charred, black piece of panthereye meat on a bone.",
    ["width"] = 2,
    ["height"] = 1,
    ["hunger"] = 11,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

ITEMS.burnt_panthereye_meat = {
    ["name"] = "Burnt Panthereye Meat",
    ["model"] = "models/gibs/xenians/mgib_07.mdl",
    ["description"] = "A charred, black piece of panthereye meat.",
    ["width"] = 2,
    ["height"] = 1,
    ["hunger"] = 13,
    ["eatFunc"] = {
        OnRun = function(itemTable)
            return true
        end
    }
}

for k, v in pairs(ITEMS) do
    local ITEM = ix.item.Register(k, nil, false, nil, true)
    ITEM.name = v.name
    ITEM.model = v.model
    ITEM.material = "models/vj_props/fireplace/fireplace_wood"
    ITEM.description = v.description
    ITEM.category = "Burnt Alien Meat"
    ITEM.width = v.width or 1
    ITEM.height = v.height or 1
    ITEM.chance = v.chance or 0
    ITEM.isTool = v.tool or false
    ITEM.hunger = v.hunger or 0
    ITEM.functions.Eat = {
        icon = "icon16/cup.png",
        name = "Eat",
        OnRun = function(item)
            local ply = item.player
            local hungerRestore = item.hunger
            if ply:GetCharacter():HasPerk("undevelopedpalette") then
                hungerRestore = hungerRestore + 3
            end

            ply:SetHunger(ply:GetHunger() + hungerRestore)
        end 
    }
end