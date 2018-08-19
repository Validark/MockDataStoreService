-- An implementation of DataStoreService in Lua for use in Studio
-- @documentation https://github.com/buildthomas/MockDataStoreService/blob/master/README.md
-- @author buildthomas

--[[
		This module decides whether to use actual datastores or mock datastores depending on the environment.

		This module is licensed under APLv2, refer to the LICENSE file or:
		https://github.com/buildthomas/MockDataStoreService/blob/master/LICENSE
]]

local MockDataStoreServiceModule = script.MockDataStoreService

local shouldUseMock = false
if game.GameId == 0 then -- Local place file
	shouldUseMock = true
elseif game:GetService("RunService"):IsStudio() then -- Published file in Studio
	local status, message = pcall(function()
		-- This will error if current instance has no Studio API access:
		game:GetService("DataStoreService"):GetDataStore("__TEST"):UpdateAsync("__TEST", function(...) return ... end)
	end)
	if not status and (message:lower():find("api access") or message:lower():find("http 403")) then -- HACK
		-- Can connect to datastores, but no API access
		shouldUseMock = true
	end
end

-- Return the mock or actual service depending on environment:
if shouldUseMock then
	warn("INFO: Using MockDataStoreService instead of DataStoreService")
	return require(MockDataStoreServiceModule)
else
	return game:GetService("DataStoreService")
end
