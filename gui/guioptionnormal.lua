
require('gui.guioption')

GUIOptionNormal = Class("GUIOptionNormal", GuiOption)

local font = love.graphics.newFont("fonts/betterpixels.ttf", 16)

function GUIOptionNormal:initialize()
	self.font = font
end

function GUIOptionNormal:onSelect() end

function GUIOptionNormal:receiveInput(input)
	if input == "select" then
		self:onSelect()
	end
end

function GUIOptionNormal:draw(x,y,isSelected)
	love.graphics.setFont(self.font)
	local c = isSelected and {255,255,255} or {128,128,128}
	love.graphics.setColor(c)
	local t = self.text or ""
	local w = self.font:getWidth(t)
	love.graphics.print(t, x - w / 2, y)
	return w, self.font:getHeight()
end