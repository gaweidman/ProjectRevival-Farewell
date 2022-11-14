
FACTION.name = "Combine Ancillary Commission"
FACTION.description = "A regular human citizen enslaved by the Universal Union."
FACTION.color = Color(235, 137, 52)
FACTION.bgImage = "vgui/project-revival/AnciBG.png"
FACTION.isDefault = false

function FACTION:GetModels(client)
	local models = {}

	PrintTable(client:GetData("classwhitelists", {}))
	print("CLSS whitel", client:HasClassWhitelist(CLASS_VORTSLAVE ))

	if client:HasClassWhitelist(CLASS_VORTSLAVE) then
		models[#models + 1] = "models/projectrevival/vortigaunt_mod.mdl"
	end

	if ix.staffgroups[client:GetUserGroup()] >= ix.staffgroups["vip"] then
		models[#models + 1] = "models/cdpmator.mdl"
	end

	return models
end

function FACTION:GetDefaultName(client, model)
	if model == "models/projectrevival/vortigaunt_mod.mdl" then
		return "CAC.C17-VORTIPODE."..Schema:ZeroNumber(math.random(0, 99999), 5)
	else
		return "CAC.C17-CREMATOR."..Schema:ZeroNumber(math.random(0, 99999), 5)
	end
end

FACTION_CAC = FACTION.index


