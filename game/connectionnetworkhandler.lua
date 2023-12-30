local data = ConnectionNetworkHandler.lobby_sync_update_difficulty
function ConnectionNetworkHandler:lobby_sync_update_difficulty(difficulty)
	Global.game_settings.difficulty = difficulty
	
	if managers.menu_component then
		managers.menu_component:on_job_updated()
	end

	data(self, difficulty)
end

local data = ConnectionNetworkHandler.request_join
function ConnectionNetworkHandler:request_join(peer_name, peer_account_type_str, peer_account_id, is_invite, preferred_character, dlcs, xuid, peer_level, peer_rank, peer_stinger_index, gameversion, join_attempt_identifier, auth_ticket, sender)
	local is_new_diffs = Global.game_settings.difficulty == "easy" or Global.game_settings.difficulty == "helvete"
	if is_new_diffs and not string.find(preferred_character, "|HCWP") then
		gameversion = 0
	end

	preferred_character = preferred_character:gsub("|HCWP", "")
	
	data(self, peer_name, peer_account_type_str, peer_account_id, is_invite, preferred_character, dlcs, xuid, peer_level, peer_rank, peer_stinger_index, gameversion, join_attempt_identifier, auth_ticket, sender)
end