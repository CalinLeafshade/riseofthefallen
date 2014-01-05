
Class = require('middleclass')

Scale = 3

require('logger')
require('util')
require('input')
require('world')
require('map')
require('mapobject')
require('savestate')
require('enemy')
require('bubble')
require('smoke')
require('gui')
require('statemanager')
require('mainstate')
require('mapstate')

local currentMap
local mainCanvas

function love.load()
	love.window.setMode(320 * Scale, 180 * Scale, {vsync = true})
	mainCanvas = love.graphics.newCanvas(320,180)
	mainCanvas:setFilter("nearest", "nearest")
	stateManager = StateManager()
	stateManager:push(MainState)
	world = World("maps")
	savestate = SaveState(160,50,16,16)
end

function love.update(dt)
	stateManager:update(dt)
	Input:update()
	Logger:update(dt)
end

function love.keypressed(key)
	if key == "q" then
		love.event.push("quit")
	elseif key == "l" then
		savestate = SaveState.loadFromSlot(1)
	end

end

function love.draw()
	love.graphics.setCanvas(mainCanvas)
	stateManager:draw()
	love.graphics.setColor(255,255,255)
	love.graphics.setCanvas()
	love.graphics.draw(mainCanvas,0,0,0, Scale,Scale)
	Logger:draw()
end
