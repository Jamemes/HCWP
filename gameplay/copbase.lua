if not tweak_data.is_new_diffs then
	return
end

local data = CopBase.default_weapon_name
function CopBase:default_weapon_name(selection_name)
	if tweak_data.is_helvete then
		if self._tweak_table == "swat" or self._tweak_table == "fbi_swat" then
			return table.random({
				Idstring("units/payday2/weapons/wpn_npc_scar_murkywater/wpn_npc_scar_murkywater"),
				Idstring("units/payday2/weapons/wpn_npc_benelli/wpn_npc_benelli")
			})
		elseif self._tweak_table == "heavy_swat" or self._tweak_table == "fbi_heavy_swat" then
			return table.random({
				Idstring("units/payday2/weapons/wpn_npc_m4/wpn_npc_m4"),
				Idstring("units/payday2/weapons/wpn_npc_ump/wpn_npc_ump")
			})
		elseif self._tweak_table == "sniper" then
			return table.random({
				Idstring("units/pd2_dlc_drm/weapons/wpn_npc_mini/wpn_npc_mini"),
				Idstring("units/payday2/weapons/wpn_npc_lmg_m249/wpn_npc_lmg_m249"),
				Idstring("units/payday2/weapons/wpn_npc_sniper/wpn_npc_sniper")
			})
		end

		if self._default_weapon_id == "r870" then
			return table.random({
				Idstring("units/payday2/weapons/wpn_npc_r870/wpn_npc_r870"),
				Idstring("units/payday2/weapons/wpn_npc_benelli/wpn_npc_benelli")
			})
		end
	end
	
	return data(self, selection_name)
end