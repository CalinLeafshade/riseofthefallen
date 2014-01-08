
require('gui.ninepatch')

GUI = Class("GUI")

local patch = NinePatch("gfx/gui/border.png", 8)

function GUI:initialize(x,y,w,h)
	self.x = x or 0
	self.y = y or 0
	self.width = w or 100
	self.height = h or 100
	self.options = {}
end

function GUI:select(optNumber)
	self.selected = optNumber
end

function GUI:addOption(o)
	table.insert(self.options, o)
	self.selected = 1
end

function GUI:receiveInput(input)
	if input == "down" then
		self.selected = clamp(self.selected + 1,1,#self.options)
	elseif input == "up" then
		self.selected = clamp(self.selected - 1,1,#self.options)
	elseif self.options[self.selected] then
		self.options[self.selected]:receiveInput(input)
	end
end

function GUI:draw()
	love.graphics.setColor(0,0,0,128)
	patch:draw(self.x + 2,self.y + 2,self.width, self.height)
	love.graphics.setColor(255,255,255)
	patch:draw(self.x,self.y,self.width, self.height)
	local x = self.x + self.width / 2
	local y = self.y + 10
	for i,v in ipairs(self.options) do
		local xx,yy = v:draw(x,y,self.selected == i)
		y = y + yy + 5
	end
end
