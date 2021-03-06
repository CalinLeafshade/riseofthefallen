
require('animation')

local createdObjects = 0

MapObject = Class("MapObject")

function MapObject:initialize(x,y,props)
	x = x or 0
	y = y or 0
	self.id = createdObjects
	createdObjects = createdObjects + 1
	self.props = props or {}
	self.x = x
	self.y = y
	self.vx = 0
	self.vy = 0
	self.ax = 0
	self.ay = 0
	self.maxLateralSpeed = 100
	self.maxVerticalSpeed = 700
	self.gravity = true
	self.dir = "right"
	self.state = "idle"
	self.lastHurt = 1
	self.hurtTime = 2
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
	local floor = math.floor
	local cx, cy = self:getCenter()
	cx,cy = floor(cx), floor(cy)
	local y = floor(self:bottom())
	local c = self.color or {255,255,255}
	c[4] = self.alpha or 255
	love.graphics.setColor(c)
	if self.sprite then
		love.graphics.draw(self.sprite,cx, cy, self.rotation or 0, self.scale or 1,self.scale or 1,self:getWidth() / 2, self:getHeight() / 2)
	elseif self.animation then
		self.animation:draw(cx, y)
		if self.attachment then
			self.attachment.flipped = self.dir == "left"
			self.attachment:draw(cx, y)
		end
		love.graphics.setColor(255,255,255)
	else
		love.graphics.rectangle("line", self:bounds())
	end
end

function MapObject:collide(with)
	
end

function MapObject:remove()
	self.map:detachObject(self)
end

function MapObject:die()
	self:remove()
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

	local ax = self.ax
	local ay = self.ay
	local maxLSpeed = self.maxLateralSpeed
	local maxVSpeed = self.maxVerticalSpeed
	if self.inWater then
		maxVSpeed = maxVSpeed / 2
		maxLSpeed = maxLSpeed / 2
		ax = ax / 2
		ay = ay / 2
	end
	self.vx = self.vx + ax
	self.vy = self.vy + ay
	self.vx = clamp(self.vx, -maxLSpeed, maxLSpeed)
	self.vy = clamp(self.vy, -maxVSpeed, maxVSpeed)
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

function MapObject:getOverlappingObjects()
	local o = {}
	local x,y,w,h = self:bounds()
	for i,v in pairs(self.map.objects) do
		print(self,v)
		if v ~= self and boxesIntersect(x,y,w,h, v:bounds()) then
			table.insert(o,v)
		end
	end
	return o
end

function MapObject:interact()

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

function MapObject:getState()
	return self.states[self.state] or {}
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
		local g = self.inWater and 200 or 1000
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
				col = true
				self.onGround = true
				futureY = fY
			end
		elseif t == "rightslope" then
			local trans = (15 - clamp((self.x + self:getWidth()) - tx * 16,0,15)) % 16
			local fY = y * self.map.tileHeight - self:getHeight() + trans
			if fY < futureY then
				col = true
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
				col = true
				self.onGround = true
				futureY = ty * self.map.tileHeight - self:getHeight()
			else -- rising
				self:collide("solid")
				futureY = ty * self.map.tileHeight + self.map.tileHeight
			end
		elseif t == "leftslope" then
			local trans = (clamp(self.x - x * 16,0,16)) % 16
			local fY = ty * self.map.tileHeight - self:getHeight() + trans
			if fY < futureY then
				self.vy = 0
				self.onGround = true
				futureY = fY
				col = true
			end
		elseif t == "rightslope" then
			local trans = (16 - clamp((self.x + self:getWidth()) - x * 16,0,16)) % 16
			local fY = ty * self.map.tileHeight - self:getHeight() + trans
			if fY < futureY then
				self.vy = 0
				self.onGround = true
				futureY = fY
				col = true
			end
		end
	end
			
	self.y = futureY
			
	if col then -- we collided
		self:collide("solid")
	end
	
end