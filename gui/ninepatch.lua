
NinePatch = Class("NinePatch")

function NinePatch:initialize(image,cornerSize)
	if type(image) == "string" then
		image = love.graphics.newImage(image)
	end
	self.image = image
	self.cornerSize = cornerSize
	self:generateQuads()
end

function NinePatch:generateQuads()
	local quads = {}
	local c = self.cornerSize
	local iw = self.image:getWidth()
	local ih = self.image:getHeight()
	quads.topLeft = love.graphics.newQuad(0,0,c,c,iw,ih)
	quads.topRight = love.graphics.newQuad(iw - c,0,c,c,iw,ih)
	quads.bottomLeft = love.graphics.newQuad(0,ih - c,c,c,iw,ih)
	quads.bottomRight = love.graphics.newQuad(iw - c, ih - c,c,c,iw,ih)
	quads.top = love.graphics.newQuad(c,0,iw - c * 2, c, iw,ih)
	quads.bottom = love.graphics.newQuad(c, ih - c, iw - c * 2, c, iw, ih)
	quads.left = love.graphics.newQuad(0,c,c,ih - c * 2, iw,ih)
	quads.right = love.graphics.newQuad(iw - c, c, c, ih - c * 2, iw, ih)
	quads.center = love.graphics.newQuad(c,c,iw - c * 2, ih - c * 2, iw, ih)
	self.quads = quads
end

function NinePatch:draw(x,y,w,h)
	local lg = love.graphics
	local quads = self.quads
	local c = self.cornerSize
	local _,_,ww = quads.top:getViewport()
	local wScale = (w - c * 2) / (self.image:getWidth() - c * 2)
	local hScale = (h - c * 2) / (self.image:getHeight() - c * 2)
	local iw = self.image:getWidth()
	local ih = self.image:getWidth()
	
	lg.draw(self.image, quads.topLeft, x,y)
	lg.draw(self.image, quads.top, x + c, y, 0, wScale, 1)
	lg.draw(self.image, quads.topRight, (x + w) - c, y)
	
	lg.draw(self.image, quads.left, x, y + c, 0, 1, hScale)
	lg.draw(self.image, quads.bottomLeft, x, y + h - c)
	lg.draw(self.image, quads.bottom, x + c, y + h - c, 0, wScale, 1)
	lg.draw(self.image, quads.bottomRight, x + w - c, y + h - c)
	lg.draw(self.image, quads.right, x + w - c, y + c, 0, 1, hScale)
	lg.draw(self.image, quads.center, x + c, y + c, 0, wScale, hScale)
end