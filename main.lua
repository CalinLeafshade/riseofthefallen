
Class = require('middleclass')

Scale = 3

require('util')
require('map')
require('mapobject')
require('player')
require('enemy')

local currentMap
local mainCanvas


function love.load()
	love.window.setMode(320 * Scale, 180 * Scale)
	mainCanvas = love.graphics.newCanvas(320,180)
	mainCanvas:setFilter("nearest", "nearest")
	currentMap = Map("maps/map1.lua")
	currentMap:enter()
end

function love.update(dt)
	Player.ax = 0
	if love.keyboard.isDown("left") then
		Player.ax = Player.onGround and -30 or -10
	elseif love.keyboard.isDown("right") then
		Player.ax = Player.onGround and 30 or 10
	end
	currentMap:update(dt)
	
end

function love.keypressed(key)
	if key == "up" then
		Player:jump()
	elseif key == "z" then
		Player:attack()
	end

end

function love.draw()
	love.graphics.setCanvas(mainCanvas)
	currentMap:draw()
	love.graphics.setCanvas()
	love.graphics.draw(mainCanvas,0,0,0, Scale,Scale)
end
