
-- In some cases you'll want to extend the metatables of a few classes. The standard way of doing so is to place your
-- extensions/overrides in the meta/ folder where each file pertains to one class.

local CHAR = ix.meta.character

function CHAR:IsISB()
	return self:GetFaction() == FACTION_ISB
end

function CHAR:GetRankName()
	local faction = self:GetFaction()
	local rank = self:GetRank()
	if faction == FACTION_NAVY and rank > 0 and rank < 4 then
		return self:GetRole()..ix.ranks[faction][rank]
	else
		return ix.ranks[faction][rank]
	end
end