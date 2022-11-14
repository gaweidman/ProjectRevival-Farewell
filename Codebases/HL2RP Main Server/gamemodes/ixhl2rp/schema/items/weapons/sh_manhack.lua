ITEM.name = "Manhack"
ITEM.description = "A folded-up manhack. It's ready to be deployed."
ITEM.model = "models/manhack.mdl"
ITEM.class = "ix_manhack"
ITEM.weaponCategory = "manhack"
ITEM.width = 1
ITEM.height = 1

ITEM:Hook("equipun", function(item)
    -- the item could have been dropped by someone else (i.e someone searching this player), so we find the real owner
	local owner

	for client, character in ix.util.GetCharacters() do
		if (character:GetID() == inventory.owner) then
			owner = client
			break
		end
	end

	if (!IsValid(owner)) then
		return
	end

    local bg = owner:FindBodygroupByName("manhack", 0)

    if (bg != -1) then
        owner:SetBodygroup(bg, 0)
    end
end)

ITEM:Hook("equip", function(item)
    -- the item could have been dropped by someone else (i.e someone searching this player), so we find the real owner
	local owner

	for client, character in ix.util.GetCharacters() do
		if (character:GetID() == inventory.owner) then
			owner = client
			break
		end
	end

	if (!IsValid(owner)) then
		return
	end

    local bg = owner:FindBodygroupByName("manhack", 0)

    if (bg != -1) then
        owner:SetBodygroup(bg, 1)
    end
end)