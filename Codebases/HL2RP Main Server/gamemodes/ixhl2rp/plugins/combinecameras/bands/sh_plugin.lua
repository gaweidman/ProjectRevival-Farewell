
PLUGIN.name = "Opaski"
PLUGIN.description = "Nowe opaski dla citizenów, które po założeniu wyświetlają pod nickiem stosowny tekst."
PLUGIN.author = "lechu2375"


ix.util.Include("cl_hooks.lua")

function PLUGIN:CharacterLoaded(char)
    char:GetPlayer():SetNW2String("band",nil)

    local bandItem = false

    if char:GetInventory():HasItem("band_blue", {["equip"] = true}) != false then
        bandItem = char:GetInventory():HasItem("band_blue", {["equip"] = true})
    elseif char:GetInventory():HasItem("band_brown", {["equip"] = true}) then
        bandItem = char:GetInventory():HasItem("band_brown", {["equip"] = true})
    elseif char:GetInventory():HasItem("band_gold", {["equip"] = true}) then
        bandItem = char:GetInventory():HasItem("band_gold", {["equip"] = true})
    elseif char:GetInventory():HasItem("band_green", {["equip"] = true}) then
        bandItem = char:GetInventory():HasItem("band_green", {["equip"] = true})
    elseif char:GetInventory():HasItem("band_red", {["equip"] = true}) then
        bandItem = char:GetInventory():HasItem("band_red", {["equip"] = true})
    elseif char:GetInventory():HasItem("band_violet", {["equip"] = true}) then
        bandItem = char:GetInventory():HasItem("band_violet", {["equip"] = true})
    elseif char:GetInventory():HasItem("band_white", {["equip"] = true}) then
        bandItem = char:GetInventory():HasItem("band_white", {["equip"] = true})
    elseif char:GetInventory():HasItem("band_black", {["equip"] = true}) then 
        bandItem = char:GetInventory():HasItem("band_black", {["equip"] = true})
    elseif char:GetInventory():HasItem("band_yellow", {["equip"] = true}) then
        bandItem = char:GetInventory():HasItem("band_yellow", {["equip"] = true})
    end
        
    if (bandItem) then
        char:GetPlayer():SetNW2String("band", bandItem.band)
    end
end