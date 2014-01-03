
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
	self.health = 20
	self.solid = true
	self.weaknesses = {}
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

function MapObject:getPosition()
	return self.x,self.y
end

function MapObject:getSize()
	return self:getWidth(), self:getHeight()
end

function MapObject:bbox()
	return self.x, self.y, self.x + self:getWidth(), self.y + self:getHeight()
end

function MapObject:getCenter()
	local x,y = self:getPosition()
	return x + self:getWidth() / 2, y + self:getHeight() / 2
end

function MapObject:LeaveEdge(edge)
	
end

function MapObject:setState(state,...)
	assert(self.states[state], "no state with that name")
	if self.states[self.state] and self.states[self.state].leave then
		self.states[self.state].leave(self,...)
	end
	self.state = state
	if self.states[state].set then
		self.states[state].set(self,...)
	end
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

function MapObject:contains(x,y)
	return contains(x,y,self:bounds())
end

function MapObject:bounds()
	return self.x,self.y,self:getWidth(), self:getHeight()
end

function MapObject:draw()
	if self.sprite then
		local c = self.color or {255,255,255}
		c[4] = self.alpha or 255
		love.graphics.setColor(c)
		love.graphics.draw(self.sprite,math.floor(self.x + self:getWidth() / 2) , math.floor(self.y + self:getHeight() / 2), self.rotation or 0, self.scale or 1,self.scale or 1,self:getWidth() / 2, self:getHeight() / 2)
	elseif self.animation then
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
	
end

function MapObject:hurt(pwr,dx,dy, dmgType)
	dmgType = dmgType or "normal"
	local multiplier = self.weaknesses[dmgType] or 1
	pwr = pwr * multiplier
	local x = self:getCenter()
	local y = self.y
	Bubble(x,y - 15,pwr,{200,0,0})
	self.health = self.health - pwr
	self:setState("hurt",dx,dy,dmgType)
	if self.health <= 0 then
		self.health = 0
		self:die()
	end
end

function MapObject:die()
	local x1,y1,x2,y2 = self:bbox()
	local p = math.abs((x2 - x1) * (y2 - y1))
	local cx,cy = self:getCenter()
	local w,h = self:getSize()
	for i=1,p / 10 do
		Smoke(cx + math.random(-w/2,w/2) * (math.random() * math.random()),cy + math.random(-h/ 2,h/2) * (math.random() * math.random()))
	end
	self.map:detachObject(self)
end

function MapObject:bottom()
	return self.y + self:getHeight()
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
	
	if self.solid then
		self:move(dt)
	else
		self.x = self.x + self.vx * dt
		self.y = self.y + self.vy * dt
	end
	self:checkEdges()
end

function MapObject:getCell()
	local x,y = self:getCenter()
	local m = self.map
	local cx,cy = m.cell.x,m.cell.y
	return cx + math.floor(x / 320), cy + math.floor(y / 160)
end

function MapObject:leaveEdge() end

function MapObject:checkEdges()
	local x,y = self:getCenter()
	local w,h = self.map.width * 16, self.map.height * 16
	if x < 0 then
		self:leaveEdge("left")
	elseif x > w then
		self:leaveEdge("right")
	elseif y < 0 then
		self:leaveEdge("top")
	elseif y > h then
		self:leaveEdge("bottom")
	end
end

function MapObject:setCenter(x,y)
	local w,h = self:getSize()
	self.x, self.y = x - w / 2, y - h / 2
end

function MapObject:applyFriction()
	if self.ax ~= 0 then return end
	local f = self.onGround and 0.8 or 0.999
	self.vx = self.vx * f
end

function MapObject:hitWall(dir)
	
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
			self:hitWall(vx < 0 and "left" or "right")
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
		if t == "solid" or (t == "up" and vy > 0) and self:bottom() <= ty * 16 then 
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