--[[
Copyright (c) 2010-2013 Matthias Richter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

Except as contained in this notice, the name(s) of the above copyright holders
shall not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

local _PATH = (...):match('^(.*[%./])[^%.%/]+$') or ''
local cos, sin = math.cos, math.sin

local camera = {}
camera.__index = camera

local function new(x,y, zoom, rot, w, h)
	w = w or 320
	h = h or 160
	x,y  = x or w/2, y or h/2
	zoom = zoom or 1
	rot  = rot or 0
	local bounds = { 0,0,math.huge, math.huge} 
	return setmetatable({x = x, y = y, scale = zoom, rot = rot, width = w, height = h, bounds = bounds}, camera)
end

function camera:setBounds(x,y,w,h)
	self.bounds = {x,y,w,h}
end

function camera:lookAt(x,y)
	self.x, self.y = clamp(x,self.bounds[1] + self.width / 2, self.bounds[3] - self.width / 2),clamp(y, self.bounds[2] + self.height / 2, self.bounds[4] - self.height / 2)
	return self
end

function camera:move(x,y)
	self.x, self.y = clamp(self.x + x, self.bounds[1] + self.width / 2, self.bounds[3] - self.width / 2), clamp(self.y + y, self.bounds[2] + self.height /2, self.bounds[4] - self.height / 2)
	return self
end

function camera:pos()
	return self.x, self.y
end

function camera:rotate(phi)
	self.rot = self.rot + phi
	return self
end

function camera:rotateTo(phi)
	self.rot = phi
	return self
end

function camera:zoom(mul)
	self.scale = self.scale * mul
	return self
end

function camera:zoomTo(zoom)
	self.scale = zoom
	return self
end

function camera:attach()
	local cx,cy = self.width/(2*self.scale), self.height/(2*self.scale)
	love.graphics.push()
	love.graphics.scale(self.scale)
	love.graphics.translate(round(cx), round(cy))
	love.graphics.rotate(self.rot)
	love.graphics.translate(round(-self.x), round(-self.y))
end

function camera:detach()
	love.graphics.pop()
end

function camera:draw(func)
	self:attach()
	func()
	self:detach()
end

function camera:cameraCoords(x,y)
	-- x,y = ((x,y) - (self.x, self.y)):rotated(self.rot) * self.scale + center
	local w,h = self.width, self.height
	local c,s = cos(self.rot), sin(self.rot)
	x,y = x - self.x, y - self.y
	x,y = c*x - s*y, s*x + c*y
	return x*self.scale + w/2, y*self.scale + h/2
end

function camera:worldCoords(x,y)
	-- x,y = (((x,y) - center) / self.scale):rotated(-self.rot) + (self.x,self.y)
	local w,h = self.width, self.height
	local c,s = cos(-self.rot), sin(-self.rot)
	x,y = (x - w/2) / self.scale, (y - h/2) / self.scale
	x,y = c*x - s*y, s*x + c*y
	return x+self.x, y+self.y
end

function camera:mousepos()
	return self:worldCoords(love.mouse.getPosition())
end

-- the module
return setmetatable({new = new},
	{__call = function(_, ...) return new(...) end})
