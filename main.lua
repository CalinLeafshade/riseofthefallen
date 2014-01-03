
Class = require('middleclass')

Scale = 3

require('util')
require('input')
require('world')
require('map')
require('mapobject')
require('player')
require('enemy')
require('bubble')
require('smoke')

local currentMap
local mainCanvas

function love.load()
	love.window.setMode(320 * Scale, 180 * Scale)
	mainCanvas = love.graphics.newCanvas(320,180)
	mainCanvas:setFilter("nearest", "nearest")
	world = World("maps")
	world:changeMap(16,16)
end

function love.update(dt)
	Player.ax = 0
	if Input:isDown("left") then
		Player.ax = Player.onGround and -30 or -10
	elseif Input:isDown("right") then
		Player.ax = Player.onGround and 30 or 10
	end
	if Input:isNew("jump") then
		Player:jump()
	end
	if Input:isNew("attack") then
		Player:attack()
	end
	world:update(dt)
	Input:update()
end

function love.keypressed(key)
	if key == "q" then
		love.event.push("quit")
	end

end

function love.draw()
	love.graphics.setCanvas(mainCanvas)
	world:draw()
	love.graphics.setCanvas()
	love.graphics.draw(mainCanvas,0,0,0, Scale,Scale)
end
