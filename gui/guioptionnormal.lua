
require('gui.guioption')

GUIOptionNormal = Class("GUIOptionNormal", GuiOption)

local font = love.graphics.newFont("fonts/betterpixels.ttf", 16)

function GUIOptionNormal:initialize(opts)
	self.font = font
	for i,v in ipairs(opts or {}) do
		self[i] = v
	end
end

function GUIOptionNormal:onFocus() end

function GUIOptionNormal:onSelect() end

function GUIOptionNormal:receiveInput(input)
	if input == "select" then
		self:onSelect()
	end
end

function GUIOptionNormal:draw(x,y,isSelected,showSelector)
	love.graphics.setFont(self.font)
	local c = isSelected and {255,255,255} or {128,128,128}
	love.graphics.setColor(c)
	local t = self.text or ""
	local w = self.font:getWidth(t)

	love.graphics.print(t, x + 12, y)
	if showSelector and isSelected then
		love.graphics.draw(self.gui.selector,x + 12, y + self.font:getHeight() / 2,0,1,1,self.gui.selector:getWidth(), self.gui.selector:getHeight() / 2)
	end
	return w, self.font:getHeight()
end