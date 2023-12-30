if not tweak_data.is_helvete then
	return
end

Hooks:PreHook(GamePlayCentralManager, "_play_bullet_hit", "HVT_play_bullet_hit", function(self, params)
	local hit_pos = params.col_ray.position
	local need_sound = not params.no_sound and World:in_view_with_options(hit_pos, 4000, 0, 0)
	local need_effect = World:in_view_with_options(hit_pos, 20, 100, 5000)
	local need_decal = not self._block_bullet_decals and not params.no_decal and need_effect and World:in_view_with_options(hit_pos, 3000, 0, 0)
	if need_sound and need_effect and need_decal and alive(params.col_ray.unit) then
		local alert_event = {
			"aggression",
			hit_pos,
			300,
			managers.groupai:state():get_unit_type_filter("civilians_enemies"),
			params.col_ray.unit
		}
		managers.groupai:state():propagate_alert(alert_event)
	end
end)