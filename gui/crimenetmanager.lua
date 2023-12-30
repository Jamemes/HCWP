tweak_data.screen_colors.high_risk_color = tweak_data.screen_colors.risk
tweak_data.screen_colors.low_risk_color = tweak_data.screen_colors.text:with_alpha(0.8)
local difficulty = Global.game_settings and Global.game_settings.difficulty or "easy"
local current_stars = math.floor(tweak_data:difficulty_to_index(difficulty) / 2)

Hooks:Add("LocalizationManagerPostInit", "HVT_loc", function(...)
	LocalizationManager:add_localized_strings({
		menu_difficulty_helvete = "Helvete",
		menu_risk_easy = "Easy. Cash reward is slightly decreased.",
		menu_risk_helvete = "Helvete. Horrificly increased XP and cash.",
		hud_new_difficulties = string.rep("", current_stars),
	})

	if Idstring("russian"):key() == SystemInfo:language():key() then
		LocalizationManager:add_localized_strings({
			menu_risk_easy = "Легко. Денежная награда за риск немного снижена.",
			menu_risk_helvete = "Helvete. Ужасающе увеличены очки опыта и наличные.",
		})
	end
end)

function CrimeNetManager:rework_difficulties(panel, difficulty)
	local risk_death_squad = panel.death_squad
	local risk_easy_wish = panel.easy_wish
	local risk_murder_squad = panel.murder_squad
	local risk_sm_wish = panel.sm_wish
	
	local function setup_skulls(pic, dif1, dif2)
		pic:set_alpha(1)
		pic:set_color(difficulty >= dif2 and tweak_data.screen_colors.high_risk_color or difficulty >= dif1 and tweak_data.screen_colors.low_risk_color or tweak_data.screen_colors.text:with_alpha(0.2))
	end
	
	setup_skulls(risk_death_squad, 2, 3)
	setup_skulls(risk_easy_wish, 4, 5)
	setup_skulls(risk_murder_squad, 6, 7)
	setup_skulls(risk_sm_wish, 8, 9)
end

function CrimeNetManager:setup_new_stats(risk_stats_panel, difficulty, job_id)
	local function color_range(text, color, modifier_string)
		local start_ci = string.find(modifier_string, "color_range_start") or 0
		local end_ci = string.find(modifier_string, "color_range_end") or 0

		start_ci = start_ci - 1
		end_ci = end_ci - 18
		
		local color_st = start_ci > 0 and start_ci or 0
		local color_end = end_ci > 0 and end_ci or 0
		text:set_text(modifier_string:gsub("color_range_start", ""):gsub("color_range_end", ""))
		text:clear_range_color(0, #modifier_string)
		text:set_range_color(color_st, color_end, color)
		text:set_rotation(360)
	end
	
	local function stat(val)
		local stat = tostring(managers.statistics:completed_job(job_id, tweak_data:index_to_difficulty(val)))
		return difficulty == val and "color_range_start"..stat.."color_range_end" or stat
	end
	
	risk_stats_panel:set_w(135)
	risk_stats_panel:child("risk_fbi"):hide()
	risk_stats_panel:child("risk_death_squad"):hide()
	risk_stats_panel:child("risk_easy_wish"):hide()
	risk_stats_panel:child("risk_murder_squad"):hide()
	risk_stats_panel:child("risk_sm_wish"):hide()
	
	local stats = risk_stats_panel:child("risk_swat")
	stats:set_alpha(1)
	stats:set_color(tweak_data.screen_colors.text:with_alpha(0.1))
	stats:set_font_size(tweak_data.menu.pd2_small_font_size)
	color_range(stats, tweak_data.screen_colors.high_risk_color, stat(2).."  "..stat(3).."  "..stat(4).."  "..stat(5).."  "..stat(6).."  "..stat(7).."  "..stat(8).."  "..stat(9))

	local _, _, w, _ = stats:text_rect()
	while w > risk_stats_panel:w() - 10 do
		stats:set_font_size(stats:font_size() * 0.99)
		_, _, w, _ = stats:text_rect()
	end
	
	local x, y, w, h = stats:text_rect()
	stats:set_size(w, h)
	stats:set_position(math.round(stats:x()), math.round(stats:y()))
	stats:set_center(risk_stats_panel:w() / 2, risk_stats_panel:h() / 2)
end

function CrimeNetManager:add_new_difficulty_desc(panel, difficulty, job_id)
	if difficulty == "easy" then
		panel:child("risk_text"):set_text(managers.localization:to_upper_text("menu_risk_easy") .. " " .. managers.localization:to_upper_text("menu_stat_job_completed", {
			stat = tostring(managers.statistics:completed_job(job_id, tweak_data:index_to_difficulty(1)))
		}) .. " ")
	elseif difficulty == "helvete" then
		panel:child("risk_text"):set_text(managers.localization:to_upper_text("menu_risk_helvete") .. " " .. managers.localization:to_upper_text("menu_stat_job_completed", {
			stat = tostring(managers.statistics:completed_job(job_id, tweak_data:index_to_difficulty(9)))
		}) .. " ")
	end
end

function CrimeNetGui:custom_gui(job)
	job.side_panel:child("stars_panel"):clear()
	
	if job.job_id then
		local x = 0
		local y = 0
		local difficulty_stars = job.difficulty_id / 2
		local start_difficulty = 1
		local num_skulls = 4

		for i = start_difficulty, num_skulls do
			job.side_panel:child("stars_panel"):bitmap({
				texture = "guis/textures/pd2/hud_difficultymarkers_2",
				h = 18,
				w = 19,
				layer = 0,
				x = x - 3,
				y = y - 3,
				rotation = 360,
				texture_rect = {
					i == 2 and 90 or i == 4 and 30 or 0,
					i >= 3 and 32 or 0,
					30,
					30
				},
				alpha = difficulty_stars < i and 0.5 or 1,
				blend_mode = difficulty_stars < i and "normal" or "add",
				color = difficulty_stars == i and tweak_data.screen_colors.low_risk_color or difficulty_stars < i and Color.black or tweak_data.screen_colors.high_risk_color
			})

			x = x + 13
		end
		
	end
end

local gui = CrimeNetGui._create_job_gui
function CrimeNetGui:_create_job_gui(data, type, fixed_x, fixed_y, fixed_location)
	if managers.user:get_setting("crimenet_filter_difficulty") <= 0 then
		if math.random() < 0.1 then
			local random_diff = math.random() < 0.5
			data.difficulty = random_diff and "helvete" or "easy"
			data.difficulty_id = random_diff and 9 or 1
		end
	end
	
	local gui_data = gui(self, data, type, fixed_x, fixed_y, fixed_location)
	self:custom_gui(gui_data)
	
	return gui_data
end