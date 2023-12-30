Hooks:PostHook(HUDMissionBriefing, "init", "HVT_init_new_difficulties_briefing", function(self, ...)
	local risk_swat = self._paygrade_panel:child("risk_swat")
	local risk_fbi = self._paygrade_panel:child("risk_fbi")
	local risk_death_squad = self._paygrade_panel:child("risk_death_squad")
	local risk_easy_wish = self._paygrade_panel:child("risk_easy_wish")
	local risk_murder_squad = self._paygrade_panel:child("risk_murder_squad")
	local risk_sm_wish = self._paygrade_panel:child("risk_sm_wish")
	local pg_text = self._foreground_layer_one:child("pg_text")

	local death_squad_pos = risk_death_squad:left()
	local easy_wish_pos = risk_easy_wish:left()
	local murder_squad_pos = risk_murder_squad:left()
	
	local skulls_to_rework = {
		death_squad = risk_death_squad,
		easy_wish = risk_easy_wish,
		murder_squad = risk_murder_squad,
		sm_wish = risk_sm_wish
	}
	
	risk_swat:hide()
	risk_fbi:hide()
	
	pg_text:set_left(pg_text:left() + 55)

	managers.crimenet:rework_difficulties(skulls_to_rework, managers.job:current_difficulty_stars() + 2, managers.job:current_real_job_id())
end)