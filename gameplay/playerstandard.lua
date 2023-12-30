if not tweak_data.is_helvete then
	return
end

Hooks:PreHook(PlayerStandard, "say_line", "HVT_say_line", function(self, ...)
	local alert_rad = 500
	local new_alert = {
		"vo_cbt",
		self._unit:movement():m_head_pos(),
		alert_rad,
		self._unit:movement():SO_access(),
		self._unit
	}

	managers.groupai:state():propagate_alert(new_alert)
end)

Hooks:PreHook(PlayerStandard, "_update_movement", "HVT_update_movement", function(self, t, ...)
	local cur_pos = self._pos
	local move_dis = mvector3.distance_sq(cur_pos, self._last_sent_pos)
	if not self:_on_zipline() and (move_dis > 22500 or move_dis > 400 and (t - self._last_sent_pos_t > 1.5 or not pos_new)) then
		self._ext_network:send("action_walk_nav_point", cur_pos)
		mvector3.set(self._last_sent_pos, cur_pos)
		self._last_sent_pos_t = t
		if self._move_dir and self._running and not self._state_data.ducking and not managers.groupai:state():enemy_weapons_hot() then
			local alert_epicenter = mvector3.copy(self._last_sent_pos)
			mvector3.set_z(alert_epicenter, alert_epicenter.z + 150)
			local footstep_alert = {
				"footstep",
				alert_epicenter,
				500,
				managers.groupai:state():get_unit_type_filter("civilians_enemies"),
				self._unit
			}
			managers.groupai:state():propagate_alert(footstep_alert)
		end
	end
end)