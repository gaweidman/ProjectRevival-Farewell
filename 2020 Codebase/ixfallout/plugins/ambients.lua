
local PLUGIN = PLUGIN
PLUGIN.name = "Ambient Sounds"
PLUGIN.author = "Black Tea, Frosty"
PLUGIN.description = "Ambient Sounds"

ix.lang.AddTable("english", {
	ambient = "Ambient Sounds",
	optWindVolume = "Set Wind Volume",
	optdWindVolume = "Set amount volume of the ambient winds.",
})

ix.lang.AddTable("korean", {
	ambient = "환경음",
	optWindVolume = "바람 소리 세기",
	optdWindVolume = "바람 환경음의 소리 세기를 조절합니다.",
})

if CLIENT then
	ix.option.Add("windVolume", ix.type.number, 0.1, {
		category = "ambient", min = 0, max = 1, decimals = 2
	})

	PLUGIN.timeData = {}
	PLUGIN.sndWind = nil
	PLUGIN.sndAmbients = nil

	local ambients = {
		"fallout - fallout 3 ost/2_new_world_new_order.ogg",
		"fallout - fallout 3 ost/3_lockstep.ogg",
		"fallout - fallout 3 ost/4_unwelcome_guest.ogg",
		"fallout - fallout 3 ost/5_fortress.ogg",
		"fallout - fallout 3 ost/6_ambush.ogg",
		"fallout - fallout 3 ost/7_metal_on_metal.ogg",
		"fallout - fallout 3 ost/8_never_surrender.ogg",
		"fallout - fallout 3 ost/9_behemoth.ogg",
		"fallout - fallout 3 ost/10_think_fast_shoot_faster.ogg",
		"fallout - fallout 3 ost/11_chance_to_hit.ogg",
		"fallout - fallout 3 ost/12_forgotten.ogg",
		"fallout - fallout 3 ost/13_clues_in_the_darkness.ogg",
		"fallout - fallout 3 ost/14_no_way_out_but_through.ogg",
		"fallout - fallout 3 ost/15_the_ferals.ogg",
		"fallout - fallout 3 ost/16_out_of_service.ogg",
		"fallout - fallout 3 ost/17_gotta_start_somewhere.ogg",
		"fallout - fallout 3 ost/18_old_lands_new_frontiers.ogg",
		"fallout - fallout 3 ost/19_pieces_of_the_past.ogg",
		"fallout - fallout 3 ost/20_city_of_ruin.ogg",
		"fallout - fallout 3 ost/21_wandering_the_wastes.ogg",
		"fallout - fallout 3 ost/22_ashes_and_sand.ogg",
		"fallout - fallout 3 ost/23_place_of_refuge.ogg",
		"fallout - fallout 3 ost/24_the_caravans.ogg",
		"fallout - fallout 3 ost/25_what_remains.ogg",
		"fallout - fallout 3 ost/26_the_smallest_hope.ogg",
		"fallout - fallout 3 ost/27_a_stranger_in_town.ogg",
		"fallout - fallout 3 ost/28_megaton.ogg",
		"fallout - fallout 3 ost/29_base_01.ogg",
		"fallout - fallout 3 ost/30_base_02.ogg",
		"fallout - fallout 3 ost/31_base_03.ogg",
		"fallout - fallout 3 ost/32_base_04.ogg",
		"fallout - fallout 3 ost/40_dungeon_01.ogg",
		"fallout - fallout 3 ost/41_dungeon_02.ogg",
		"fallout - fallout 3 ost/42_dungeon_03.ogg",
		"fallout - fallout 3 ost/43_dungeon_04.ogg",
		"fallout - fallout 3 ost/44_explore_01.ogg",
		"fallout - fallout 3 ost/45_explore_02.ogg",
		"fallout - fallout 3 ost/46_explore_03.ogg",
		"fallout - fallout 3 ost/47_explore_04.ogg",
		"fallout - fallout 3 ost/48_explore_05.ogg",
		"fallout - fallout 3 ost/49_explore_06.ogg",
		"fallout - fallout 3 ost/50_explore_07.ogg"
	}

	-- local ambients = Format( "nv_ambiant/nv_%d.mp3", math.random( 1, 13 ) )
	
	function PLUGIN:Think()
		PLUGIN.sndWind = PLUGIN.sndWind or CreateSound( LocalPlayer(), "vehicles/fast_windloop1.wav" )
		PLUGIN.sndAmbients = PLUGIN.sndAmbients or CreateSound( LocalPlayer(), table.Random(ambients) )
		
		local data = {}
			data.start = LocalPlayer():GetShootPos()
			data.endpos = data.start + Vector( 0, 0, 10000 )
			data.filter = LocalPlayer()
		local trace = util.TraceLine(data)

		if trace.HitSky then
			if !self.sndWind:IsPlaying() then
				self.sndWind:Play()
			end
			self.sndWind:ChangeVolume( ix.option.Get("windVolume", 0.1), 4 )
		else
			if !self.sndAmbients:IsPlaying() then
				self.sndAmbients:Play()
			end
			self.sndWind:ChangeVolume( 0, 4 )
		end
	end
end
