ix.skills = {} or ix.skills

/*
    Helix Skill Struct

    {
        string name
        string shortName
        string description
        function(character) CalculateBase
        function(character) OnSetup 
    }
*/

ix.skills.list = {
    ["guns"] = {
        ["name"] = "Guns",
        ["description"] = "Your knowledge of guns and how to handle them.",
        ["uniqueID"] = "guns",
        ["prettyFormula"] = "15 + AGI + PER/2",
        ["startVal"] = 13,
        ["boosts"] = {
            largeBoost = "Agility",
            smallBoost = "Strength"
        },
        ["CalculateBase"] = function(character)
            local agi = character:GetAttribute("agility", 5)
            local str = character:GetAttribute("strength", 5)

            return 13 + str + math.floor(agi/2)
        end,
    },
    ["sleightofhand"] = {
        ["name"] = "Sleight of Hand",
        ["description"] = "How quickly you can move your hands without dropping anything.",
        ["uniqueID"] = "sleightofhand",
        ["prettyFormula"] = "15 + AGI",
        ["startVal"] = 15,
        ["boosts"] = {
            largeBoost = "Agility"
        },
        ["CalculateBase"] = function(character)
            local agi = character:GetAttribute("agility", 5)

            return 15 + agi
        end,
    },
    ["acrobatics"] = {
        ["name"] = "Acrobatics",
        ["description"] = "How high you can jump.",
        ["uniqueID"] = "acrobatics",
        ["prettyFormula"] = "15 + AGI",
        ["startVal"] = 15,
        ["boosts"] = {
            largeBoost = "Agility"
        },
        ["CalculateBase"] = function(character)
            local agi = character:GetAttribute("agility", 5)

            return 15 + agi
        end,
    },
    ["cooking"] = {
        ["name"] = "Cooking",
        ["description"] = "Your knowledge of food and your ability to prepare it.",
        ["uniqueID"] = "cooking",
        ["prettyFormula"] = "15 + INT + AGI/2",
        ["startVal"] = 13,
        ["boosts"] = {
            largeBoost = "Intelligence",
            smallBoost = "Agility"
        },
        ["CalculateBase"] = function(character)
            local agi = character:GetAttribute("agility", 5)
            local int = character:GetAttribute("intelligence", 5)
            

            return 13 + int + math.floor(agi/2)
        end,

    },  
    ["medical"] = {
        ["name"] = "Medical",
        ["description"] = "How well you can treat injuries and illnesses.",
        ["uniqueID"] = "medical",
        ["startVal"] = 15,
        ["boosts"] = {
            largeBoost = "Intelligence"
        },
        ["CalculateBase"] = function(character)
            local int = character:GetAttribute("intelligence", 5)

            return 15 + int
        end,
    },
    ["handtohand"] = {
        ["name"] = "Hand to Hand",
        ["description"] = "Your ability to fight using your bare hands and melee weapons.",
        ["uniqueID"] = "handtohand",
        ["startVal"] = 13,
        ["boosts"] = {
            largeBoost = "Strength",
            smallBoost = "Agility"
        },
        ["CalculateBase"] = function(character, smallAttr)
            local str = character:GetAttribute("strength", 5)
            local agi = character:GetAttribute("agility", 5)

            return 13 + str + math.floor(agi/2)
        end,
    },
    ["engineering"] = {
        ["name"] = "Engineering",
        ["description"] = "Your ability to work with complicated pieces of technology.",
        ["uniqueID"] = "engineering",
        ["startVal"] = 15,
        ["boosts"] = {
            largeBoost = "Intelligence"
        },
        ["CalculateBase"] = function(character)
            local int = character:GetAttribute("intelligence", 5)

            return 15 + int
        end,
    },
    ["fabrication"] = {
        ["name"] = "Fabrication",
        ["description"] = "Your ability to make low-technology things with your hands.",
        ["uniqueID"] = "fabrication",
        ["startVal"] = 13,
        ["boosts"] = {
            largeBoost = "Intelligence",
            smallBoost = "Strength"
        },
        ["CalculateBase"] = function(character)
            local int = character:GetAttribute("intelligence", 5)
            local str = character:GetAttribute("strength", 5)

            return 13 + int + math.floor(str/2)
        end,
    },
    ["stamina"] = {
        ["name"] = "Stamina",
        ["description"] = "Your ability to do physical activity for extended periods of time.",
        ["uniqueID"] = "fabrication",
        ["startVal"] = 13,
        ["boosts"] = {
            largeBoost = "Constitution",
            smallBoost = "Agility"
        },
        ["CalculateBase"] = function(character)
            local con = character:GetAttribute("constitution", 5)
            local agi = character:GetAttribute("agility", 5)

            return 13 + con + math.floor(agi/2)
        end,
    },
}
ix.skills.listSorted = table.Copy(ix.skills.list)
ix.skills.listSorted = table.ClearKeys(ix.skills.listSorted)
table.sort(ix.skills.listSorted, function(a, b)
    local aByte, bByte = {string.byte(a.name)}, {string.byte(b.name)}
    if #aByte > #bByte then
        for k, v in ipairs(bByte) do
            if aByte[k] == bByte[k] then
                continue
            else
                return aByte[k] < bByte[k]
            end 
        end
    else
        for k, v in ipairs(aByte) do
            if aByte[k] == bByte[k] then
                continue
            else
                return aByte[k] < bByte[k]
            end 
        end
    end
end)

