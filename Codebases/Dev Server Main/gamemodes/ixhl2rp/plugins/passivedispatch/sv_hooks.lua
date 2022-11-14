local randomSounds = {
	"npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav",
	"npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav",
	"industrial17/c17_pa0.wav",
	"industrial17/c17_pa1.wav",
	"industrial17/c17_pa2.wav",
	"industrial17/c17_pa3.wav",
	"industrial17/c17_pa4.wav",
}

function PLUGIN:EmitRandomChatter(player)
	local randomSound = randomSounds[ math.random(1, #randomSounds) ]
	ix.util.EmitQueuedSounds(player, {"c17/city_listentone1.wav", randomSound, "c17/city_listentone1.wav"}, 0, 0.3)

	timer.Simple(3.5, function()
		
		if (randomSound == "npc/overwatch/cityvoice/f_innactionisconspiracy_spkr.wav") then
			ix.chat.Send(player, "dispatchs", "Citizen reminder. Inaction is conspiracy. Report counter behaviour to a Civil Protection team immediately.", true)
		elseif (randomSound == "npc/overwatch/cityvoice/f_trainstation_offworldrelocation_spkr.wav") then
			ix.chat.Send(player, "dispatchs", "Citizen notice. Failure to co-operate will result in permanent off-world relocation.", true)
		elseif(randomSound == "industrial17/c17_pa0.wav") then
			ix.chat.Send(player, "broadcasts", "The true citizen knows that duty is the greatest gift.", true)
		elseif(randomSound == "industrial17/c17_pa1.wav") then
			ix.chat.Send(player, "broadcasts", "The true citizen appreciates the comforts of City 17, but uses discretion.", true)
		elseif(randomSound == "industrial17/c17_pa2.wav") then
			ix.chat.Send(player, "broadcasts", "The true citizen's identiband is kept clean and visible at all times.", true)
		elseif (randomSound == "industrial17/c17_pa3.wav") then
			ix.chat.Send(player, "broadcasts", "The true citizen's job is the opposite of slavery.", true)
		elseif (randomSound == "industrial17/c17_pa4.wav") then
			ix.chat.Send(player, "broadcasts", "The true citizen conserves valuable oxygen.", true)
		end
	end)
end

-- Color(150, 100, 100)

function PLUGIN:Tick()
	for k, v in ipairs( player.GetAll() ) do
		local curTime = CurTime()
		
		if (!self.nextChatterEmit) then 
			self.nextChatterEmit = curTime + math.random(390, 510)
		end
		
		if ( (curTime >= self.nextChatterEmit) ) then
			self.nextChatterEmit = nil
			self:EmitRandomChatter(v)
		end
	end
end