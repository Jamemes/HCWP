local data = ElementPointOfNoReturn.operation_add
function ElementPointOfNoReturn:operation_add()
	local diff = Global.game_settings and Global.game_settings.difficulty or "hard"
	self._values.time_easy = self._values.time_easy * 10
	
	data(self)
	
	if diff == "helvete" then
		managers.groupai:state():set_point_of_no_return_timer(self._values.time_sm_wish, self._id, self._values.tweak_id)
	end
end