Hooks:PostHook(HUDBlackScreen, "_set_job_data", "HVT_setup_new_difficulties_blackscreen", function(self, ...)
	local job_panel = self._blackscreen_panel:child("job_panel")
	local risk_panel = job_panel:child(0)
	local risk_text = job_panel:child(1)
	risk_panel:clear()
	
	local difficulty_id = managers.job:current_difficulty_stars()
	local difficulty_stars = math.floor((difficulty_id / 2) + 1)
	local last_risk_level = nil
	for i = 1, difficulty_stars do
		local difficulty_name = tweak_data.difficulties[i + 4]
		local texture = tweak_data.gui.blackscreen_risk_textures[difficulty_name] or "guis/textures/pd2/risklevel_blackscreen"
		last_risk_level = risk_panel:bitmap({
			texture = texture,
			color = i == difficulty_stars and (difficulty_id % 2 == 0) and tweak_data.screen_colors.low_risk_color or tweak_data.screen_colors.high_risk_color
		})

		last_risk_level:move((i - 1) * last_risk_level:w(), 0)
	end

	if last_risk_level then
		risk_panel:set_size(last_risk_level:right(), last_risk_level:bottom())
		risk_panel:set_center(job_panel:w() / 2, job_panel:h() / 2)
		risk_panel:set_position(math.round(risk_panel:x()), math.round(risk_panel:y()))
	else
		risk_panel:set_size(64, 64)
		risk_panel:set_center_x(job_panel:w() / 2)
		risk_panel:set_bottom(job_panel:h() / 2)
		risk_panel:set_position(math.round(risk_panel:x()), math.round(risk_panel:y()))
	end
	
	if difficulty_id == -1 then
		risk_text:set_text("")
	elseif difficulty_id == 0 then
		risk_text:set_color(tweak_data.screen_colors.text)
	end
	
	risk_text:set_bottom(risk_panel:top())
	risk_text:set_center_x(risk_panel:center_x())
end)