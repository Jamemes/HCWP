local data = BlackMarketManager.get_preferred_character_string
function BlackMarketManager:get_preferred_character_string()
	return data(self) .. "|HCWP"
end