if not tweak_data.is_new_diffs then
	return
end

local data = EnemyManager.add_delayed_clbk
function EnemyManager:add_delayed_clbk(id, clbk, execute_t)
	
	if id == "_gameover_clbk" and tweak_data.is_easy then
		execute_t = Application:time() + 10^10
	end
	
	data(self, id, clbk, execute_t)
end