local function replace(tbl)
	if tbl[3] == Idstring("risk") then
		tbl[3] = "hud_new_difficulties"
	end
	
	if tbl[7] == Idstring("risk") then
		tbl[7] = tweak_data.difficulty_name_ids[tweak_data.curr_diff]
	end
	
	return tbl
end

local data = HUDAssaultCorner._get_assault_strings
function HUDAssaultCorner:_get_assault_strings()
	return replace(data(self))
end

local data = HUDAssaultCorner._get_survived_assault_strings
function HUDAssaultCorner:_get_survived_assault_strings()
	return replace(data(self))
end