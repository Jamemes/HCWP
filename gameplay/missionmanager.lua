if not tweak_data.is_helvete then
	return
end

Hooks:PostHook(MissionManager, "init", "HVT_load_zeals_for_helvete", function()
	if PackageManager:package_exists("packages/sm_wish") and not PackageManager:loaded("packages/sm_wish") then
		PackageManager:load("packages/sm_wish")
	end
end)