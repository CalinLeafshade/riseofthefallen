
Portraits = {}

local files = love.filesystem.getDirectoryItems("gfx/portraits")

for i,v in ipairs(files) do
	local k = v:match("%w+")
	print("loaded portrait for " .. k)
	Portraits[k] = love.graphics.newImage("gfx/portraits/" .. v)
end