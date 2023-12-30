local data = ElementFilter._check_difficulty
function ElementFilter:_check_difficulty()
	local diff = Global.game_settings and Global.game_settings.difficulty or "hard"

	if self._values.difficulty_sm_wish and diff == "helvete" then
		return true
	end

	return data(self)
end