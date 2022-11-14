ix.skills = ix.skills or {}
ix.skills.list = ix.skills.list or {}

function ix.skills.Load(skills)
    for k, v in ipairs(skills) do
        local uniqueID = k

        local skill = ix.skills.list[uniqueID] or {}
        skill.name = skill.name or "Unknown"
        skill.description = skill.description or "No description availalble."

        ix.skills.list[uniqueID] = skill
        skill = nil
    end
end

function ix.skills.Setup(client)
	local character = client:GetCharacter()

	if (character) then
		for k, v in pairs(ix.skills.list) do
			if (v.OnSetup) then
				v:OnSetup(client, character:GetSkill(k, 0))
			end
		end
	end
end

do
	--- Character skill methods
	-- @classmod Character
	local charMeta = ix.meta.character

	if (SERVER) then
		util.AddNetworkString("ixSkillUpdate")

		--- Increments one of this character's skills by the given amount.
		-- @realm server
		-- @string key Name of the skill to update
		-- @number value Amount to add to the skill
		function charMeta:UpdateAttrib(key, value)
			local skill = ix.skills.list[key]
			local client = self:GetPlayer()

			if (skill) then
				local attrib = self:GetSkills()

				attrib[key] = math.min((attrib[key] or 0) + value, skill.maxValue or ix.config.Get("maxskills", 100))

				if (IsValid(client)) then
					net.Start("ixSkillUpdate")
						net.WriteUInt(self:GetID(), 32)
						net.WriteString(key)
						net.WriteFloat(attrib[key])
					net.Send(client)

					if (skill.Setup) then
						skill.Setup(attrib[key])
					end
				end

				self:SetSkills(attrib)
			end

			hook.Run("CharacterSkillUpdated", client, self, key, value)
		end

		--- Sets the value of an skill for this character.
		-- @realm server
		-- @string key Name of the skill to update
		-- @number value New value for the skill
		function charMeta:SetAttrib(key, value)
			local skill = ix.skills.list[key]
			local client = self:GetPlayer()

			if (skill) then
				local attrib = self:GetSkills()

				attrib[key] = value

				if (IsValid(client)) then
					net.Start("ixSkillUpdate")
						net.WriteUInt(self:GetID(), 32)
						net.WriteString(key)
						net.WriteFloat(attrib[key])
					net.Send(client)

					if (skill.Setup) then
						skill.Setup(attrib[key])
					end
				end

				self:SetSkills(attrib)
			end

			hook.Run("CharacterSkillUpdated", client, self, key, value)
		end

		--- Temporarily increments one of this character's skills. Useful for things like consumable items.
		-- @realm server
		-- @string boostID Unique ID to use for the boost to remove it later
		-- @string attribID Name of the skill to boost
		-- @number boostAmount Amount to increase the skill by
		function charMeta:AddBoost(boostID, attribID, boostAmount)
			local boosts = self:GetVar("boosts", {})

			boosts[attribID] = boosts[attribID] or {}
			boosts[attribID][boostID] = boostAmount

			hook.Run("CharacterSkillBoosted", self:GetPlayer(), self, attribID, boostID, boostAmount)

			return self:SetVar("boosts", boosts, nil, self:GetPlayer())
		end

		--- Removes a temporary boost from this character.
		-- @realm server
		-- @string boostID Unique ID of the boost to remove
		-- @string attribID Name of the skill that was boosted
		function charMeta:RemoveBoost(boostID, attribID)
			local boosts = self:GetVar("boosts", {})

			boosts[attribID] = boosts[attribID] or {}
			boosts[attribID][boostID] = nil

			hook.Run("CharacterSkillBoosted", self:GetPlayer(), self, attribID, boostID, true)

			return self:SetVar("boosts", boosts, nil, self:GetPlayer())
		end
	else
		net.Receive("ixSkillUpdate", function()
			local id = net.ReadUInt(32)
			local character = ix.char.loaded[id]

			if (character) then
				local key = net.ReadString()
				local value = net.ReadFloat()

				character:GetSkills()[key] = value
			end
		end)
	end

	--- Returns all boosts that this character has for the given skill. This is only valid on the server and owning client.
	-- @realm shared
	-- @string attribID Name of the skill to find boosts for
	-- @treturn[1] table Table of boosts that this character has for the skill
	-- @treturn[2] nil If the character has no boosts for the given skill
	function charMeta:GetBoost(attribID)
		local boosts = self:GetBoosts()

		return boosts[attribID]
	end

	--- Returns all boosts that this character has. This is only valid on the server and owning client.
	-- @realm shared
	-- @treturn table Table of boosts this character has
	function charMeta:GetBoosts()
		return self:GetVar("boosts", {})
	end

	--- Returns the current value of an skill. This is only valid on the server and owning client.
	-- @realm shared
	-- @string key Name of the skill to get
	-- @number default Value to return if the skill doesn't exist
	-- @treturn number Value of the skill
	function charMeta:GetSkill(key, default)
		local att = self:GetSkills()[key] or default
		local boosts = self:GetBoosts()[key]

		if (boosts) then
			for _, v in pairs(boosts) do
				att = att + v
			end
		end

		return att
	end
end