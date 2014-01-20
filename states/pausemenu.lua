
require('gui.gui')
require('gui.guioptionnormal')

PauseState = State("PauseState")

local gui = GUI(130,20,60,70)

local resume = GUIOptionNormal()
resume.text = "Resume"
resume.onSelect = function(self) stateManager:pop() end

local options = GUIOptionNormal()
options.text = "Options"

local quit = GUIOptionNormal()
quit.text = "Quit"
quit.onSelect = function(self) love.event.push("quit") end

gui:addOption(resume)
gui:addOption(options)
gui:addOption(quit)



PauseState.gui = gui

PauseState.opaque = false

local acceptedInput = {"up","down","left","right","select"}

function PauseState:focus()
	self.gui:select(1)
end

function PauseState:update(dt, onTop)
	if not onTop then return end
	if Input:isNew("pause") then
		stateManager:pop()
	end
	for i,v in ipairs(acceptedInput) do
		if Input:isNew(v) then
			gui:receiveInput(v)
		end
	end
end

function PauseState:draw(onTop)
	self.gui:draw()
end