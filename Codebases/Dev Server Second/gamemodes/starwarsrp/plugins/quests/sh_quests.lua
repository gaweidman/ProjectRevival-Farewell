local PLUGIN = PLUGIN

---------------------------------
--- HOENYA HIDEOUT QUEST
--- COLELCT ONE ITEM FOR SOMEONE
--- THE ITEM HAS TO BE COLLECTED WILL BE RANDOMIZED IN randomItem. 

local QUEST = {}
QUEST.uniqueID = "honeya"
QUEST.name = "Honeya Hideout's Problem"
QUEST.desc = "Get %s of %s for Honeya Hideout." -- If you don't know how it's working, Just check in sh_advhandler.lua in dialogue.
QUEST.quickRewards = {
	currency = 100,
	items = {
		{ uid = "food2_can_meat", amount = 1, data = {} },
	}	
}

QUEST.randomItem = { -- 
	{ uid = "junk_c", min = 1, max = 1 },
	{ uid = "junk_w", min = 1, max = 1 },
	{ uid = "junk_m", min = 1, max = 1 },
}
function QUEST:GenerateData( player )
	local tbl = {}
	for i = 0, 0 do
		local idat = table.Random( self.randomItem )
		tbl[ idat.uid ] = math.random( idat.min, idat.max ) 
		print( 'inserted '.. idat.uid )
	end
	return tbl
end

function QUEST:CanComplete( player, data )
	for uid, num in pairs( data ) do
		if !player:HasItem( uid, num ) then
			print( Format( "lack of %s of %s", num, uid ) )
			return false
		end
	end
	return true
end

function QUEST:RemoveQuestItem( player, data )
	for uid, num in pairs( data ) do
		player:UpdateInv( uid, -num )
	end
end

function QUEST:PostReward( player, data )
	print( 'PostReward')
	return true
end

PLUGIN:RegisterQuest( QUEST.uniqueID, QUEST )