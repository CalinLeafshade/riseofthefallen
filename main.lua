
Class = require('middleclass')

Scale = 3

require('util')
require('input')
require('world')
require('map')
require('mapobject')
require('state')
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
	state = State(160,50,16,16)
end

function love.update(dt)
	player.ax = 0
	if Input:isDown("left") then
		player.ax = player.onGround and -30 or -10
	elseif Input:isDown("right") then
		player.ax = player.onGround and 30 or 10
	end
	if Input:isNew("jump") then
		if Input:isDown("down") then
			player:drop()
		else
			player:jump()
		end
	end
	if Input:isNew("attack") then
		player:attack()
	end
	world:update(dt)
	Input:update()
	state:update(dt)
end

function love.keypressed(key)
	if key == "q" then
		love.event.push("quit")
	elseif key == "m" then
		world.showMiniMap = not world.showMiniMap
	end

end

function love.draw()
	love.graphics.setCanvas(mainCanvas)
	world:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.setCanvas()
	love.graphics.draw(mainCanvas,0,0,0, Scale,Scale)
end
