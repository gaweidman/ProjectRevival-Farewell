ix.crafting = {}

ix.crafting.recipes = {}
ix.crafting.stations = {
    ix_station_forge = "Forge",
    ix_workbench = "Workbench",
    ix_station_diecaster = "Die Caster"
}
ix.crafting.dictionary = {}

local charMeta = ix.meta.character
local invMeta = ix.meta.inventory

function invMeta:GetItemsByDict(uniqueID, bOnlyMain)
    local items = self:GetItems(bOnlyMain)
    PrintTable(items)
    local matchItems = {}

    for _, itemObj in pairs(items) do
        if itemObj.dictionary == nil then
            continue
        elseif table.HasValue(itemObj.dictionary, uniqueID) then
            matchItems[#matchItems + 1] = itemObj
        end
    end

    return matchItems
end

local bleachItem = ix.item.Register("bleach", nil, false, nil, true)
bleachItem.name = "Bleach"
bleachItem.description = "sdfdsfsdafasdf"
bleachItem.model = "models/error.mdl"

function charMeta:CanCraft(recipe)
    local charInv = self:GetInventory()
    local items = charInv:GetItems(false)
    local char = self

    
    local checkFunctions = {
        -- Component Check
        function()
            local itemReqs = table.Copy(recipe.items)
            for k, reqData in pairs(itemReqs) do
                if reqData.isDict then
                    if #charInv:GetItemsByDict(reqData.uniqueID, false) < reqData.quantity then
                        return false, "You do not have the required components!"
                    end
                else
                    if charInv:GetItemCount(reqData.uniqueID, false) < reqData.quantity then
                        return false, "You do not have the required components!"
                    end
                end
            end

            return true
        end,
        
        -- Tool Check
        function()
            local toolReqs = recipe.tools
            local toolItems = {}

            for k, v in ipairs(toolReqs) do
                local item = charInv:HasItem(v)
                toolItems[v]= {}
                if item then
                    toolItems[v][#toolItems[v] + 1] = item
                else
                    return false, "You do not have the required tools!"
                end
            end
                

            for k, items in ipairs(toolItems) do
                local hasFuel = false
                for _, toolItem in ipairs(items) do
                    if v.limitedUses and v:GetData("UsesLeft", 0) > 0 then
                        hasFuel = true
                    elseif v.limitedUses then 
                        hasFuel = true
                    end
                end

                if !hasFuel then
                    return false, "One of your tools does not have enough fuel!"
                end
            end

            return true
        end,

        -- Skill Check
        function()
            if recipe.skill then
                if char:GetSkill(recipe.skill) >= recipe.skillLvl then
                    return true
                else
                    return false, "Your "..ix.skills.list[recipe.skill].name.." skill is not high enough!"
                end
            else
                return true
            end
        end,

        -- Perk Check
        function()
            if recipe.perk then
                local perks = char:GetPerks()
                if table.HasValue(perks, recipe.perk) then
                    return true
                else
                    return false, "You do not have the required perks!"
                end
            else
                return true
            end
        end,

        -- Blueprint Check
        function()
            if recipe.blueprint then
                local blueprints = char:GetData("craftBlueprints", {})
                if table.HasValue(blueprints, recipeID) then
                    return true
                else
                    return false, "You do not know how to craft this!"
                end
            else
                return true
            end
        end,

        -- Space Check
        function()
            local dummyCharInv = {}
            local dummyBags = {}
            local invW, invH = charInv:GetSize()
            local bagItems = charInv:GetItemsByBase("bags", true)

            local itemReqs = table.Copy(recipe.items)
            local filledItemReqs = {}

            local function setupDummyInv(dummyInv, realInv, dummyW, dummyH)
               
                for y=1, dummyH do
                    dummyInv[y] = {}
                    for x=1, dummyW do
                       
                        local item = realInv:GetItemAt(x, y)

                        if item then
                            for k, reqData in ipairs(itemReqs) do
                                if reqData.uniqueID == item.uniqueID and !table.HasValue(filledItemReqs, item:GetID()) then
                                    reqData.quantity = reqData.quantity - 1
                                    filledItemReqs[#filledItemReqs + 1] = item:GetID()

                                    if reqData.quantity <= 0 then
                                        itemReqs[k] = nil
                                    end

                                    break
                                end
                            end

                            if table.HasValue(filledItemReqs, item:GetID()) then
                                dummyInv[y][x] = false
                            else
                                dummyInv[y][x] = true
                            end
                        else
                            dummyInv[y][x] = false
                        end
                        
                        dummyInv[y][x] = item != nil
                    end
                end

                for y=1, dummyH do
                    for x=1, dummyW do
                    end
                end
            end

            local function findOpenDummySlot(dummyInv, itemW, itemH)
                for y = 1, #dummyInv - itemH + 1 do
                    for x = 1, #dummyInv[1] - itemW + 1 do
                        local fit = true
                        local itemX = 0
                        local itemY = 0
              
                        -- this loop checks to make sure that every tile (from the item's origin tile to the item's end tile) is not filled
                        while fit and itemY <= itemH do
                            if !dummyInv[y + itemY][x + itemX] then
                                fit = false
                            else
                                itemX = itemX + 1
                            end

                            if itemX > itemW then
                                itemX = 0
                                itemY = itemY + 1
                            end

                            if fit then return x, y end
                        end

                    end
                end

                return nil
            end

            setupDummyInv(dummyCharInv, charInv, invW, invH)

            for k, bagInv in ipairs(bagItems) do
                local bagW, bagH = bagInv:GetSize()
                setupDummyInv(bagInv, dummyBags[#dummyBags + 1], bagW, bagH)
            end
            
            local noSpace = false
            for _, productItem in ipairs(recipe.products) do
                local prodItemTbl = ix.item.list[productItem.uniqueID]
                local itemW, itemH = productItem

                for q=1, productItem.quantity do
                    local emptyX, emptyY = findOpenDummySlot(dummyCharInv, prodItemTbl.width, prodItemTbl.height)
            
                    if !emptyX then
                        for index, dummyBag in ipairs(dummyBags) do
                            emptyX, emptyY = findOpenDummySlot(dummyBag, prodItemTbl.width, prodItemTbl.height)

                            if emptyX then
                                -- this loop fills up the dummy slots for an item that fits.
                                for y = 0, prodItemTbl.height do
                                    for x = 0, prodItemTbl.width do
                                        dummyBags[index][emptyY + y][emptyX + x] = true
                                    end
                                end

                                break
                            end
                        end

                
                        noSpace = true
                    else
                        -- this loop fills up the dummy slots for an item that fits.
                        for itemY = 0, prodItemTbl.height do
                            for itemX = 0, prodItemTbl.width do
                                dummyCharInv[emptyY + itemY][emptyX + itemX] = true
                            end
                        end
                    end

                    if noSpace then 
                        return false, "You do not have enough space to craft this!"
                    end
                end
            end

            return true
        end
    }

    local canCraft = true
    for funcIndex, checkFunc in ipairs(checkFunctions) do
        canCraft, errorMessage = checkFunc()
        if !canCraft then 
            return false, errorMessage
        end
    end

    return true 
end

if SERVER then
    util.AddNetworkString("ixCraftItem")
    util.AddNetworkString("ixCraftItemSuccess")

    net.Receive("ixCraftItem", function(len, ply)
        local recipeID = net.ReadString()
        local char = ply:GetCharacter()

        local recipe = ix.crafting.recipes[recipeID]

        -- crafting stuff
        local itemReqs = recipe.items
        local toolReqs = recipe.tools

        local charInv = char:GetInventory()
        local items = charInv:GetItems(false)
        local toolItems = {}

        local canCraft, errorMessage = char:CanCraft(recipe)

        if canCraft then

            local function craftFunction()
                if recipe.PreCraft then
                    recipe:PreCraft(recipe, char)
                end
    
                local toolItems = {}

                for k, reqData in ipairs(itemReqs) do
                    for i=1, reqData.quantity do
                        if reqData.isDict then
                            local dictItems = charInv:GetItemsByDict(reqData.uniqueID, false)
                            dictItems[1]:Remove()
                        else
                            charInv:HasItem(reqData.uniqueID):Remove()
                        end
                    end
                end
    
                for k, v in ipairs(toolReqs) do
                    toolItems[#toolItems + 1] = charInv:HasItem(v)
                end
            
                for k, v in ipairs(toolItems) do
                    if v.limitedUses then
                        v:SetData("UsesLeft", v:GetData("UsesLeft") - 1)
                    end
                end
               
                for k, quantTbl in ipairs(recipe.products) do
                    local itemTbl = ix.item.Get(quantTbl.uniqueID)
                    for i=1, quantTbl.quantity do
                        local x, y, bagInv = charInv:FindEmptySlot(itemTbl.width, itemTbl.height, false)
    
                        if bagInv then
                            bagInv:Add(quantTbl.uniqueID)
                        else
                            charInv:Add(quantTbl.uniqueID)
                        end
                    end
                end
    
                if recipe.PostCraft then
                    recipe:PostCraft(recipe, char)
                end

                if recipe.skill and recipe.skillLvl then
                    local charSkill = char:GetSkill(recipe.skill, 0)
                    local gainedSkill = recipe.skillLvl/math.floor(charSkill)

                    char:LearnSkill(recipe.skill, gainedSkill)
                end
                
            end

            if recipe.craftTime > 0 then
                ply:SetAction("Crafting...", recipe.craftTime, function()
                    if recipe.craftSuccessMsg then
                        ply:Notify(recipe.craftSuccessMsg)
                    else
                        notifyText = "You have successfully crafted "

                        if ix.util.StartsWithVowel(recipe.name) then
                            notifyText = notifyText.."an "
                        else
                            notifyText = notifyText.."a "
                        end

                        notifyText = notifyText..recipe.name.."."

                        ply:Notify(notifyText)
                    end
                    craftFunction()
                end)
            else
                if recipe.craftSuccessMsg then
                    ply:Notify(recipe.craftSuccessMsg)
                else
                    notifyText = "You have successfully crafted "

                    if ix.util.StartsWithVowel(recipe.name) then
                        notifyText = notifyText.."an "
                    else
                        notifyText = notifyText.."a "
                    end

                    notifyText = notifyText..recipe.name.."."

                    ply:Notify(notifyText)
                end
                craftFunction()

                net.Start("ixCraftItemSuccess")
                net.Send(ply)
            end
            
        end

        
        if !canCraft then
            ply:Notify(errorMessage)
            if recipe.craftFailMsg then
                --ply:Notify(recipe.craftFailMsg)
            else
                local notifyText = ""
            
                notifyText = "You cannot craft "

                if ix.util.StartsWithVowel(recipe.name) then
                    notifyText = notifyText.."an "
                else
                    notifyText = notifyText.."a "
                end

                notifyText = notifyText..recipe.name.."."

                
            end
        end


        if recipe.PostCraft then
            recipe.PostCraft()
        end
    end)
    
end

local function ItemQuant(uniqueID, quantity)
    return {
        isDict = false,
        uniqueID = uniqueID,
        quantity = quantity
    }
end

local function DictQuant(uniqueID, quantity)
    return {
        isDict = true,
        uniqueID = uniqueID,
        quantity = quantity
    }
end

---[ Dictionary Definitions ]---

/*
struct DICTIONARY {
    @string name The display name of the dictionary entry.
    @uniqueID The unique ID of the dictionary entry.
}
*/

local DICT = {
    shirt = {
        name = "Shirt"
    },

    shirtCollared = {
        name = "Collared Shirt"
    },

    shirtPrewar = {
        name = "Pre-War Shirt"
    },

    shirtOver = {
        name = "Overshirt"
    },

    shirtCWU = {
        name = "CWU Shirt"
    },

    gloves = {
        name = "Gloves"
    },

    beanie = {
        name = "Beanie"
    },

    pants = {
        name = "Pants"
    },

    pantsJeans = {
        name = "pantsJeans"
    }, 

    coat = {
        name = "Coat"
    },

    coatSweater = {
        name = "Coat and Sweater"
    },

    shirtArmor = {
        name = "Armored Shirt"
    },

    pantsArmor = {
        name = "Armored Pants"
    },

    watercanEmpty = {
        name = "Empty Water Can"
    }
}

for uniqueID, dictData in pairs(DICT) do
    local dictTable = {
        uniqueID = uniqueID,
        name = "Undefined",
    }

    for k, v in pairs(dictData) do
        dictTable[k] = v
    end

    ix.crafting.dictionary[uniqueID] = dictTable
end

---[ Recipe Definitions ]---

/*
struct RECIPE {
    @string name The display name of the recipe.
    @string model The model used by the recipe. Can sub in @RANDMODEL for a randomized citizen model.
    @string description The description of the recipe.
    @string craftSuccessMsg The text displayed when notifying the player about crafting the recipe. Defaults to "You have successfully crafted a/an <recipe name>."
    @string craftFailMsg The text displayed when notifying the player about crafting the recipe. Defaults to "You have failed to craft a/an <recipe name>."
    @number craftTime How long it takes to craft the recipe. Defaults to zero.
    
    @table items A table of ITEMQUANT tables.
    @table tools A table of the uniqueIDs of required tool items.
    @table products A table of ITEMQUANT tables, one for each item given upon successfully crafting the recipe.

    @string skill The required skill for the recipe. If nil, then no skill will be required.
    @number skillLvl The required skill level for the recipe. Defaults to zero.
    @string blueprint Whether or not the recipe requires a blueprint item to be read for the recipe before it can be crafted.
    @string perk The unique ID of the perk required to craft the recipe.
    @string stationEntity The classname of the entity needed to craft the recipe. A nil value here means the recipe can be crafted anywhere. 

    @function CanSee(table recipeTbl, character char)
    @function PreCraft(table recipeTbl, character char)
    @function PostCraft(table recipeTbl, character char)
 }
*/

/*
struct ITEMQUANT
    @string uniqueID The Unique ID of the required item.
    @number quantity The required quantity of the required item. 
*/

local RECIPES = {
    -- Breakdown
        ["breakdownemptybleachbottle"] = {
            name = "Break Down Bleach Bottle",
            model = "models/props_junk/garbage_plasticbottle001a.mdl",
            category = "Breakdown",
            skin = 0,

            craftSuccessMsg = "You have successfully broken down a bleach bottle.",

            items = {ItemQuant("empty_bleach_bottle", 1)},
            products = {ItemQuant("scrap_plastic", 1)},
        },
        ["breakdownreqdevice"] = {
            name = "Dismantle Request Device",
            model = "models/gibs/shield_scanner_gib1.mdl",
            category = "Breakdown",
            skin = 0,

            craftSuccessMsg = "You have successfully dismantled a request device.",

            items = {ItemQuant("request_device", 1)},
            tools = {"screwdriver"},
            products = {ItemQuant("rftransmittersingle", 1), ItemQuant("scrap_electronics", 1)},
        },
        ["breakdowngasanalyser"] = {
            name = "Dismantle Gas Analyzer",
            model = "models/illusion/eftcontainers/gasanalyser.mdl",
            category = "Breakdown",
            skin = 0,

            craftSuccessMsg = "You have successfully dismantled a gas analyzer.",

            items = {ItemQuant("gasanalyser", 1)},
            tools = {"screwdriver"},
            products = {ItemQuant("radio_case", 1), ItemQuant("scrap_electronics", 1)},
        },
        ["breakdownbulletcasings"] = {
            name = "Break Down Bullet Casings",
            model = "models/Items/357ammo.mdl",
            category = "Breakdown",
            skin = 0,
            stationEntity = "ix_workbench",

            craftSuccessMsg = "You have successfully broken down bullet casings.",

            items = {ItemQuant("bullet_casings", 1)},
            products = {ItemQuant("scrap_metal", 1)},

        },
        ["breakdownwatercan"] = {
            name = "Break Down Empty Consulate Water Can",
            description = "Break down a consulate water can into its base components.",
            model = "models/props_lunk/popcan01a.mdl",
            category = "Breakdown",
            skin = "@RANDSKIN",

            craftSuccessMsg = "You have successfully broken down a consulate water can.",
            craftFailMsg = "You failed to break down a consulate water can.",

            items = {DictQuant("watercanEmpty", 1)},
            products = {ItemQuant("scrap_metal", 1)}
        },
        ["breakdownbrokencputower"] = {
            name = "Break Down Broken Computer Tower",
            description = "Break down a broken computer tower can into its base components.",
            model = "models/props_lab/harddrive02.mdl",
            category = "Breakdown",
            skin = 0,

            craftSuccessMsg = "You have successfully broken down a broken computer tower.",

            items = {ItemQuant("brokencputower", 1)},
            products = {ItemQuant("scrap_electronics", 2), ItemQuant("scrap_plastic", 1)}
        },
        ["breakdownbrokencpumonitor"] = {
            name = "Break Down Broken Computer Monitor",
            description = "Break down a broken computer monitor can into its base components.",
            model = "models/props_lab/monitor02.mdl",
            category = "Breakdown",
            skin = 0,

            craftSuccessMsg = "You have successfully broken down a broken computer monitor.",

            items = {ItemQuant("brokencpumonitor", 1)},
            products = {ItemQuant("scrap_electronics", 2), ItemQuant("scrap_plastic", 1)}
        },
        ["breakdownmilkgallon"] = {
            name = "Break Down Milk Gallon",
            description = "Break down a milk gallon  into its base components.",
            model = "models/props_junk/garbage_milkcarton001a.mdl",
            category = "Breakdown",
            skin = 0,

            craftSuccessMsg = "You have successfully broken down an empty milk gallon.",
            craftFailMsg = "You failed to break down a consulate water can.",

            items = {ItemQuant("empty_milk_gallon", 1)},
            products = {ItemQuant("scrap_plastic", 1)}
        },
        ["breakdownemptycan"] = {
            name = "Break Down Empty Can",
            model = "models/props_junk/garbage_metalcan001a.mdl",
            category = "Breakdown",
            skin = 0,

            craftSuccessMsg = "You have successfully broken down an empty can.",

            items = {ItemQuant("emptycan", 1)},
            products = {ItemQuant("scrap_metal", 1)}
        },
        ["breakdownnewspaper"] = {
            name = "Break Down Old Newspaper",
            model = "models/props_junk/garbage_newspaper001a.mdl",
            category = "Breakdown",
            skin = 0,

            craftSuccessMsg = "You have successfully broken down an old newspaper.",

            items = {ItemQuant("old_newspaper", 1)},
            products = {ItemQuant("paper", 1)}
        },
        ["breakdownlockerdoor"] = {
            name = "Break Down Locker Door",
            model = "models/props_lab/lockerdoorleft.mdl",
            category = "Breakdown",
            skin = 0,

            craftSuccessMsg = "You have successfully broken down a locker door.",

            items = {ItemQuant("locker_door", 1)},
            tools = {"pliers"},
            products = {ItemQuant("scrap_metal", 2)}
        },

        ["breakdowncoldpack"] = {
            name = "Break Down Instant Cold Pack",
            model = "models/illusion/eftcontainers/galette.mdl",
            category = "Breakdown",
            skin = 0,

            craftSuccessMsg = "You have successfully broken down an instant cold pack.",

            items = {ItemQuant("coldpack", 1)},
            tools = {"pliers"},
            products = {ItemQuant("ammoniumnitrate", 1)}
        },

        ["breakdowncyclopsuit"] = {
            name = "Break Down Cyclopic Citizen Suit",
            model = "models/industrial_uniforms/pm_industrial_uniform.mdl",
            category = "Breakdown",
            skin = 0,

            craftSuccessMsg = "You have successfully broken down a locker door.",

            items = {ItemQuant("cyclopscivsuit", 1)},
            products = {ItemQuant("scrap_metal", 2)}
        },
        ["breakdowncyclopsuit"] = {
            name = "Break Down Cyclopic Citizen Suit",
            model = "models/industrial_uniforms/pm_industrial_uniform2.mdl",
            skin = 0,
            category = "Breakdown",

            craftSuccessMsg = "You have successfully broken down a Cyclopic Citizen Suit.",

            items = {ItemQuant("greencivsuit", 1)},
            tools = {"knife"},
            products = {ItemQuant("teflon", 2)}
        },
        ["breakdowngreensuit"] = {
            name = "Break Down Green Citizen Suit",
            model = "models/mosi/fallout4/props/junk/components/rubber.mdl",
            skin = 0,
            category = "Breakdown",

            craftSuccessMsg = "You have successfully broken down a Green Citizen Suit.",

            items = {ItemQuant("greencivsuit", 1)},
            tools = {"knife"},
            products = {ItemQuant("teflon", 2)}
        },
        ["breakdowncwusuit"] = {
            name = "Break Down CWU Worker Suit",
            model = "models/hlvr/characters/worker/worker_player.mdl",
            skin = 1,
            category = "Breakdown",

            craftSuccessMsg = "You have successfully broken down a CWU Worker Suit.",

            items = {ItemQuant("workeroutfit", 1)},
            tools = {"knife"},
            products = {ItemQuant("teflon", 2)}
        },
        ["breakdowncwumgrsuit"] = {
            name = "Break Down CWU Leadership Suit",
            model = "models/hlvr/characters/worker/worker_player.mdl",
            skin = 1,
            bodygroups = {
                [0] = 1
            },
            category = "Breakdown",

            craftSuccessMsg = "You have successfully broken down a CWU Worker Suit.",

            items = {ItemQuant("supervisoroutfit", 1)},
            tools = {"knife"},
            products = {ItemQuant("teflon", 2)}
        },
        ["breakdowncwuhazmatsuit"] = {
            name = "Break Down Infestation Control Suit",
            model = "models/hlvr/characters/hazmat_worker/hazmat_worker_player.mdl",
            skin = 0,
            category = "Breakdown",

            craftSuccessMsg = "You have successfully broken down an Infestation Control Suit.",

            items = {ItemQuant("hazmatworkeroutfit", 1)},
            tools = {"knife"},
            products = {ItemQuant("teflon", 2)}
        },
        ["breakdownpants"] = {
            name = "Break Down Pants",
            model = "@RANDMODEL",
            skin = "@RANDSKIN",
            category = "Breakdown",
            bodygroups = "@RANDPANTS",

            craftSuccessMsg = "You have successfully broken down a pair of pants.",

            items = {DictQuant("pants", 1)},
            tools = {"knife"},
            products = {ItemQuant("cloth_scrap", 2)}
        },
        ["breakdownprewarshirt"] = {
            name = "Break Down Pre-War Shirt",
            model = "@RANDMODEL",
            skin = "@RANDSKIN",
            category = "Breakdown",
            bodygroups = "@RANDPREWARSHIRT",

            craftSuccessMsg = "You have successfully broken down a pre-war shirt.",

            items = {DictQuant("shirtPrewar", 1)},
            tools = {"knife"},
            products = {ItemQuant("cloth_scrap", 2)}
        },
        ["breakdownovershirt"] = {
            name = "Break Down Overshirt",
            model = "@RANDMODEL",
            skin = "@RANDSKIN",
            category = "Breakdown",
            bodygroups = "@RANDOVERSHIRT",

            craftSuccessMsg = "You have successfully broken down an overshirt.",

            items = {DictQuant("shirtOver", 1)},
            tools = {"knife"},
            products = {ItemQuant("cloth_scrap", 2)}
        },
        ["breakdowncwushirt"] = {
            name = "Break Down CWU Shirt",
            model = "@RANDMODEL",
            skin = "@RANDSKIN",
            category = "Breakdown",
            bodygroups = "@RANDCWUSHIRT",

            craftSuccessMsg = "You have successfully broken down a CWU shirt.",

            items = {DictQuant("shirtCWU", 1)},
            tools = {"knife"},
            products = {ItemQuant("cloth_scrap", 2)}
        },
        ["breakdownbeanie"] = {
            name = "Break Down Beanie",
            model = "@RANDBEANIE",
            skin = "@RANDSKIN",
            category = "Breakdown",
            bodygroups = "@RANDBEANIE",

            craftSuccessMsg = "You have successfully broken down a beanie.",

            items = {DictQuant("beanie", 1)},
            tools = {"knife"},
            products = {ItemQuant("cloth_scrap", 1)}
        },
        ["breakdowngloves"] = {
            name = "Break Down Gloves",
            model = "@RANDMODEL",
            skin = "@RANDSKIN",
            category = "Breakdown",
            bodygroups = "@RANDGLOVES",

            craftSuccessMsg = "You have successfully broken down a pair of gloves.",

            items = {DictQuant("gloves", 1)},
            tools = {"knife"},
            products = {ItemQuant("cloth_scrap", 1)}
        },
        ["breakdowncoat"] = {
            name = "Break Down Coat",
            model = "@RANDMODEL",
            skin = "@RANDSKIN",
            category = "Breakdown",
            bodygroups = "@RANDCOAT",

            craftSuccessMsg = "You have successfully broken down a coat.",

            items = {DictQuant("coat", 1)},
            tools = {"knife"},
            products = {ItemQuant("cloth_scrap", 2)}
        },
        ["breakdowncoatsweater"] = {
            name = "Break Down Coat and Sweater",
            model = "@RANDMALE",
            skin = "@RANDSKIN",
            category = "Breakdown",
            bodygroups = "@RANDCOATSWEATER",

            craftSuccessMsg = "You have successfully broken down a coat and sweater.",

            items = {DictQuant("coatSweater", 1)},
            tools = {"knife"},
            products = {ItemQuant("cloth_scrap", 3)}
        },


    -- Refining
        ["refinecloth"] = {
            name = "Refine Cloth",
            model = "models/tnb/items/facewrap.mdl",
            category = "Refining",
            skin = 1,
            skill = "fabrication",
            skillLvl = 15,

            craftSuccessMsg = "You have successfully sewn your fabric together.",
            skill = "fabrication",
            skillLvl = 10,

            items = {ItemQuant("cloth_scrap", 2)},
            products = {ItemQuant("sewn_cloth", 1)},
            tools = {"sewing_kit"}
        },

        ["refinemetal"] = {
            name = "Refine Scrap Metal",
            model = "models/mosi/fallout4/props/junk/components/aluminum.mdl",
            category = "Refining",
            skin = 0,

            craftSuccessMsg = "You have successfully refined your scrap metal.",

            items = {ItemQuant("scrap_metal", 2)},
            products = {ItemQuant("refined_metal", 1)},
            stationEntity = "ix_station_forge",
        },

        ["refineelectronics"] = {
            name = "Refine Scrap Electronics",
            model = "models/props_lab/harddrive01.mdl",
            category = "Refining",
            skin = 0,

            craftSuccessMsg = "You have successfully refined your scrap electronics.",

            skill = "engineering",
            skillLvl = 10,

            items = {ItemQuant("scrap_electronics", 2)},
            products = {ItemQuant("refined_electronics", 1)},
        },

        ["burncharcoal"] = {
            name = "Burn Charcoal",
            model = "models/gibs/manhack_gib01.mdl",
            category = "Refining",
            skin = 0,

            craftSuccessMsg = "You have successfully burned your wood into charcoal.",

            items = {ItemQuant("scrap_wood", 2)},
            stationEntity = "ix_station_forge",
            products = {ItemQuant("charcoal", 1)},
        },

        ["convertwires"] = {
            name = "[DEBUG] Convert Wires to Cables",
            model = "models/gibs/manhack_gib01.mdl",
            category = "Refining",
            skin = 0,

            craftSuccessMsg = "You have converted your wires into cables.",

            items = {ItemQuant("wires", 1)},
            products = {ItemQuant("cables", 1)},
        },

    -- Die Casting
        ["castsmgshells"] = {
            name = "Cast 4.6x30 Shells",
            model = "models/Items/BoxMRounds.mdl",
            category = "Die Casting",
            skin = 0,

            craftSuccessMsg = "You have successfully refined your scrap metal.",

            items = {ItemQuant("refined_metal", 2)},
            tools = {"smgroundcast"},
            products = {ItemQuant("emptysmgshells", 1)},
            stationEntity = "ix_station_diecaster"
        },
        ["castmakeshiftgrenadebody"] = {
            name = "Cast Makeshift Grenade Body",
            model = "models/Items/BoxMRounds.mdl",
            category = "Die Casting",
            skin = 0,
            skill = "fabrication",
            skillLvl = 30,

            craftSuccessMsg = "You have successfully refined your scrap metal.",

            items = {DictQuant("watercanEmpty", 1), ItemQuant("refined_metal", 1)},
            products = {ItemQuant("grenadebody", 1)},
            stationEntity = "ix_station_forge"
        },


        -- Clothing
        ["bleachovershirt"] = {
            name = "Bleach Overshirt",
            model = "@RANDMODEL",
            category = "Clothing",
            skin = "@RANDSKIN",
            bodygroups = {
                [1] = 3
            },

            craftSuccessMsg = "You have successfully bleached an overshirt.",

            items = {DictQuant("shirtOver", 1), ItemQuant("bleach", 1)},
            products = {ItemQuant("whiteshirt", 1)}
        },
        ["bleachprewarshirt"] = {
            name = "Bleach Pre-War Shirt",
            model = "@RANDMODEL",
            category = "Clothing",
            skin = "@RANDSKIN",
            bodygroups = {
                [1] = 11
            },

            craftSuccessMsg = "You have successfully bleached a pre-war shirt.",

            items = {ItemQuant("prewarblueshirt", 1), ItemQuant("bleach", 1)},
            products = {ItemQuant("prewarwhiteshirt", 1)}
        },

        ["reinforceshirt"] = {
            name = "Reinforce Shirt",
            model = "@RANDMODEL",
            skin = "@RANDSKIN",
            category = "Clothing",

            craftSuccessMsg = "You have successfully reinforced a citizen shirt.",

            items = {DictQuant("shirt", 1), ItemQuant("armor_scraps", 2)},
            tools = {"sewing_kit"},
            products = {ItemQuant("reinforced_civshirt", 1)} 
        },
        ["xreinforceshirt"] = {
            name = "Extra Reinforce Shirt",
            model = "@RANDMODEL",
            skin = "@RANDSKIN",
            category = "Clothing",

            craftSuccessMsg = "You have successfully reinforced a citizen shirt.",

            items = {ItemQuant("reinforced_civshirt", 1), ItemQuant("scrap_metal", 2), ItemQuant("sewn_cloth", 1)},
            tools = {"sewing_kit"},
            products = {ItemQuant("xreinforced_civshirt", 1)} 
        },
        ["sewgloves"] = {
            name = "Sew Gloves",
            model = "@RANDMODEL",
            skin = "@RANDSKIN",
            category = "Clothing",
            skill = "fabrication",
            bodygroups = {
                [3] = 2
            },
            skillLvl = 30,

            craftSuccessMsg = "You have successfully sewn a pair of gloves.",

            items = {ItemQuant("sewn_cloth", 2)},
            tools = {"sewing_kit"},
            products = {ItemQuant("gloves", 1)} 
        },
        ["sewblackbeanie"] = {
            name = "Sew Black Beanie",
            model = "@RANDMALE",
            skin = "@RANDSKIN",
            category = "Clothing",
            bodygroups = {
                [4] = 1
            },
            skill = "fabrication",
            skillLvl = 25,

            craftSuccessMsg = "You have successfully sewn a black beanie.",
            

            items = {ItemQuant("sewn_cloth", 2)},
            tools = {"sewing_kit"},
            products = {ItemQuant("blackbeanie", 1)}
        },
        ["sewgreenbeanie"] = {
            name = "Sew Green Beanie",
            model = "@RANDMALE",
            skin = "@RANDSKIN",
            category = "Clothing",
            bodygroups = {
                [4] = 2
            },
            skill = "fabrication",
            skillLvl = 25,

            craftSuccessMsg = "You have successfully sewn a green beanie.",
            

            items = {ItemQuant("sewn_cloth", 2)},
            tools = {"sewing_kit"},
            products = {ItemQuant("greenbeanie", 1)}
        },
        ["sewbluebeanie"] = {
            name = "Sew Blue Beanie",
            model = "@RANDFEMBEANIE",
            skin = "@RANDSKIN",
            category = "Clothing",
            bodygroups = {
                [4] = 0
            },
            skill = "fabrication",
            skillLvl = 25,

            craftSuccessMsg = "You have successfully sewn a blue beanie.",
            

            items = {ItemQuant("sewn_cloth", 2)},
            tools = {"sewing_kit"},
            products = {ItemQuant("bluebeanie", 1)}
        },
        ["sewbrownbeanie"] = {
            name = "Sew Brown Beanie",
            model = "@RANDFEMBEANIE",
            skin = "@RANDSKIN",
            category = "Clothing",
            bodygroups = {
                [4] = 1
            },
            skill = "fabrication",
            skillLvl = 25,

            craftSuccessMsg = "You have successfully sewn a brown beanie.",

            items = {ItemQuant("cloth_scrap", 2)},
            tools = {"sewing_kit"},
            products = {ItemQuant("brownbeanie", 1)}
        },
        ["convbeanieblutoblk"] = {
            name = "[BETA ONLY] Convert Blue Beanie to Black",
            model = "@RANDMALE",
            skin = "@RANDSKIN",
            category = "Clothing",
            bodygroups = {
                [4] = 1
            },

            craftSuccessMsg = "You have successfully converted your beanie.",

            items = {ItemQuant("bluebeanie", 1)},
            products = {ItemQuant("blackbeanie", 1)}
        },
        ["convbeanieblktoblu"] = {
            name = "[BETA ONLY] Convert Black Beanie to Blue",
            model = "@RANDFEMBEANIE",
            skin = "@RANDSKIN",
            category = "Clothing",
            bodygroups = {
                [4] = 0
            },

            craftSuccessMsg = "You have successfully converted your beanie.",

            items = {ItemQuant("blackbeanie", 1)},
            products = {ItemQuant("bluebeanie", 1)}
        },
        ["convbeaniebrntogrn"] = {
            name = "[BETA ONLY] Convert Brown Beanie to Green",
            model = "@RANDMALE",
            skin = "@RANDSKIN",
            category = "Clothing",
            bodygroups = {
                [4] = 1
            },

            craftSuccessMsg = "You have successfully converted your beanie.",

            items = {ItemQuant("brownbeanie", 1)},
            products = {ItemQuant("greenbeanie", 1)}
        },
        ["convbeaniegrntobrn"] = {
            name = "[BETA ONLY] Convert Green Beanie to Brown",
            model = "@RANDFEMBEANIE",
            skin = "@RANDSKIN",
            category = "Clothing",
            bodygroups = {
                [4] = 2
            },

            craftSuccessMsg = "You have successfully converted your beanie.",

            items = {ItemQuant("greenbeanie", 1)},
            products = {ItemQuant("brownbeanie", 1)}
        },
        ["makeglovesfingerless"] = {
            name = "Make Gloves Fingerless",
            model = "@RANDMODEL",
            skin = "@RANDSKIN",
            category = "Clothing",
            bodygroups = {
                [3] = 1
            },

            craftSuccessMsg = "You have successfully cut the fingers off of your gloves.",

            items = {ItemQuant("gloves", 1)},
            tools = {"knife"},
            products = {ItemQuant("fingerlessgloves", 1)}
        },
        ["sewmedicshirt"] = {
            name = "Sew Medic Shirt",
            model = "@RANDMODEL",
            skin = "@RANDSKIN",
            category = "Clothing",
            bodygroups = {
                [1] = 9
            },
            skill = "fabrication",
            skillLvl = 15,

            craftSuccessMsg = "You have successfully sewn a medic shirt.",

            items = {ItemQuant("whiteshirt", 1), ItemQuant("sewn_cloth", 1)},
            tools = {"sewing_kit"},
            products = {ItemQuant("medicshirt", 1)}
        },

    -- Technology
        ["shortrangerjammer"] = {
            name = "Craft Short Range Radio Jammer",
            model = "models/props_lab/powerbox02a.mdl",
            category = "Technology",

            craftSuccessMsg = "You have successfully crafted a Short Range Radio Jammer.",

            items = {ItemQuant("rftransmitter", 1), ItemQuant("refined_electronics", 1), ItemQuant("wires", 1)},
            products = {ItemQuant("rjammer_sr", 1)},

            skill = "engineering",
            skillLvl = 40,
        },

        ["longrangerjammer"] = {
            name = "Craft Long Range Radio Jammer",
            model = "models/props_lab/powerbox01a.mdl",
            category = "Technology",

            craftSuccessMsg = "You have successfully crafted a Long Range Radio Jammer.",

            items = {ItemQuant("rjammer_sr", 1),  ItemQuant("refined_electronics", 1), ItemQuant("wires", 1)},
            products = {ItemQuant("rjammer_lr", 1)},

            skill = "engineering",
            skillLvl = 60,
        },

        ["upgraderftransmitter"] = {
            name = "Upgrade RF Transmitter",
            model = "models/illusion/eftcontainers/virtex.mdl",
            category = "Technology",
            skin = 0,
            skill = "engineering",
            skillLvl = 40,

            craftSuccessMsg = "You have successfully upgraded an RF transmitter.",

            items = {ItemQuant("rftransmittersingle", 1), ItemQuant("refined_electronics", 1)},
            products = {ItemQuant("rftransmitter", 1)}
        },

        ["craftmakeshiftflashlight"] = {
            name = "Craft Makeshift Flashlight",
            model = "models/lagmite/lagmite.mdl",
            category = "Technology",

            craftSuccessMsg = "You have successfully crafted a makeshift flashlight.",

            items = {ItemQuant("lightbulb", 1),  ItemQuant("cables", 1), DictQuant("watercanEmpty", 1), ItemQuant("scrap_electronics", 1)},
            products = {ItemQuant("flashlight", 1)},

            skill = "engineering",
            skillLvl = 35,
        },

        ["craftrftransceiver"] = {
            name = "Craft RF Transceiver",
            model = "models/illusion/eftcontainers/virtex.mdl",
            category = "Technology",

            craftSuccessMsg = "You have successfully crafted an RF Transceiver.",

            items = {ItemQuant("rftransmitter", 1),  ItemQuant("rfreceiver", 1), ItemQuant("circuitboard", 1)},
            tools = {"solderingiron"},
            products = {ItemQuant("rftransceiver", 1)},

            skill = "engineering",
            skillLvl = 45,
        },

        ["crafthandheldradio"] = {
            name = "Craft Handheld Radio",
            model = "models/deadbodies/dead_male_civilian_radio.mdl",
            category = "Technology",

            craftSuccessMsg = "You have successfully crafted a handheld radio.",

            items = {ItemQuant("radio_case", 1),  ItemQuant("rftransceiver", 1), ItemQuant("refined_electronics", 1)},
            products = {ItemQuant("hybridradio", 1)},

            skill = "engineering",
            skillLvl = 45,
        },

    -- Medical
        ["craftbandage"] = {
            name = "Craft Bandage",
            model = "models/illusion/eftcontainers/bandage.mdl",
            category = "Medical",

            craftSuccessMsg = "You have successfully crafted a bandage.",
            skill = "fabrication",
            skillLvl = 10,

            items = {ItemQuant("cloth_scrap", 2)},
            products = {ItemQuant("bandage", 1)},
        },

    -- Armor
        ["antlionarmor"] = {
            name = "Craft Antlion Shell Armor",
            model = "models/gibs/antlion_gib_large_2.mdl",
            category = "Armor",
            skin = 0,
            skill = "fabrication",
            skillLvl = 80,

            craftSuccessMsg = "You have successfully crafted antlion shell armor.",

            items = {ItemQuant("antlioncarapace", 6), ItemQuant("screwpack", 1), ItemQuant("paracord", 2)},
            tools = {"electricdrill", "knife"},
            products = {ItemQuant("antlionarmor", 1)}
        },

    -- Weapons
        ["craftxbow"] = {
            name = "Craft Crossbow",
            model = "models/weapons/w_crossbow.mdl",
            category = "Weapons",
            skin = 0,
            skill = "engineering",
            skillLvl = 80,

            craftSuccessMsg = "You have successfully crafted a crossbow.",

            items = {ItemQuant("weaponparts", 1), ItemQuant("wirerope", 1), ItemQuant("wires", 1)},
            products = {ItemQuant("xbow", 1)}
        },

        ["craftflashbang"] = {
            name = "Assemble Flashbang",
            model = "models/weapons/w_eq_flashbang.mdl",
            category = "Weapons",
            skin = 0,
            skill = "fabrication",
            skillLvl = 45,

            craftSuccessMsg = "You have successfully assembled a flashbang.",

            items = {ItemQuant("grenadebody", 1), ItemQuant("weaponparts", 1), ItemQuant("saltpeter", 1), ItemQuant("ammoniumnitrate", 1)},
            products = {ItemQuant("flashbang", 1)}
        },

    -- Furniture
        ["craftwoodenshelf"] = {
            name = "Craft Wooden Shelf",
            model = "models/props/CS_militia/shelves_wood.mdl",
            category = "Furniture",
            skin = 0,
            skill = "fabrication",
            skillLvl = 40,

            craftSuccessMsg = "You have successfully crafted a wooden shelf.",

            items = {ItemQuant("scrap_wood", 5), ItemQuant("nailpack", 1)},
            tools = {"hammer"},
            products = {ItemQuant("woodenshelf", 1)}
        },
        ["craftstreethorse"] = {
            name = "Craft Street Horse",
            model = "models/props_wasteland/barricade002a.mdl",
            category = "Furniture",
            skin = 0,
            skill = "fabrication",
            skillLvl = 30,

            craftSuccessMsg = "You have successfully crafted a wooden shelf.",

            items = {ItemQuant("scrap_wood", 3), ItemQuant("nailpack", 1)},
            tools = {"hammer"},
            products = {ItemQuant("horse", 1)}
        },

    -- Construction
        ["crafthandmadefilter"] = {
            name = "Craft Handmade Filter",
            model = "models/props_junk/garbage_metalcan001a.mdl",
            category = "Construction",
            skin = 0,
            skill = "fabrication",
            skillLvl = 35,

            craftSuccessMsg = "You have successfully crafted a handmade filter.",

            items = {ItemQuant("emptycan", 1), ItemQuant("charcoal", 1), ItemQuant("sewn_cloth", 1)},
            products = {ItemQuant("handmadefilter", 1)}
        },

        ["craftweaponparts"] = {
            name = "Craft Weapon Parts",
            model = "models/props_junk/garbage_metalcan001a.mdl",
            category = "Construction",
            skin = 0,
            skill = "fabrication",
            skillLvl = 30,

            craftSuccessMsg = "You have successfully crafted weapon parts.",

            items = {ItemQuant("scrap_metal", 3)},
            tools = {"pliers", "electricdrill"},
            products = {ItemQuant("weaponparts", 1)}
        },
    }

for uniqueID, recipeData in pairs(RECIPES) do
    local recipeTable = {
        uniqueID = uniqueID,
        name = "Undefined",
        model = "models/error.mdl",
        description = "Undefined",
        notifyName = "Undefined",
        category = "Miscellaneous",
        skin = 0,
        bodygroups = {},
        craftTime = 0,

        items = {},
        tools = {},
        products = {},
        stationEntity = nil,

        skill = nil,
        skillLvl = 0,
        blueprint = nil,
        perk = nil,

        CanSee = function() 
            return true
        end,
        PreCraft = function() end,
        PostCraft = function() end
    }

    for k, v in pairs(recipeData) do
        recipeTable[k] = v
    end

    ix.crafting.recipes[uniqueID] = recipeTable
end

function ix.crafting.GetCategories()
    local categories = {}
    for k, v in pairs(ix.crafting.recipes) do
        if !table.HasValue(categories, v.category) then
            categories[#categories + 1] = v.category
        end
    end

    return categories
end

function ix.crafting.GetCategorizedRecipes()
    local recipes = {}
    for k, v in pairs(ix.crafting.recipes) do
        if recipes[v.category] == nil then
            recipes[v.category] = {[1] = v} 
        else
            recipes[v.category][#recipes[v.category] + 1] = v
        end
    end

    return recipes
end

hook.Add("CreateMenuButtons", "ixCraftingMenu", function(tabs)
	tabs["crafting"] = {
		populate = function(container)
            local leftBar = container:Add("Panel")
            leftBar:Dock(FILL)

            leftBar.Paint = function(panel, w, h)  
                surface.SetDrawColor(65, 65, 65)
                surface.DrawRect(0, 0, w, h)
            end

            container.rightBar = container:Add("DScrollPanel")
            container.rightBar:Dock(RIGHT)
            container.rightBar:SetWide(ScrW()/4)
            container.rightBar.Paint = function(panel, w, h)  
                surface.SetDrawColor(44, 44, 44)
                surface.DrawRect(0, 0, w, h)
            end

            local barPadding = ScreenScale(4)
            container.rightBar:GetCanvas():DockPadding(barPadding, barPadding, barPadding, barPadding)
            leftBar:DockPadding(barPadding, barPadding, barPadding, barPadding)


            function container.rightBar:SetRecipe(recipe)
                self:Clear()
                
                    local canCraft = LocalPlayer():GetCharacter():CanCraft(recipe)
                    local label = self:Add("DLabel")
                    label:Dock(TOP)
                    label:SetText(recipe.name)
                    label:SetFont("prSmallTitleFont")
                    label:SizeToContents()

                    container.model = self:Add("DModelPanel")
                    container.model:SetTall(self:GetWide())
                    local displayModel = recipe.model
                    local dispBgs = recipe.bodygroups
                    if recipe.model == "@RANDMODEL" then
                        if math.random(1, 2) == 1 then
                            local modelNum = math.random(1, 6)
                            if modelNum >= 5 then 
                                modelNum = modelNum + 1
                            end
                            displayModel = "models/player/zelpa/female_0"..modelNum.."_extended.mdl" 
                        else
                            displayModel = "models/player/zelpa/male_0"..math.random(1,9).."_extended.mdl" 
                        end
                    elseif recipe.model == "@RANDFEMBEANIE" then
                        local modelNum = math.random(1, 6)
                        if modelNum >= 5 then 
                            modelNum = modelNum + 1
                        end
                        displayModel = "models/player/zelpa/female_0"..modelNum.."_b_extended.mdl" 
                    elseif recipe.model == "@RANDMALE" then
                        displayModel = "models/player/zelpa/male_0"..math.random(1,9).."_extended.mdl"
                    elseif recipe.model == "@RANDBEANIE" then
                        if math.random(0, 1) == 0 then
                            local modelNum = math.random(1, 6)
                            if modelNum >= 5 then 
                                modelNum = modelNum + 1
                            end
                            displayModel = "models/player/zelpa/female_0"..modelNum.."_b_extended.mdl"
                            dispBgs = {
                                [4] = math.random(0, 1)
                            }
                        else
                            local modelNum = math.random(1, 9)
                            displayModel = "models/player/zelpa/male_0"..modelNum.."_extended.mdl"
                            dispBgs = {
                                [4] = math.random(1, 2)
                            }
                        end

                        
                    end

                    local displaySkin = recipe.skin
                    if recipe.skin == "@RANDSKIN" then
                        if displayModel == "models/props_lunk/popcan01a.mdl" then
                            displaySkin = math.random(0, 2)
                        else
                            displaySkin = math.random(0, NumModelSkins(displayModel))
                        end
                    end

                    if recipe.bodygroups == "@RANDPREWARSHIRT" then
                       dispBgs = {
                            [1] = 10 + math.random(0, 1)
                       }
                    elseif recipe.bodygroups == "@RANDOVERSHIRT" then
                        dispBgs = {
                            [1] = math.random(0, 4)
                       }
                    elseif recipe.bodygroups == "@RANDCWUSHIRT" then
                        dispBgs = {
                            [1] = math.random(12, 14)
                        }
                    elseif recipe.bodygroups == "@RANDPANTS" then
                        local pantsNumber = math.random(0, 4)

                        if pantsNumber > 2 then pantsNumber = pantsNumber + 3 end
                        dispBgs = {
                            [2] = pantsNumber
                        }
                    elseif recipe.bodygroups == "@RANDGLOVES" then
                        dispBgs = {
                            [3] = math.random(1, 2)
                       }
                    elseif recipe.bodygroups == "@RANDCOAT" then
                        dispBgs = {
                            [1] = math.random(15, 17)
                       }
                    elseif recipe.bodygroups == "@RANDCOATSWEATER" then
                        dispBgs = {
                            [1] = math.random(18, 20)
                       }
                    end

                    container.model:SetModel(displayModel, displaySkin)
                    for bodygroup, value in pairs(dispBgs) do
                        container.model:GetEntity():SetBodygroup(bodygroup, value)
                    end
                    container.model:Dock(TOP)
                    container.model:SetCursor("arrow")

                    local modelEntity = container.model:GetEntity()
                    local sequence = modelEntity:LookupSequence("idle_unarmed")

                    if (sequence <= 0) then
                        sequence = modelEntity:SelectWeightedSequence(ACT_IDLE)
                    end

                    if (sequence > 0) then
                        modelEntity:ResetSequence(sequence)
                    else
                        local found = false

                        for _, v in ipairs(modelEntity:GetSequenceList()) do
                            if ((v:lower():find("idle") or v:lower():find("fly")) and v != "idlenoise") then
                                modelEntity:ResetSequence(v)
                                found = true

                                break
                            end
                        end

                        if (!found) then
                            modelEntity:ResetSequence(4)
                        end
                    end
                   

                    local lBound, hBound = container.model:GetEntity():GetRenderBounds()
                    local distance = lBound:Distance(hBound)
                    local ent = container.model:GetEntity()
                    container.model:SetCamPos(ent:GetForward()*distance + ent:GetUp()*distance/1.85)
                    container.model:SetLookAt((hBound+lBound)/2)

                    if recipe.skin != 0 then
                        ent:SetSkin(displaySkin)
                    end

                    local ingredLbl = self:Add("DLabel")
                    ingredLbl:Dock(TOP)
                    ingredLbl:SetText("Ingredients")
                    ingredLbl:SetFont("prCategoryHeadingFont")
                    ingredLbl:SizeToContents()
                    ingredLbl:DockMargin(0, 0, 0, -5)
                    
                    for k, v in ipairs(recipe.items) do
                        if v.isDict then
                            if canCraft then
                                local dictItems = LocalPlayer():GetCharacter():GetInventory():GetItemsByDict(v.uniqueID, false)
                                for i = 1, v.quantity do
                                    local ingredient = self:Add("DLabel")
                                    ingredient:SetText(string.format("1x %s (%s)", ix.crafting.dictionary[v.uniqueID].name, dictItems[i].name))
                                    ingredient:Dock(TOP)
                                    ingredient:SetFont("prMenuButtonFontSmall")
                                    ingredient:SizeToContents()
                                    ingredient:DockMargin(0, 0, 0, -5)
                                end
                            else
                                local ingredient = self:Add("DLabel")
                                ingredient:SetText(v.quantity.."x "..ix.crafting.dictionary[v.uniqueID].name)
                                ingredient:Dock(TOP)
                                ingredient:SetFont("prMenuButtonFontSmall")
                                ingredient:SizeToContents()
                                ingredient:DockMargin(0, 0, 0, -5)
                            end
                        else
                            local item = ix.item.list[v.uniqueID]
                            local ingredient = self:Add("DLabel")
                            ingredient:SetText(v.quantity.."x "..item.name)
                            ingredient:Dock(TOP)
                            ingredient:SetFont("prMenuButtonFontSmall")
                            ingredient:SizeToContents()
                            ingredient:DockMargin(0, 0, 0, -5)
                        end
                        
                    end

                    if #recipe.tools > 0 then
                        local toolsLbl = self:Add("DLabel")
                        toolsLbl:Dock(TOP)
                        toolsLbl:DockMargin(0, 5, 0, -5)
                        toolsLbl:SetText("Tools")
                        toolsLbl:SetFont("prCategoryHeadingFont")
                        toolsLbl:SizeToContents()

                        for k, v in ipairs(recipe.tools) do
                            local tool = self:Add("DLabel")
                            local item = ix.item.list[v]
                            tool:SetText(item.name)
                            tool:Dock(TOP)
                            tool:SetFont("prMenuButtonFontSmall")
                            tool:DockMargin(0, 0, 0, -5)
                            tool:SizeToContents()
                        end
                    end

                    if recipe.skill then
                        local skillName = ix.skills.list[recipe.skill].name
                        
                        local toolsLbl = self:Add("DLabel")
                        toolsLbl:Dock(TOP)
                        toolsLbl:DockMargin(0, 5, 0, -5)
                        toolsLbl:SetText("Skills")
                        toolsLbl:SetFont("prCategoryHeadingFont")
                        toolsLbl:SizeToContents()

                        local skill = self:Add("DLabel")
                        skill:Dock(TOP)
                        skill:DockMargin(0, 0, 0, -5)
                        skill:SetText(recipe.skillLvl.." "..skillName)
                        skill:SetFont("prMenuButtonFontSmall")
                        skill:SizeToContents()
                    end

                    if recipe.stationEntity then
                        local stationName = ix.crafting.stations[recipe.stationEntity]
                        
                        local stationLbl = self:Add("DLabel")
                        stationLbl:Dock(TOP)
                        stationLbl:DockMargin(0, 5, 0, -5)
                        stationLbl:SetText("Station")
                        stationLbl:SetFont("prCategoryHeadingFont")
                        stationLbl:SizeToContents()

                        local station = self:Add("DLabel")
                        station:Dock(TOP)
                        station:DockMargin(0, 0, 0, -5)
                        station:SetText(stationName)
                        station:SetFont("prMenuButtonFontSmall")
                        station:SizeToContents()
                    end

                    local productsLbl = self:Add("DLabel")
                    productsLbl:Dock(TOP)
                    productsLbl:DockMargin(0, 5, 0, -5)
                    productsLbl:SetText("Products")
                    productsLbl:SetFont("prCategoryHeadingFont")
                    productsLbl:SizeToContents()

                    for k, v in ipairs(recipe.products) do
                        local product = self:Add("DLabel")
                        local item = ix.item.list[v.uniqueID]
                        product:SetText(v.quantity.."x "..item.name)
                        product:Dock(TOP)
                        product:SetFont("prMenuButtonFontSmall")
                        product:SizeToContents()
                    end

                    net.Receive("ixCraftItemSuccess", function(len, ply)
                        canCraft = LocalPlayer():GetCharacter():CanCraft(recipe)
                    end)

                    local craftBtn = self:Add("DButton")
                    craftBtn:Dock(TOP)
                    craftBtn:SetTall(50)
                    craftBtn:DockMargin(0, 20, 0, 0)
                    craftBtn:SetText("Craft")
                    craftBtn:SetFont("prNoticeBarFont")
                    craftBtn.DoClick = function(panel)
                        ix.crafting.Craft(recipe.uniqueID)
                    end
                    craftBtn:SetTextColor(color_white)

                    

                    craftBtn.Paint = function(panel, w, h)
                        if canCraft then
                            surface.SetDrawColor(128, 24, 24)
                        else
                            surface.SetDrawColor(38, 36, 36)
                        end

                        surface.DrawRect(0, 0, w, h)
                    end
                
            end

            local catRecipes = table.ClearKeys(ix.crafting.GetCategorizedRecipes(), true)

            local dCategoryList = leftBar:Add("DCategoryList")
            dCategoryList:Dock(FILL)
            dCategoryList.Paint = function()

            end

            catRecipes = ix.util.AlphabetizeByMember(catRecipes, "__key")

            for _, recipes in ipairs(catRecipes) do
                if isstring(recipes) then continue end
                local category = recipes["__key"]
                recipes["__key"] = nil
                local dCategory = dCategoryList:Add(category)
                dCategory:DockMargin(0, 0, 0, 10)
                dCategory:SetHeaderHeight(34)
                local headerHeight = dCategory:GetHeaderHeight()
                dCategory:SetLabel("")
                dCategory.headerName = category
                local arrowMaterial = Material("gui/point.png", "smooth")

                local arrowSize = 13
                dCategory.Paint = function(panel, w, h)

                    surface.SetDrawColor(210, 84, 34)
                    
                    --draw.RoundedBoxEx(4, 0, 0, w, headerHeight, Color(100, 100, 100), true, true, false, false)
                    surface.SetDrawColor(118, 69, 55)
                    --draw.RoundedBox(0, 0, headerHeight, w, h-headerHeight, Color(108, 61, 55))

                    

                    surface.SetDrawColor(245, 91, 9)
                    surface.SetMaterial(arrowMaterial)

                    local expanded = panel:GetExpanded()
                    local rotation
                    if expanded and panel.startTime then
                        draw.RoundedBoxEx( 4, 0, 0, w, headerHeight/2, Color(100, 100, 100), true, true, false, false)
                        draw.RoundedBoxEx( Lerp(math.TimeFraction(panel.startTime, panel.endTime, CurTime()), 4, 0), 0, headerHeight/2, w, headerHeight/2, Color(100, 100, 100), false, false, true, true)
                        rotation = Lerp(math.ease.OutCubic(math.TimeFraction(panel.startTime, panel.endTime, CurTime())), -90, 0)
                    elseif !expanded and panel.startTime then
                        rotation = Lerp(math.ease.OutCubic(math.TimeFraction(panel.startTime, panel.endTime, CurTime())), 0, -90)
                        draw.RoundedBoxEx(4, 0, 0, w, headerHeight/2, Color(100, 100, 100), true, true, false, false)
                        draw.RoundedBoxEx( Lerp(math.TimeFraction(panel.startTime, panel.endTime, CurTime()), 0, 4), 0, headerHeight/2, w, headerHeight/2, Color(100, 100, 100), false, false, true, true)
                    elseif expanded then
                        draw.RoundedBoxEx( 4, 0, 0, w, headerHeight, Color(100, 100, 100), true, true, false, false)
                        rotation = 0
                    elseif !expanded then
                        draw.RoundedBoxEx( 4, 0, 0, w, headerHeight, Color(100, 100, 100), true, true, true, true)
                        rotation = 0
                    end

                    surface.SetDrawColor(184, 53, 24)
                    surface.SetMaterial(arrowMaterial)

                    surface.DrawTexturedRectRotated(w - arrowSize - 5, headerHeight/2,  arrowSize,  arrowSize, rotation)
                    draw.SimpleText(panel.headerName, "prSmallHeadingFont", 4, headerHeight - 1, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)

                end

                dCategory.OnToggle = function(panel, expanded)
                    panel.startTime = CurTime()
                    panel.endTime = panel.startTime + panel:GetAnimTime()
                end

                local sortedRecipes = ix.util.AlphabetizeByMember(recipes, "name")

                local i = 0
                for _, recipe in ipairs(sortedRecipes) do
                    if recipe.CanSee() != false then
                        i = i + 1
                        local recipBtn = dCategory:Add(recipe.name)
                        recipBtn:SetFont("prNoticeFont")
                        recipBtn:SetTextColor(color_white)
                        recipBtn:SetTall(32)
                        recipBtn:SetSelectable(true)
                        if i == 1 then
                            recipBtn.isTop = true
                        end

                        if i == #sortedRecipes then
                            recipBtn.isBottom = true
                        end
                        recipBtn.DoClick = function(panel)
                            container.rightBar:SetRecipe(recipe)
                        end

                        local craftableColor =  Color(104, 53, 48)
                        local uncraftableColor = Color(83, 73, 72)

                        if LocalPlayer():GetCharacter():CanCraft(recipe) then
                            recipBtn.bgColor = craftableColor
                        else
                            recipBtn.bgColor = uncraftableColor
                        end
                        
                        function recipBtn:Paint(w, h)
                            if self.isBottom then
                                draw.RoundedBoxEx(4, 0, 0, w, h, self.bgColor, false, false, true, true)
                            else
                                draw.RoundedBoxEx(4, 0, 0, w, h, self.bgColor, false, false, false, false)
                            end

                            if self:IsSelected() then
                                surface.SetDrawColor(255, 255, 0, 10)
                                surface.DrawRect(0, 0, w, h)
                            end
                            
                            surface.SetDrawColor(42, 38, 38)
                            if !self.isBottom then
                                surface.DrawRect(0, h-1, w, 1)
                            end

                            if !self.isTop then
                                surface.DrawRect(0, 0, w, 1)
                            end
                        end 
                    end
                end
            end

        end,
		icon = "a",
		name = "Crafting"
	}
end)

if CLIENT then
    function ix.crafting.Craft(recipe)
        net.Start("ixCraftItem")
		    net.WriteString(recipe)
	    net.SendToServer()
    end
end