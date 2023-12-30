local name = "helvete"
local difficulty = Global.game_settings and Global.game_settings.difficulty or "easy"
tweak_data.curr_diff = difficulty
tweak_data.is_easy = difficulty == "easy"
tweak_data.is_helvete = difficulty == "helvete"
tweak_data.is_new_diffs = difficulty == "easy" or difficulty == "helvete"

local function set_new_diff_value(tbl, val)
	tbl[#tbl + 1] = val or tbl[#tbl]
end

set_new_diff_value(tweak_data.difficulties, name)
set_new_diff_value(tweak_data.difficulty_level_locks)
set_new_diff_value(tweak_data.experience_manager.difficulty_multiplier, 15)
tweak_data.difficulty_name_ids[name] = "menu_difficulty_"..name

local play = tweak_data.player
local char = tweak_data.character
local group = tweak_data.group_ai
local weap = tweak_data.weapon
local money = tweak_data.money_manager
local mask_off = tweak_data.attention.settings.pl_mask_off_foe_combatant
set_new_diff_value(money.difficulty_multiplier, 50)
set_new_diff_value(money.difficulty_multiplier_payout, 15)
set_new_diff_value(money.preplaning_asset_cost_multiplier_by_risk, 16)

money.difficulty_multiplier[0] = 2
money.difficulty_multiplier_payout[0] = 0.5
money.preplaning_asset_cost_multiplier_by_risk[0] = 0.5

for _, job in pairs(tweak_data.narrative.jobs) do

	if job.payout then
		job.payout[0] = job.payout[1]
		set_new_diff_value(job.payout)
	end
	
	if job.contract_cost then
		job.contract_cost[0] = math.round(job.contract_cost[1] / 2)
		set_new_diff_value(job.contract_cost)
	end
	
	if job.contract_visuals then
		for id, xp in pairs(job.contract_visuals) do
			if type(xp) == "table" and (id == "min_mission_xp" or id == "max_mission_xp") then
				xp[0] = xp[1]
				set_new_diff_value(xp)
			end
		end
	end
end

if tweak_data.is_easy then
	weap:_set_normal()
	
	local function reduce_025(unit)
		char[unit].HEALTH_INIT = char[unit].HEALTH_INIT * 0.25
		char[unit].headshot_dmg_mul = char[unit].HEALTH_INIT
	end
	
	char:_multiply_all_hp(0.25, 1)
	reduce_025("security")
	reduce_025("gensec")
	reduce_025("cop")
	reduce_025("fbi")
	reduce_025("fbi_female")
	reduce_025("gangster")
	reduce_025("triad")
	reduce_025("mobster")
	reduce_025("tank_mini")
	reduce_025("hector_boss")
	reduce_025("mobster_boss")
	reduce_025("biker_boss")
	reduce_025("chavez_boss")
	
	tweak_data.equipments.specials.cable_tie.quantity = 30
	tweak_data.equipments.specials.cable_tie.max_quantity = 30
	
	play.damage.automatic_respawn_time = 30
	play.damage.LIVES_INIT = 51
	play.damage.MIN_DAMAGE_INTERVAL = 0.6
	play.damage.REVIVE_HEALTH_STEPS = {1}
	play.damage.REGENERATE_TIME = 1

	for _, unit in pairs(char:enemy_list()) do
		char[unit].headshot_dmg_mul = char[unit].HEALTH_INIT
		char[unit].suppression = char.presets.suppression.easy
		char[unit].dodge = char.presets.dodge.poor
		char[unit].surrender = { base_chance = 1 }
		char[unit].has_alarm_pager = false
		char[unit].steal_loot = false
		
		char[unit].detection.idle.delay = {3, 3}
		char[unit].detection.combat.delay = {3, 5}
		char[unit].detection.recon.delay = {3, 5}
		char[unit].detection.guard.delay = {3, 5}
		char[unit].detection.ntl.delay = {3, 5}
	end
	
	char.cop.move_speed = char.presets.move_speed.slow

	char.civilian.calls_in = false
	char.civilian_female.calls_in = false
	char.bank_manager.calls_in = false
	
	char.civilian.detection.cbt.delay = {5, 10}
	char.civilian.detection.ntl.delay = {5, 10}
	char.civilian_female.detection = char.civilian.detection
	char.bank_manager.detection = char.civilian.detection
	
	group.unit_categories.CS_swat_MP5 = group.unit_categories.CS_cop_C45_R870
	group.unit_categories.CS_swat_R870 = group.unit_categories.CS_cop_C45_R870
	group.unit_categories.CS_heavy_M4 = group.unit_categories.CS_cop_C45_R870
	group.unit_categories.CS_heavy_R870 = group.unit_categories.CS_cop_C45_R870
	group.unit_categories.CS_heavy_M4_w = group.unit_categories.CS_cop_C45_R870
	group.unit_categories.CS_tazer = group.unit_categories.CS_cop_stealth_MP5
	group.unit_categories.CS_shield = group.unit_categories.CS_cop_stealth_MP5
	
	group.besiege.assault.force = { 1.5, 3.5, 5 }
	group.besiege.assault.force_pool = { 0, 30, 50 }
	
	mask_off.max_range = 1
	mask_off.suspicion_range = 1
end

if tweak_data.is_helvete then
	tweak_data.difficulty_name_id = tweak_data.difficulty_name_ids.helvete
	tweak_data.experience_manager.civilians_killed = 20000
	tweak_data.experience_manager.total_level_objectives = 10000
	tweak_data.experience_manager.total_criminals_finished = 4000
	tweak_data.experience_manager.total_objectives_finished = 6000
	
	play:_set_sm_wish()
	char:_set_sm_wish()
	group:_init_unit_categories(8)
	group:_init_enemy_spawn_groups(8)
	group:_init_task_data(8, "sm_wish")
	weap:_set_sm_wish()
	
	char:_multiply_all_hp(1.5, 1)
	
	char.presets.gang_member_damage.MIN_DAMAGE_INTERVAL = 0.1
	play.damage.MIN_DAMAGE_INTERVAL = 0.1
	play.damage.LIVES_INIT = 3
	play.damage.REVIVE_HEALTH_STEPS = {0.05}
	play.damage.automatic_respawn_time = nil
	play.damage.TASED_TIME = 2
	play.damage.DOWNED_TIME = 15
	play.alarm_pager.call_duration = {
		{4, 5},
		{3, 5}
	}
	play.alarm_pager.bluff_success_chance_w_skill = {
		1,
		0.95,
		0.85,
		0.75,
		0
	}
	
	local detection = {
		angle_max = 280,
		delay = { 0, 0 },
		use_uncover_range = true,
		dis_max = 13000
	}
	
	for _, unit in pairs(char:enemy_list()) do
		char[unit].weapon.is_lmg =  char.tank.weapon.is_rifle
		char[unit].weapon.is_shotgun_mag =  char.tank.weapon.is_shotgun_mag
		char[unit].explosion_damage_mul =  0.2
		char[unit].surrender = char.presets.surrender.hard
		char[unit].detection.idle = detection
		char[unit].detection.combat = detection
		char[unit].detection.recon = detection
		char[unit].detection.guard = detection
		char[unit].detection.ntl = detection
		char[unit].has_alarm_pager = true
		char[unit].can_reload_while_moving_tmp = true
		char[unit].no_arrest = true
	end
	
	char.civilian.move_speed = char.presets.move_speed.lightning
	char.civilian.hostage_move_speed = 0.5
	char.civilian.scare_max = { 0, 1 }
	char.civilian.run_away_delay = { 0, 0 }
	char.civilian.submission_max = { 0, 1 }
	char.civilian.submission_intimidate = 1
	
	char.civilian_female.move_speed = char.presets.move_speed.lightning
	char.civilian_female.hostage_move_speed = 0.5
	char.civilian_female.scare_max = { 0, 1 }
	char.civilian_female.run_away_delay = { 0, 0 }
	char.civilian_female.submission_max = { 0, 1 }
	char.civilian_female.submission_intimidate = 1
	
	char.swat = char.city_swat
	char.swat.headshot_dmg_mul = char.swat.headshot_dmg_mul / 2
	char.swat.move_speed = char.presets.move_speed.lightning
	
	char.heavy_swat = char.fbi_heavy_swat
	char.heavy_swat.headshot_dmg_mul = char.heavy_swat.headshot_dmg_mul / 2
	char.heavy_swat.move_speed = char.presets.move_speed.very_fast
	char.heavy_swat.dodge = char.presets.dodge.athletic
	
	char.shield.headshot_dmg_mul = char.shield.headshot_dmg_mul / 2
	
	char.taser.weapon.is_rifle.FALLOFF = char.heavy_swat.weapon.is_rifle.FALLOFF

	char.spooc.headshot_dmg_mul = char.spooc.headshot_dmg_mul / 2
	char.spooc.flammable = false
	char.spooc.spooc_attack_timeout = { 0, 0 }
	char.spooc.spooc_attack_beating_time = { 0, 0 }
	char.spooc.spooc_sound_events = {
		detect_stop = "",
		detect = ""
	}

	char.spooc.dodge_with_grenade = {
		flash = {
			instant = true,
			duration = {
				1,
				1
			}
		},
		check = function (t, nr_grenades_used)
			local delay_till_next_use = math.lerp(17, 45, math.min(1, (nr_grenades_used or 0) / 4))
			local chance = math.lerp(1, 0.5, math.min(1, (nr_grenades_used or 0) / 10))

			if math.random() < chance then
				return true, t + delay_till_next_use
			end

			return false, t + delay_till_next_use
		end
	}
		
	char.tank.weapon.is_shotgun_pump.RELOAD_SPEED = 1
	char.tank.weapon.is_shotgun_mag.RELOAD_SPEED = 1
	char.tank.weapon.is_rifle.RELOAD_SPEED = 1
	
	char.tank_mini.move_speed = char.presets.move_speed.very_slow
	char.tank_hw.move_speed = char.presets.move_speed.very_slow
	
	char.tank_medic.headshot_dmg_mul = char.tank_medic.headshot_dmg_mul * 1.5
	char.tank_mini.headshot_dmg_mul = char.tank_mini.headshot_dmg_mul * 1.5
	char.tank.headshot_dmg_mul = char.tank.headshot_dmg_mul * 1.5
	
	char.sniper.HEALTH_INIT = char.swat.HEALTH_INIT
	char.presets.weapon.sniper.mini = char.tank_mini.weapon.mini
	char.presets.weapon.sniper.mini.use_laser = true
	char.presets.weapon.sniper.mini.FALLOFF[1].r = 2000
	char.presets.weapon.sniper.mini.FALLOFF[2].r = 10000
	char.presets.weapon.sniper.mini.FALLOFF[3].r = 20000
	char.presets.weapon.sniper.mini.FALLOFF[4].r = 40000
	char.presets.weapon.sniper.mini.FALLOFF[5].r = 60000
	char.presets.weapon.sniper.is_lmg.use_laser = true
	char.presets.weapon.sniper.is_lmg.FALLOFF[1].r = 2000
	char.presets.weapon.sniper.is_lmg.FALLOFF[2].r = 10000
	char.presets.weapon.sniper.is_lmg.FALLOFF[3].r = 20000
	char.presets.weapon.sniper.is_rifle.FALLOFF[1].recoil = {0.5, 0.85}
	char.presets.weapon.sniper.is_rifle.FALLOFF[2].recoil = {0.5, 0.85}
	char.presets.weapon.sniper.is_rifle.FALLOFF[3].recoil = {0.5, 0.85}
	
	char.cop.weapon = char.swat.weapon
	char.gensec.weapon = char.swat.weapon
	char.shield.weapon = char.swat.weapon

	char.cop.HEALTH_INIT = 36
	char.security.HEALTH_INIT = 36
	char.security_mex.HEALTH_INIT = 36
	char.security_mex_no_pager.HEALTH_INIT = 36

	local loot = tweak_data.carry.small_loot
	loot.money_bundle = 1000
	loot.money_bundle_value = 10000
	loot.ring_band = 1954
	loot.diamondheist_vault_bust = 12000
	loot.diamondheist_vault_diamond = 15000
	loot.diamondheist_big_diamond = 15000
	loot.mus_small_artifact = 9500
	loot.value_gold = 3000
	loot.gen_atm = 300000
	loot.special_deposit_box = 3500
	loot.slot_machine_payout = 325000
	loot.vault_loot_chest = 7500
	loot.vault_loot_diamond_chest = 8000
	loot.vault_loot_banknotes = 6500
	loot.vault_loot_silver = 7000
	loot.vault_loot_diamond_collection = 8500
	loot.vault_loot_trophy = 9000
	loot.money_wrap_single_bundle_vscaled = 5000
	loot.spawn_bucket_of_money = 260000
	loot.vault_loot_gold = 30000
	loot.vault_loot_cash = 15000
	loot.vault_loot_coins = 10500
	loot.vault_loot_ring = 4500
	loot.vault_loot_jewels = 7500
	loot.vault_loot_macka = 1
	loot.federali_medal = 11000
	
	group.flash_grenade.timer = 0.5
	group.flash_grenade.light_range = 0
	group.flash_grenade.beep_speed = { 0, 0 }

	weap.c45_npc.DAMAGE = 5
	weap.x_c45_npc.DAMAGE = 5
	weap.mp9_npc.DAMAGE = 5
	weap.raging_bull_npc.DAMAGE = 8
	weap.mp5_npc.DAMAGE = 3
	weap.ump_npc.DAMAGE = 4
	weap.m4_npc.DAMAGE = 5
	weap.m4_yellow_npc.DAMAGE = 5
	weap.scar_npc.DAMAGE = 6
	weap.benelli_npc.DAMAGE = 2
	weap.saiga_npc.DAMAGE = 5
	weap.saiga_npc.CLIP_AMMO_MAX = 22
	weap.m249_npc.usage = "is_lmg"
	weap.benelli_npc.usage = "is_shotgun_mag"
		
	mask_off.max_range = 4500
	mask_off.suspicion_range = 4000
	mask_off.suspicion_duration = 1.5
	mask_off.release_delay = 0
	tweak_data.attention.settings.pl_mask_off_foe_non_combatant = tweak_data.attention.settings.pl_mask_off_foe_combatant
end