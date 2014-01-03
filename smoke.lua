
Smoke = Class("Smoke", MapObject)

local smokeSprite = love.graphics.newImage("gfx/smoke.png")
smokeSprite:setFilter("nearest","nearest")

function Smoke:initialize(x,y)
	MapObject.initialize(self,x,y)
	self.solid = false
	local g = math.random(100,200)
	self.color = {g,g,g}
	self.alpha = 100
	self.fadeSpeed = 70 + math.random(60)
	self.rotation = math.random() * math.pi * 2
	self.rotSpeed = math.random() * math.pi
	self.vy = -math.random() * 30
	self.scale = math.random()
	self.sprite = smokeSprite
	self.gravity = false
	Player.map:attachObject(self) -- always attack to players map
end

function Smoke:update(dt)
	MapObject.update(self,dt)
	self.scale = clamp(self.scale - dt / 2,0,1)
	self.alpha = self.alpha - dt * self.fadeSpeed
	self.rotation = self.rotation + self.rotSpeed * dt
	if self.alpha <= 0 then
		self.map:detachObject(self)
	end
end