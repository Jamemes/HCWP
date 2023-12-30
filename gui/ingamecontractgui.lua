local function get_skull_index(panel, id)
	for i = 0, panel:num_children() - 1 do
		if panel:child(i) and panel:child(i):name() == id then
			return i
		end
	end
end

Hooks:PostHook(IngameContractGui, "init", "HVT_init_new_difficulties_ingame", function(self, ...)
	local text_panel = self._panel:child(1)
	local id = get_skull_index(text_panel, "risk_stats_panel")

	local risk_swat = text_panel:child(id + 1)
	local risk_fbi = text_panel:child(id + 2)
	local risk_death_squad = text_panel:child(id + 3)
	local risk_easy_wish = text_panel:child(id + 4)
	local risk_murder_squad = text_panel:child(id + 5)
	local risk_sm_wish = text_panel:child(id + 6)
	
	local risk_text = text_panel:child("risk_text")
	local risk_stats_panel = text_panel:child("risk_stats_panel")
	
	local skulls_to_rework = {
		death_squad = risk_death_squad,
		easy_wish = risk_easy_wish,
		murder_squad = risk_murder_squad,
		sm_wish = risk_sm_wish
	}
	
	risk_swat:hide()
	risk_fbi:hide()
	
	risk_death_squad:set_left(risk_stats_panel:left() + 8)
	risk_easy_wish:set_left(risk_death_squad:right())
	risk_murder_squad:set_left(risk_easy_wish:right())
	risk_sm_wish:set_left(risk_murder_squad:right())
	risk_text:set_left(risk_sm_wish:right() + 12)

	managers.crimenet:rework_difficulties(skulls_to_rework, managers.job:current_difficulty_stars() + 2)
	managers.crimenet:setup_new_stats(risk_stats_panel, managers.job:current_difficulty_stars() + 2, managers.job:current_job_id())
	managers.crimenet:add_new_difficulty_desc(text_panel, tweak_data:index_to_difficulty(managers.job:current_difficulty_stars() + 2), managers.job:current_job_id())
end)