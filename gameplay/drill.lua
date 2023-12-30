if not tweak_data.is_helvete then
	return
end

Hooks:PreHook(Drill, "_set_alert_state", "HVT_set_alert_state", function(self, state)
	if state then
		local alert_event = {
			"aggression",
			self._unit:position(),
			(self._alert_radius or 0) / 1.25,
			managers.groupai:state():get_unit_type_filter("civilians_enemies"),
			self._unit
		}
		managers.groupai:state():propagate_alert(alert_event)
	end
end)

Hooks:PreHook(Drill, "clbk_investigate_SO_verification", "HVT_clbk_investigate_SO_verification", function(self, candidate_unit)
	local candidate_listen_pos = candidate_unit:movement():m_head_pos()
	local sound_source_pos = self._unit:position()
	local ray = self._unit:raycast("ray", candidate_listen_pos, sound_source_pos, "slot_mask", managers.slot:get_mask("AI_visibility"), "ray_type", "ai_vision", "report")

	if ray then
		local my_dis = mvector3.distance(candidate_listen_pos, sound_source_pos)
		if my_dis > (self._alert_radius or 900) * 0.5 then
			local alert_event = {
				"aggression",
				self._unit:position(),
				(self._alert_radius or 0) / 1.25,
				managers.groupai:state():get_unit_type_filter("civilians_enemies"),
				self._unit
			}
			managers.groupai:state():propagate_alert(alert_event)

			return
		end
	end
end)