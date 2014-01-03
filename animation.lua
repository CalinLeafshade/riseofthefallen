--animation
Animation = Class("Animation")

function Animation:initialize(filename, count, opts)
    o = opts or {}
	for i,v in pairs(o) do
		self[i] = v
	end
	if type(filename) == "string" then
		self.image = love.graphics.newImage(filename)
	else
		self.image = filename
	end
	
    self.count = count
    self.width = self.image:getWidth() / count
    self.height = self.image:getHeight()
	self.offset = self.offset or {math.floor(self.width / 2), math.floor(self.height)}
	if type(self.offset) == "string" then self:processOffset() end
    self.frame = 1
    self.counter = 0
    self.flipped = self.flipped == nil and false or self.flipped
    self.loop = self.loop == nil and true or self.loop
    self.speed = self.speed or 0.1
    self.delays = self.delays or {}
    self:genQuads()
end

function Animation:processOffset()
	local o = {math.floor(self.width /2), math.floor(self.height / 2)}
	if self.offset:find("left") then
		o[1] = 0
	elseif self.offset:find("right") then
		o[1] = self.width
	end
	if self.offset:find("top") then
		o[2] = 0
	elseif self.offset:find("bottom") then
		o[2] = self.height
	end
	self.offset = o
end

function Animation:clone()
	return animation(self.image, self.count) -- TODO MAKE THIS BETTER
end

function Animation:reset()
    self.frame = 1
    self.counter = 0
end

function Animation:getWidth()
	return self.width
end

function Animation:getHeight()
	return self.height
end

function Animation:genQuads()
    self.quads = {}
    for i = 1, self.count + 1 do
        self.quads[i] = love.graphics.newQuad((i-1) * self.width, 0, self.width, self.height, self.image:getWidth(), self.image:getHeight())
    end
end

function Animation:advance()
    if self.frame == self.count then 
        if self.loop then self.frame = 1 end
		if self.onComplete then
			self:onComplete()
		end
        return "complete"
    else
        self.frame = self.frame + 1
        return "frame"
    end
end

function Animation:update(dt)
    self.counter = self.counter + dt
    if self.counter > self.speed + (self.delays[self.frame] or 0) then
        self.counter = self.counter - (self.speed + (self.delays[self.frame] or 0))
        return self:advance()
    end
    return "nochange"
end

function Animation:getHeight()
	return (self.scale or 1) * self.height
end


function Animation:draw(x,y, scale)
	scale = scale or 1
	self.scale = scale
    if self.frame > self.count then self.frame = 1 end
    local flip = self.flipped and -1 or 1
	x,y = math.floor(x), math.floor(y)
	
    love.graphics.draw(self.image, self.quads[self.frame], x, y,0,flip * scale, scale,self.offset[1], self.offset[2])
end

