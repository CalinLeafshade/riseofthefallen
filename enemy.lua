
Enemy = Class("Enemy", MapObject)

function Enemy:wake()
	
end

Enemies = {}

local enemyDefs = love.filesystem.getDirectoryItems("enemies")

for i,v in ipairs(enemyDefs) do
	love.filesystem.load("enemies/" .. v)()
	print("loaded " .. v)
end