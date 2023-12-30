local is_new_diffs = Global.game_settings.difficulty == "easy" or Global.game_settings.difficulty == "helvete"
local data = NetworkPeer.send
function NetworkPeer:send(func_name, ...)
	data(self, func_name, ...)

	if func_name == "join_request_reply" or func_name == "sync_game_settings" then
		data(self, "lobby_sync_update_difficulty", Global.game_settings.difficulty)
	end
end

local data = NetworkPeer.register_mod
function NetworkPeer:register_mod(id, friendly)
	if friendly == "Helvete (Enabled)" then
		self._HCWP = true
	end

	data(self, id, friendly)
end

local data = NetworkPeer.set_synched
function NetworkPeer:set_synched(state)
	if is_new_diffs and Network:is_server() and not self._HCWP then
		managers.network:session():send_to_peers("kick_peer", self:id(), 4)
		managers.network:session():on_peer_kicked(self, self:id(), 4)

		return
	end

	data(self, state)
end