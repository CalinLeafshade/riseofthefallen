
Tileset = Class("tileset")

function Tileset:initialize(image, tileWidth, tileHeight)
	if type(image) == "string" then
		image = love.graphics.newImage(image)
	end
	self.image = image
	self.tileWidth = tileWidth
	self.tileHeight = tileHeight
	local w,h = image:getWidth(), image:getHeight()
	local i = 1
	self.quads = {}
	for y=0,h - 1,tileHeight do
		for x=0,w - 1,tileWidth do
			self.quads[i] = love.graphics.newQuad(x,y,tileWidth,tileHeight,w,h)
			i = i + 1
		end
	end
	self.animations = {}
end

function Tileset:processTiles(tiles)
	for i,v in ipairs(tiles) do
		if v.properties.animation then
			self.animations[v.id + 1] = tonumber(v.properties.animation)
		end
	end
end

function Tileset:draw(tileID,x,y,r,sx,sy)
	
	if self.animations[tileID] then
		tileID = tileID + round(love.timer.getTime() * 10) % self.animations[tileID] 
	end
	if self.quads[tileID] then
		love.graphics.draw(self.image, self.quads[tileID], x + self.tileWidth / 2, y + self.tileHeight / 2,r,sx,sy, self.tileWidth / 2, self.tileHeight / 2)
	end
end