function MenuManager:add_difficulty_opt(node, item_name, easy_index, helvete_index)
	if node:item(item_name) then
		local function add_options(opt)
			if opt[easy_index]._parameters.text_id ~= "menu_difficulty_easy" then
				local easy = deep_clone(opt[easy_index])
				easy._parameters.text_id = "menu_difficulty_easy"
				easy._parameters.value = 1
				table.insert(opt, easy_index, easy)
			end
			
			if not opt[helvete_index] or opt[helvete_index]._parameters.text_id ~= "menu_difficulty_helvete" then
				local helvete = deep_clone(opt[helvete_index - 1])
				helvete._parameters.text_id = "menu_difficulty_helvete"
				helvete._parameters.value = 9
				table.insert(opt, helvete_index, helvete)
			end
		end
		
		add_options(node:item(item_name)._all_options)
		add_options(node:item(item_name)._options)
	end
end

local filter = MenuCrimeNetFiltersInitiator.modify_node
function MenuCrimeNetFiltersInitiator:modify_node(original_node, data)
	managers.menu:add_difficulty_opt(original_node, "difficulty_filter", 2, 10)
	
	return filter(self, original_node, data)
end

local data = MenuQuickplaySettingsInitiator.modify_node
function MenuQuickplaySettingsInitiator:modify_node(node)
	local node = data(self, node)

	local difficulty = node:item("quickplay_settings_difficulty")
	if difficulty then
		local function add_options(opt)
			if opt[2]._parameters.text_id ~= "menu_difficulty_easy" then
				local easy = deep_clone(opt[2])
				easy._parameters.text_id = "menu_difficulty_easy"
				easy._parameters.value = "easy"
				table.insert(opt, 2, easy)
			end
		end
		
		add_options(difficulty._all_options)
		add_options(difficulty._options)
	end

	return node
end

local filter = MenuCrimeNetContactChillInitiator.modify_node
function MenuCrimeNetContactChillInitiator:modify_node(original_node, data)
	local node = filter(self, original_node, data)

	local difficulty_item = node:item("difficulty")
	if difficulty_item then
		local function add_options(opt)
			if opt[1]._parameters.text_id ~= "menu_difficulty_easy" then
				local easy = deep_clone(opt[1])
				easy._parameters.text_id = "menu_difficulty_easy"
				easy._parameters.value = "easy"
				table.insert(opt, 1, easy)
			end
			
			if not opt[9] or opt[9]._parameters.text_id ~= "menu_difficulty_helvete" then
				local helvete = deep_clone(opt[8])
				helvete._parameters.text_id = "menu_difficulty_helvete"
				helvete._parameters.value = "helvete"
				table.insert(opt, 9, helvete)
			end
		end
		
		add_options(difficulty_item._all_options)
		add_options(difficulty_item._options)
		
		if MenuNodeCrimenetContactChillGui then
			MenuNodeCrimenetContactChillGui:set_difficulty("easy")
		end
	end

	return node
end

local data = MenuCallbackHandler.build_mods_list
function MenuCallbackHandler:build_mods_list()
	local mods = data(self)
	for _, mod in pairs(mods) do
		if mod[1] == "Helvete" then
			mod[1] = mod[1] .. " (Enabled)"
		end
	end

	return mods
end