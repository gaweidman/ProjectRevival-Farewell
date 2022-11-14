ix.perks = {}
ix.perks.list = {

}

ix.traits = {}
ix.traits.list = {
	{
		["name"] = "Party Animal",
		["description"] = "Medical items now have positive side effects, at the cost of their negative side effects being stronger.",
		["uniqueID"] = "partyanimal"
	},
	{
		["name"] = "Conscientious Objector",
		["description"] = "Guns and Hand to Hand skills have -10 base value, but Engineering, Fabrication, Medical, and Cooking have +10 base value.",
		["uniqueID"] = "conscientiousobjector"
	},
	{
		["name"] = "Undeveloped Palette",
		["description"] = "Low quality food restores more hunger, but high quality food restores less hunger.",
		["uniqueID"] = "undevelopedpalette"
	},
	{
		["name"] = "Volatile",
		["description"] = "Critical success rolls are 95 or higher, but critical success rolls are 5 or lower.",
		["uniqueID"] = "volatile"
	},
	{
		["name"] = "Easily Distracted",
		["description"] = "Intelligence-based skills are lower when people are talking nearby, but higher when they aren't.",
		["uniqueID"] = "easilydistracted"
	},
}

for k, v in ipairs(ix.traits.list) do
    ix.traits.list[k].isTrait = true
    ix.perks.list[v.uniqueID] = table.Copy(v)
end

local CHAR = ix.meta.character

if SERVER then
    function CHAR:AddPerk(perk, showMessage)
        local client = self:GetPlayer()
        if showMessage and client then
            net.Start("ixPerkGained")
                net.WriteString(perk)
            net.Send(client)
        end

        local perks = self:GetData("perks", {})
        perks[#perks + 1] = perk
        self:SetData("perks", perks)
    end

    util.AddNetworkString("ixPerkGained")
    util.AddNetworkString("ixPerkLost")
end

if CLIENT then
    net.Receive("ixPerkGained", function(len, ply)
        local perk = net.ReadString()
        local perkTbl = ix.perks.list[perk]
        Derma_Message("You have gained the "..perkTbl.name.." perk!\n"..perk.description, "Perk Gained", "OK")
    end)
end

