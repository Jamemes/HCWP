if not tweak_data.is_new_diffs then
	return
end

local data = GroupAIStateBase.set_point_of_no_return_timer
function GroupAIStateBase:set_point_of_no_return_timer(time, point_of_no_return_id, point_of_no_return_tweak_id)

	if time and tweak_data.is_easy then
		time = time + 10000
	end
	
	data(self, time, point_of_no_return_id, point_of_no_return_tweak_id)
end

local function neighbours(alert_data, alert_listeners)
	if not tweak_data.is_helvete then
		return
	end
	
	local alert_type = alert_data[1]
	local alert_epicenter = alert_data[2]
	local alert_radius = alert_data[3]
	local listeners_by_type = alert_listeners[alert_type]
	if listeners_by_type and alert_epicenter then
		if alert_radius > 2500 then
			managers.groupai:state():on_police_called("sys_csgo_gunfire")
		end
	end
end

Hooks:PreHook(GroupAIStateBase, "propagate_alert", "HVT_propagate_alert", function(self, alert_data)
	neighbours(alert_data, self._alert_listeners)
end)