
require('animation')

MapObject = Class("MapObject")

function MapObject:initialize(x,y,props)
	x = x or 0
	y = y or 0
	self.props = props or {}
	self.x = x
	self.y = y
	self.vx = 0
	self.vy = 0
	self.ax = 0
	self.ay = 0
	self.maxLateralSpeed = 100
	self.maxVerticalSpeed = 1000
	self.gravity = true
	self.dir = "right"
	self.state = "idle"
	self.lastHurt = 0
	self.hurtTime = 2
	self.states = {
		idle = {
				set = function() end,
				update = function() end,
				leave = function() end
			}
		}
end

function MapObject:isInvincible()
	return love.timer.getTime() - self.lastHurt < self.hurtTime 
end

function MapObject:getWidth()
	if self.sprite then
		return self.sprite:getWidth()
	else
		return 16
	end
end

function MapObject:getHeight()
	if self.sprite then
		return self.sprite:getHeight()
	else
		return 32
	end
end

function MapObject:getSize()
	return self:getWidth(), self:getHeight()
end

function MapObject:bbox()
	return self.x, self.y, self.x + self:getWidth(), self.y + self:getHeight()
end

function MapObject:setState(state)
	assert(self.states[state], "no state with that name")
	if self.states[self.state] then
		self.states[self.state].leave(self)
	end
	self.state = state
	self.states[state].set(self)
end

function MapObject:getTilesCovered()
	assert(self.map, "Not associated with any map")
	local o = {}
	local x,y,w,h = self:bbox()
	x = math.floor(x / self.map.tileWidth)
	y = math.floor(y / self.map.tileHeight)
	w = math.ceil(w / self.map.tileWidth)
	h = math.ceil(h / self.map.tileHeight)
	for xx = x, w do
		for yy = y, h do
			table.insert(o, {xx,yy})
		end
	end
	return o
end

function MapObject:bounds()
	return self.x,self.y,self:getWidth(), self:getHeight()
end

function MapObject:draw()
	if self.animation then
		if self:isInvincible() then
			love.graphics.setColor(255,255,255,math.sin(love.timer.getTime() * 10) * 64 + 128)
		else
			love.graphics.setColor(255,255,255)
		end
		self.animation:draw(math.floor(self.x + self:getWidth() / 2), math.floor(self.y + self:getHeight()))
		love.graphics.setColor(255,255,255)
	else
		love.graphics.rectangle("line", self:bounds())
	end
end

function MapObject:collide(with)
	print("collision")
end

function MapObject:hurt(pwr)
	
end

function MapObject:update(dt)
	if self.states[self.state] then
		self.states[self.state].update(self,dt)
	end
	if self.ax < 0 then
		self.dir = "left"
	elseif self.ax > 0 then
		self.dir = "right"
	end
	self.vx = self.vx + self.ax
	self.vy = self.vy + self.ay
	self.vx = clamp(self.vx, -self.maxLateralSpeed, self.maxLateralSpeed)
	self.vy = clamp(self.vy, -self.maxVerticalSpeed, self.maxVerticalSpeed)
	if self.animation then
		self.animation.flipped = self.dir == "left"
	end
	if self.friction then self:applyFriction() end
	
	self:move(dt)
end

function MapObject:applyFriction()
	if self.ax ~= 0 then return end
	local f = self.onGround and 0.8 or 0.999
	self.vx = self.vx * f
end

function MapObject:move(dt)
	local vx,vy = self.vx,self.vy
	if self.gravity then
		self.vy = self.vy + 1000 * dt
	end
	if vx == 0 and vy == 0 then return end
	local futureX, futureY = self.x + vx * dt, self.y + vy * dt
	
	-- x first
	local tx
	if vx < 0 then
		tx = math.floor(futureX / self.map.tileWidth)
	else 
		tx = math.floor((futureX + self:getWidth()) / self.map.tileWidth)
	end
	local topY = math.floor((self.y + 2) / self.map.tileHeight)
	local bottomY = math.floor((self.y - 2 + self:getHeight()) / self.map.tileHeight)
	
	local col = false
	
	for y=topY,bottomY do
		local t = self.map:tileType(tx,y)
		if t == "solid" then -- hit wall
			col = true
			self.vx = 0
			if vx < 0 then
				futureX = tx * self.map.tileWidth + self.map.tileWidth
			else
				futureX = tx * self.map.tileWidth - self:getWidth()
			end
		elseif t == "leftslope" then
			local trans = (clamp(self.x - tx * 16,0,15)) % 16
			local fY = y * self.map.tileHeight - self:getHeight() + trans
			if fY < futureY then
				self.onGround = true
				futureY = fY
			end
		elseif t == "rightslope" then
			local trans = (15 - clamp((self.x + self:getWidth()) - tx * 16,0,15)) % 16
			local fY = y * self.map.tileHeight - self:getHeight() + trans
			if fY < futureY then
				self.onGround = true
				futureY = fY
			end
		end
	end
	
	self.x = futureX
	
	-- y next
	
	local ty
	if vy > 0 then
		ty = math.floor((futureY + self:getHeight()) / self.map.tileHeight)
	else
		ty = math.floor(futureY / self.map.tileHeight)
	end
	local leftX = math.floor((self.x + 2) / self.map.tileWidth)
	local rightX = math.floor((self.x - 2 + self:getWidth()) / self.map.tileWidth)
	
	
	for x=leftX, rightX do
		local t = self.map:tileType(x,ty)
		if t == "solid" then 
			self.vy = 0
			if vy > 0 then -- falling
				self.onGround = true
				futureY = ty * self.map.tileHeight - self:getHeight()
			else -- rising
				futureY = ty * self.map.tileHeight + self.map.tileHeight
			end
		elseif t == "leftslope" then
			local trans = (clamp(self.x - x * 16,0,16)) % 16
			local fY = ty * self.map.tileHeight - self:getHeight() + trans
			if fY < futureY then
				self.vy = 0
				self.onGround = true
				futureY = fY
			end
		elseif t == "rightslope" then
			local trans = (16 - clamp((self.x + self:getWidth()) - x * 16,0,16)) % 16
			local fY = ty * self.map.tileHeight - self:getHeight() + trans
			if fY < futureY then
				self.vy = 0
				self.onGround = true
				futureY = fY
			end
		end
	end
			
	self.y = futureY
			
	
	
end