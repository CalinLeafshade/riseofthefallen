local bit32 = require('bit')
require('tileset')

Map = Class('map')

FLIPPED_HORIZONTALLY_FLAG = 0x80000000
FLIPPED_VERTICALLY_FLAG   = 0x40000000
FLIPPED_DIAGONALLY_FLAG   = 0x20000000

local tileTypes = 
{
	"solid", "up", "rightslope", "leftslope", [0] = "empty"
}

local tileset = Tileset("gfx/tileset.png",16,16)

function Map:initialize(def)
	if type(def) == "string" then
		def = love.filesystem.load(def)()
	end
	self.tileWidth = def.tilewidth
	self.tileHeight = def.tileheight
	self.width = def.width
	self.height = def.height
	self.layers = {}
	self.backgroundColor = {20,12,28}
	self.objects = {}
	self.exits = {}
	self.enemySpawns = {}
	for i,v in ipairs(def.layers) do
		if v.type == "objectgroup" then
			self:processObjects(v)		
		elseif v.name == "Collisions" then
			self:processCollisionLayer(v)
		else
			self:processLayer(v)
		end
	end
end

Map.objectProcessors = 
{
	Exit = function(map, obj)
		local o = { x = obj.x, y = obj.y, width = obj.width, height = obj.height, target = obj.name }
		table.insert(map.exits,o)
	end,
	Enemy = function(map,obj)
		local o = { x = obj.x, y = obj.y - 16, type = obj.name, props = obj.properties }
		table.insert(map.enemySpawns, o)
	end,
	
}

function Map:spawnEnemies()
	for i,v in ipairs(self.enemySpawns) do
		print("spawned " .. v.type)
		local o = Enemies[v.type](v.x,v.y,v.props or {})
		self:attachObject(o)
		o:wake()
	end
end

function Map:enter()
	self.objects = {}
	self:attachObject(Player)
	self:spawnEnemies()
end

function Map:processObjects(layer)
	for i,v in ipairs(layer.objects) do
		self.objectProcessors[v.type](self, v)
	end
	table.insert(self.layers, {type = "objectlayer"})
end

function Map:attachObject(obj)
	self.objects[obj] = obj
	obj.map = self
end

function Map:detachObject(obj)
	self.objects[obj] = nil
end

function Map:processLayer(layer)
	local l = {}
	l.name = layer.name
	l.opacity = layer.opacity
	l.width = layer.width
	l.height = layer.height
	l.type = "tilelayer"
	local i = 1
	l.data = {}
	for y=0,l.height - 1 do
		for x=0,l.width - 1 do
			l.data[x] = l.data[x] or {}
			l.data[x][y] = layer.data[i]
			i = i + 1
		end
	end
	self.layers[l.name] = l
	table.insert(self.layers, l)
end

function Map:processCollisionLayer(layer)
	local l = {}
	local i = 1
	for y=0,layer.height - 1 do
		for x=0,layer.width - 1 do
			l[x] = l[x] or {}
			l[x][y] = math.max(layer.data[i] - 90,0)
			i = i + 1
		end
	end
	self.collisionLayer = l
end

function Map:checkCollisions()
	local collisions = {}
	for i,v in pairs(self.objects) do
		for ii,vv in pairs(self.objects) do
			if v ~= vv then
				local x1,y1,w1,h1 = v:bounds()
				local x2,y2,w2,h2 = vv:bounds()
				if boxesIntersect(x1,y1,w1,h1,x2,y2,w2,h2) then
					local area,dx,dy = getOverlapAndDisplacementVector(x1,y1,w1,h1,x1 + w1/2, y1 + h1/2, x2,y2,w2,h2, x2 + w2 / 2, y2 + h2 / 2)
					v:collide(vv,dx,dy)
					vv:collide(v,-dx,-dy)
				end
			end
		end
	end
end

function Map:update(dt)
	for i,v in pairs(self.objects) do
		v:update(dt)
	end	
	self:checkCollisions()
end

function Map:tileType(x,y)
	return tileTypes[(self.collisionLayer[x] and self.collisionLayer[x][y]) and self.collisionLayer[x][y] or 0]
end

function Map:drawObjects()
	for i,v in pairs(self.objects) do
		v:draw()
	end	
	Player:draw()
end

function Map:draw(lowerX, lowerY, upperX, upperY)
	lowerX = lowerX or 0
	lowerY = lowerY or 0
	upperX = upperX or self.width - 1
	upperY = upperY or self.height - 1
	love.graphics.setBackgroundColor(self.backgroundColor)
	love.graphics.clear()
	for _,layer in ipairs(self.layers) do
		if layer.type == "tilelayer" then
			for x=lowerX, upperX do
				for y=lowerY, upperY do
					local tile = layer.data[x][y]
					local flippedHoriz = bit32.band(tile, FLIPPED_HORIZONTALLY_FLAG) == -2147483648
					local flippedVert = bit32.band(tile, FLIPPED_VERTICALLY_FLAG) == FLIPPED_VERTICALLY_FLAG
					local flippedDiag = bit32.band(tile, FLIPPED_DIAGONALLY_FLAG) == FLIPPED_DIAGONALLY_FLAG
					local sx,sy = 1,1
					local rot
					if flippedDiag then
						rot = true
					end
					if flippedHoriz then
						sx = -1					
					end
					if flippedVert then
						sy = -1
					end
					if rot then
						sx, sy = -sy, sx
					end
					tile = bit32.band(tile, bit32.bnot(bit32.bor(FLIPPED_HORIZONTALLY_FLAG, FLIPPED_DIAGONALLY_FLAG, FLIPPED_VERTICALLY_FLAG)))
					tileset:draw(tile,x * self.tileWidth, y * self.tileHeight,rot and math.pi * 1.5 or 0,sx,sy)
				end
			end
		else
			self:drawObjects()
		end
	end
end