function ix.skills.Load(uniqueID, attribTbl)
    ix.skills.list[uniqueID] = attribTbl
    ix.skills.list[uniqueID].uniqueID = uniqueID
end

function ix.skills.Setup(client)
	local character = client:GetCharacter()

	if (character) then
		for k, v in pairs(ix.attributes.list) do
			if (v.OnSetup) then
				v:OnSetup(character, character:GetSkill(k, 0))
			end
		end
	end
end

function ix.skills.CalculateBase(skill, largeBoost, smallBoost)
    local skillTbl = ix.skills.list[skill]
    local startVal = skillTbl.startVal

    if smallBoost != nil then
        return startVal + largeBoost + math.floor(smallBoost/2)
    else
        return startVal + largeBoost
    end
end

local charMeta = ix.meta.character

-- GetSkills and GetSkillBoosts are not defined here, they are defined by character vars.

-- These two functions have similar names, but don't confuse them.
function charMeta:GetSkill(uniqueID, default, inclBoost)
    local baseSkills = self:GetBaseSkills() 
    local specSkills = self:GetData("specSkills", {})
    local skillTbl = ix.skills.list[uniqueID]

    local skillVal = baseSkills[uniqueID] or skillTbl.CalculateBase(self) --self:GetSkills()[uniqueID] or default

    -- optimization thing. if we have any effects, the base will be different, so recalculate it.
    if inclBoost and self:GetSkillBoost(uniqueID) != 0 then
        skillVal = ix.skills.CalculateBase(uniqueID, skillTbl.boosts.largeBoost, skillTbl.boosts.smallBoost)
    end

    if specSkills[uniqueID] then
        skillVal = skillVal + 15
    end

    local learnedSkills = self:GetData("learnedSkills", {})
    local learnedSkill = learnedSkills[uniqueID] or 0

    skillVal = skillVal + learnedSkill

    return skillVal or 0
end

function charMeta:GetSkills()
    local skills = {}
    for k, v in pairs(ix.skills.list) do
        skills[k] = self:GetSkill(k)
    end

    return skills
end

function charMeta:GetBaseSkills()
    return self:GetData("baseSkills", {})
end

