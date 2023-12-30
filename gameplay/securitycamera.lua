if not tweak_data.is_new_diffs then
	return
end

local data = SecurityCamera.set_detection_enabled
function SecurityCamera:set_detection_enabled(state, settings, mission_element)
	if tweak_data.is_easy then
		state = false
	end
	
	data(self, state, settings, mission_element)
end