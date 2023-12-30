if not tweak_data.is_new_diffs then
	return
end

function CopLogicIntimidated._start_action_hands_up(data)
	local my_data = data.internal_data
	local action_data = {
		clamp_to_graph = true,
		type = "act",
		body_part = 1,
		variant = tweak_data.is_easy and "tied_all_in_one" or "hands_up",
		blocks = {
			light_hurt = -1,
			hurt = -1,
			heavy_hurt = -1,
			walk = -1
		}
	}
	my_data.act_action = data.unit:brain():action_request(action_data)

	if my_data.act_action and data.unit:anim_data().hands_tied then
		CopLogicIntimidated._do_tied(data, my_data.aggressor_unit)
	end
end
