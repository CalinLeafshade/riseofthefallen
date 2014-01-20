
-- state loader

local files = love.filesystem.getDirectoryItems("states")

for i,v in ipairs(files) do
	if v ~= "init.lua" then
		love.filesystem.load("states/" .. v)()
		print("Loaded state from: " .. v)
	end
end