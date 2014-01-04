require('mapobject')

Bubble = Class("Bubble", MapObject)

local font = love.graphics.newFont("fonts/tiny.ttf", 16)
local lg = love.graphics

function Bubble:initialize(x,y,text,color)
	color = color or {255,255,255}
	text = text or ""
	self.x = x
	self.y = y
	self.text = text
	self.color = color
	self.color[4] = 255
	if player.map then -- always attach to active map
		player.map:attachObject(self)
	end
end

function Bubble:update(dt)
	self.y = self.y - dt * 15
	self.color[4] = clamp(self.color[4] - dt * 255,0,255)
	if self.color[4] == 0 then
		self.map:detachObject(self)
	end
end

function Bubble:draw()
	lg.setFont(font)
	printfOutlined(self.text, round(math.sin(love.timer.getTime() * 5) * 2 + self.x - 50), round(self.y), 100, "center", self.color)
end

function Bubble:contains() return false end -- never hit
