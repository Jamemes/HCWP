Hooks:PostHook(CrimeNetContractGui, "init", "HVT_init_new_difficulties", function(self, ...)
	managers.menu:add_difficulty_opt(self._node, "difficulty", 1, 9)
	
	local job_data = self._node:parameters().menu_component_data
	local risk_swat = self._contract_panel:child("risk_swat")
	local risk_fbi = self._contract_panel:child("risk_fbi")
	local risk_death_squad = self._contract_panel:child("risk_death_squad")
	local risk_easy_wish = self._contract_panel:child("risk_easy_wish")
	local risk_murder_squad = self._contract_panel:child("risk_murder_squad")
	local risk_sm_wish = self._contract_panel:child("risk_sm_wish")
	
	local risk_text = self._contract_panel:child("risk_text")
	local risk_stats_panel = self._contract_panel:child("risk_stats_panel")
	
	self._skulls_to_rework = {
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
	
	managers.crimenet:rework_difficulties(self._skulls_to_rework, 0)
	managers.crimenet:setup_new_stats(risk_stats_panel, 0, job_data.job_id)
	managers.crimenet:add_new_difficulty_desc(self._contract_panel, job_data.difficulty, job_data.job_id)
	
	self._current_difficulty_star = job_data.difficulty == "normal" and 0 or -1
end)

Hooks:PostHook(CrimeNetContractGui, "set_difficulty_id", "HVT_set_new_difficulties", function(self, difficulty_id)
	local job_data = self._node:parameters().menu_component_data
	job_data.difficulty_id = difficulty_id
	job_data.difficulty = tweak_data.difficulties[difficulty_id]
	
	managers.crimenet:rework_difficulties(self._skulls_to_rework, job_data.difficulty_id)
	managers.crimenet:setup_new_stats(self._contract_panel:child("risk_stats_panel"), job_data.difficulty_id, job_data.job_id)
	managers.crimenet:add_new_difficulty_desc(self._contract_panel, job_data.difficulty, job_data.job_id)
end)

Hooks:PreHook(CrimeNetContractGui, "set_all", "HVT_set_easy_difficulty", function(self, ...)
	self._node:parameters().menu_component_data.difficulty_id = 1
	self._node:parameters().menu_component_data.difficulty = "easy"
end)

Hooks:PostHook(CrimeNetContractGui, "set_all", "HVT_setup_new_difficulties", function(self, ...)
	local job_data = self._node:parameters().menu_component_data
	managers.crimenet:rework_difficulties(self._skulls_to_rework, job_data.difficulty_id)
	managers.crimenet:setup_new_stats(self._contract_panel:child("risk_stats_panel"), job_data.difficulty_id, job_data.job_id)
	managers.crimenet:add_new_difficulty_desc(self._contract_panel, job_data.difficulty, job_data.job_id)
end)

Hooks:PostHook(CrimeNetContractGui, "set_potential_rewards", "HVT_set_potential_rewards", function(self, ...)
	local job_data = self._node:parameters().menu_component_data
	managers.crimenet:rework_difficulties(self._skulls_to_rework, job_data.difficulty_id)
	managers.crimenet:setup_new_stats(self._contract_panel:child("risk_stats_panel"), job_data.difficulty_id, job_data.job_id)
end)

Hooks:PostHook(CrimeNetContractGui, "count_difficulty_stars", "HVT_count_difficulty_skulls", function(self, t, ...)
	local job_data = self._node:parameters().menu_component_data
	
	if self._data.stars.difficulty_stars == -1 then
		managers.crimenet:rework_difficulties(self._skulls_to_rework, 1)
		managers.crimenet:setup_new_stats(self._contract_panel:child("risk_stats_panel"), 1, job_data.job_id)
		self._data.gui_objects.risk_text:show()

		self._step = self._step + 1
		self._wait_t = t + 0.5

		return
	end
	
	managers.crimenet:rework_difficulties(self._skulls_to_rework, self._current_difficulty_star + 2, job_data.job_id)
	managers.crimenet:setup_new_stats(self._contract_panel:child("risk_stats_panel"), self._current_difficulty_star + 2, job_data.job_id)
end)