
require('gui.ninepatch')

GUI = Class("GUI")

local patch = NinePatch("gfx/gui/border.png", 8)
local selector = love.graphics.newImage("gfx/gui/selector.png")

function GUI:initialize(x,y,w,h,def)
	def = def or {}
	self.x = x or 0
	self.y = y or 0
	self.width = w or 100
	self.height = h or 100
	self.visible = true
	self.selector = selector
	for i,v in pairs(def) do
		self[i] = v
	end
	self.options = {}
end

function GUI:select(optNumber)
	self.selected = optNumber
end

function GUI:addOption(o)
	o.gui = self
	table.insert(self.options, o)
	self.selected = 1
end

function GUI:receiveInput(input)
	if #self.options == 0 then return end
	if input == "down" then
		self.selected = clamp(self.selected + 1,1,#self.options)
		self.options[self.selected]:onFocus()
	elseif input == "up" then
		self.selected = clamp(self.selected - 1,1,#self.options)
		self.options[self.selected]:onFocus()
	elseif self.options[self.selected] then
		self.options[self.selected]:receiveInput(input)
	end
end

function GUI:drawSelector(x,y)
	love.graphics.draw(self.selector,x,y,0,1,1,self.selector:getWidth(), self.selector:getHeight() / 2)
end

function GUI:blur( ... )
	-- body
end

function GUI:focus( ... )
	-- body
end

function GUI:update( ... )
	-- body
end

function GUI:draw()
	love.graphics.setColor(0,0,0,128)
	patch:draw(self.x + 2,self.y + 2,self.width, self.height)
	love.graphics.setColor(255,255,255)
	patch:draw(self.x,self.y,self.width, self.height)
	local x = self.x + 4
	local y = self.y + 10
	for i,v in ipairs(self.options) do
		local xx,yy = v:draw(x,y,self.selected == i, self.isActive)
		y = y + yy + 5
	end
end
