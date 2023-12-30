function JobManager:current_difficulty_stars()
	local difficulty = Global.game_settings.difficulty or "easy"
	return table.index_of(tweak_data.difficulties, difficulty) - 2
end