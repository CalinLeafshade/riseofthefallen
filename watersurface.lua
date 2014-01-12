
require('mapobject')

Water = Class("Water", MapObject)

function Water:initialize(x,y,width,height)
	MapObject.initialize(self,x,y)
	self.width = width
	self.height = height
	self.static = true
	self.solid = true
	self.overPlayer = true
	self.playerInWater = false
	self.surface = {}
	for i=0,width do
		self.surface[i] = { p = 0, v = 0}
	end
end

function Water:inWater(x,y)
	return contains(x,y,self.x,self.y,self.width,self.height)
end

function Water:getWidth()
	return self.width
end

function Water:getHeight()
	return self.height
end

function Water:collide(with)

end

function Water:updateSurface(dt)
	local k = 0.02
	local d = 0.02
	local spread = 0.4
	local leftDeltas = {}
	local rightDeltas = {}
	local surf = self.surface

	for i,v in ipairs(surf) do
		local a = -k * v.p - d * v.v
		v.v = v.v + a * dt * 100
		v.p = v.p + v.v * dt * 100
	end

	for _=0,1 do
		for i,v in ipairs(surf) do
			if i > 1 then
				leftDeltas[i] = spread * (v.p - surf[i - 1].p)
				surf[i - 1].v = surf[i - 1].v + leftDeltas[i]
			end
			if i < #surf then
				rightDeltas[i] = spread * (v.p - surf[i + 1].p)
				surf[i + 1].v = surf[i + 1].v + rightDeltas[i]
			end
		end
		for i,v in ipairs(surf) do
			if i > 1 then
				surf[i - 1].p = surf[i - 1].p + leftDeltas[i]
			end
			if i < #surf then
				surf[i + 1].p = surf[i + 1].p + rightDeltas[i]
			end
		end
	end
end

function Water:splash(x,y,f)
	local i = round(x - self.x)
	local s = self.surface
	for j=-8,8,1 do
		if s[i + j] then
			s[i + j].v = f * math.random()
		end
	end

	for i=1,math.abs(f)*15 do
		local l = (math.random() - 0.5)
		local y = -math.abs(f) * 50 * math.random()
		self.map:attachObject(Drop(x + l * 16,self.y - 1,l * 100,y))
	end

end

function Water:update(dt)
	local x,y = player:getCenter()
	local b = self:inWater(x,y)
	if b ~= self.playerInWater then
		self.playerInWater = b
		self:splash(x,y,player.vy * 0.01)
		if not b then
			player.wet = 10
		end
	end
	
	self:updateSurface(dt)
	
end

function Water:draw( ... )
	love.graphics.setLineWidth(1)
	love.graphics.setColor(50,60,57,100)
	local surfaceLine = {}
	for i,v in ipairs(self.surface) do
		local x = self.x + i
		local y = self.y + v.p
		table.insert(surfaceLine,x)
		table.insert(surfaceLine,y)
		love.graphics.line(x,y, self.x + i, self.y + self.height)
	end

	
	for i=1,#surfaceLine-2,2 do
		local x,y = surfaceLine[i], surfaceLine[i+1]
		love.graphics.setColor(255,255,255,clamp(10 + math.abs(surfaceLine[i+1] - self.y) * 5,0,255))
		love.graphics.line(x,y,surfaceLine[i+2],surfaceLine[i+3])
	end
	love.graphics.setColor(255,255,255)
end

Drop = Class("Drop", MapObject)

function Drop:initialize(x,y,vx,vy)
	MapObject.initialize(self,x,y)
	self.vx = vx
	self.vy = vy
	local r = math.random(20)
	self.color = {200 + r,220 + r,214 + r,math.random(100,150)}
	self.lengthMod = 0.03
	self.lifetime = 2
end

function Drop:collide(with)
	if (type(with) == "string" and with == "solid") then
		self.hits = (self.hits or 0) + 1
		self.vy = -self.vy
		if self.hits >= 2 then
			self:remove()
		end
	elseif with:isInstanceOf(Water) then
		self:remove()
	end
end

function Drop:getWidth()
	return 3
end

function Drop:getHeight()
	return 1
end

function Drop:update( dt )
	MapObject.update(self,dt)
	self.lifetime = self.lifetime - dt
	if self.lifetime < 0 then
		self:remove()
	end
end

function Drop:draw( ... )
	--self.color[4] = lerp(0,255,self.lifetime/0.2)
	love.graphics.setColor(self.color)
	love.graphics.setLineStyle("rough")
	love.graphics.setLineWidth(3 - clamp(math.abs(self.vy * 0.01),1,2))
	love.graphics.line(self.x,self.y, self.x - clamp(self.vx * self.lengthMod, -2, 2), self.y - clamp(self.vy * self.lengthMod,-2,2))
end