if SERVER then

    concommand.Add("updateskills", function()
        for charID, char in pairs(ix.char.loaded) do
            local baseSkills = {}
            local curSkills = char:GetData("skills", {})
            local specSkills = {}           

            for uniqueID, skillTbl in pairs(ix.skills.list) do
                local curSkillVal = curSkills[uniqueID] or 0
                local baseSkill = skillTbl.CalculateBase(char)

                baseSkills[uniqueID] = baseSkill

                if curSkillVal > baseSkill then
                    specSkills[uniqueID] = true
                end
            end

            char:SetData("baseSkills", baseSkills)
            char:SetData("specSkills", specSkills)
        end
    end)

    concommand.Add("testattribute", function()
        for k, v in ipairs(player.GetAll()) do
            local char = v:GetCharacter()

            print("TEST")
            PrintTable(char:GetData("baseSkills", {}))
            PrintTable(char:GetData("specSkills", {}))
            PrintTable(char:GetData("learnedSkills", {}))
        end

    end)

    --[OBFUSCATED]
    function charMeta:SetSkill(uniqueID, amt)
        local skills = self:GetSkills()
        local client = self:GetPlayer()
        local skillTbl = ix.skills.list[uniqueID]

        skills[uniqueID] = math.floor(amt)

        self:SetSkills(skills)

        if (IsValid(client)) then
            net.Start("ixSkillUpdate")
                net.WriteUInt(self:GetID(), 32)
                net.WriteString(uniqueID)
                net.WriteInt(math.floor(skills[uniqueID]), 32)
            net.Send(client)

            if (skillTbl.Setup) then
                skillTbl.Setup(skills[uniqueID])
            end
        end
    end

    

    function charMeta:LearnSkill(uniqueID, amt)
        local client = self:GetPlayer()
        local learnedSkills = self:GetData("learnedSkills", {})
        local learnedSkill = learnedSkills[uniqueID] or 0
        local skillTbl = ix.skills.list[uniqueID]

        learnedSkill = learnedSkill + amt

        if learnedSkill > 100 then learnedSkill = 100
        elseif learnedSkill < 0 then learnedSkill = 0 end

        learnedSkills[uniqueID] = learnedSkill

        self:SetData("learnedSkills", learnedSkills)

        local skillVal = self:GetSkill(uniqueID)

        if IsValid(client) then
            net.Start("ixSkillUpdate")
                net.WriteUInt(self:GetID(), 32)
                net.WriteString(uniqueID)
                net.WriteInt(skillVal, 32)
            net.Send(client)

            if (skillTbl.Setup) then
                skillTbl.Setup(skillVal)
            end
        end
    end

    
    --[OBFUSCATED]
    function charMeta:SetSkills(skills)
        self:SetData("skills", skills)
    end
    

    function charMeta:AddBoost(uniqueID, amt, name, length)
        local boosts = self:GetSkillBoosts()
        local skillBoosts = boosts[uniqueID]
        skillBoosts[#skillBoosts + 1] = {
            ["amount"] = amt,
            ["name"] = name,
            ["endTime"] = os.time() + length
        }

        boosts[uniqueID] = skillBoosts

        self:SetSkillBoosts(boosts)
    end

else
    net.Receive("ixSkillUpdate", function()
        local id = net.ReadUInt(32)
        local character = ix.char.loaded[id]

        if (character) then
            local key = net.ReadString()
            local value = net.ReadInt(32)

            character:GetSkills()[key] = value
        end
    end)
end

function charMeta:GetSkillBoost(uniqueID)
    local boosts = self:GetSkillBoosts()
    local skillBoosts = boosts[uniqueID]

    local boostAmount = 0

    for index, boostTbl in ipairs(skillBoost) do
        boostAmount = boostAmount + boostTbl.amount
    end

    return boostAmount
end

-- i don't know why this exists
-- but i am very afraid to remove it
function charMeta:GetSingSkillBoost(uniqueID)
    local boosts = self:GetSkillBoosts()
    
   
    return boosts[uniqueID]
end

if CLIENT then
end

if SERVER then
    util.AddNetworkString("ixSkillUpdate")
end