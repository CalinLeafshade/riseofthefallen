
io.stdout:setvbuf("no") -- for debug messages

local lg = love.graphics
local mainCanvas

local function loadlibs( ... )
	Class = require('lib.middleclass')
	require('config')
	require('color')
	require('fonts')
	require('portraits')
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
	require('states')
	require('item')
end

function NewGame()
	world = World("maps")
	savestate = SaveState(160,50,18,17)
end

function LoadGame(slot)
	world = World("maps")
	savestate = SaveState.loadFromSlot(slot)
end

function love.load()
	loadlibs()
	Config:load()
	Config:initialize()
	mainCanvas = lg.newCanvas(320,180)
	mainCanvas:setFilter("nearest", "nearest")
	stateManager = StateManager()
	stateManager:push(MainMenu)
	--world = World("maps")
	--savestate = SaveState(160,50,18,17)
end

function love.update(dt)
	stateManager:update(dt)
	Input:update()
	log("FPS", love.timer.getFPS())
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
	lg.setCanvas(mainCanvas)
	lg.clear()
	stateManager:draw()
	lg.setColor(255,255,255)
	lg.setCanvas()
	lg.draw(mainCanvas,0,0,0, Config.scale,Config.scale)
	Logger:draw()
end
