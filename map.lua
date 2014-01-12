local bit32 = require('bit')
require('tileset')
require('savefountain')
require('watersurface')

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
	self.staticObjects = {}
	self.exits = {}
	self.enemySpawns = {}
	self.name = def.properties.name
	self.cell = {
			x = tonumber(def.properties.cellX),
			y = tonumber(def.properties.cellY),
		}
	for i,v in ipairs(def.tilesets) do -- find util tileset starting
		if v.name:lower() == "utiltileset" then
			self.utiloffset = v.firstgid - 1
		else
			tileset:processTiles(v.tiles or {})
		end
	end
	for i,v in ipairs(def.layers) do
		if v.type:lower() == "objectgroup" then
			self:processObjects(v)		
		elseif v.name:lower() == "collisions" then
			self:processCollisionLayer(v)
		else
			self:processLayer(v)
		end
	end

end

Map.objectProcessors = 
{
	exit = function(map, obj)
		local o = { x = obj.x, y = obj.y, width = obj.width, height = obj.height, target = obj.name }
		table.insert(map.exits,o)
	end,
	enemy = function(map,obj)
		local o = { x = obj.x, y = obj.y - 16, type = obj.name, props = obj.properties }
		table.insert(map.enemySpawns, o)
	end,
	save = function(map,obj)
		map.saveRoom = true
		table.insert(map.staticObjects, SaveFountain(obj.x,obj.y))
	end,
	water = function(map,obj)
		local o = Water(obj.x,obj.y,obj.width,obj.height)
		table.insert(map.staticObjects, o)
	end
	
}

function Map:getCellCoverage()
	return self.width / 20, self.height / 10
end

function Map:getCells()
	local cells = {}
	local w,h = self:getCellCoverage()
	for x=self.cell.x, self.cell.x + (w - 1) do
		for y = self.cell.y, self.cell.y + (h - 1) do
			table.insert(cells, {x,y})
		end
	end
	return cells
end

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
	self:attachObject(player)
	for i,v in ipairs(self.staticObjects) do
		self:attachObject(v)
	end
	self:spawnEnemies()
end

function Map:processObjects(layer)
	for i,v in ipairs(layer.objects) do
		self.objectProcessors[v.type:lower()](self, v)
	end
	table.insert(self.layers, {type = "objectlayer"})
end

function Map:attachObject(obj)
	self.objects[obj] = obj
	obj.map = self
end

function Map:getObjectsAt(x,y)
	local o = {}
	for i,v in pairs(self.objects) do
		if v:contains(x,y) then
			o[v] = v
			table.insert(o,v)
		end
	end
	return o
end

function Map:detachObject(obj)
	self.objects[obj] = nil
end

function Map:processLayer(layer)
	local l = {}
	l.name = layer.name:lower()
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

function Map:sane( x,y )
	return x >= 0 and x < self.width and y >= 0 and y < self.height
end

function Map:isWater(x,y)
	return self.layers["water"] and self.layers["water"].data[x] and self.layers["water"].data[x][y] > 0
end

function Map:processCollisionLayer(layer)
	local l = {}
	local i = 1
	for y=0,layer.height - 1 do
		for x=0,layer.width - 1 do
			l[x] = l[x] or {}
			l[x][y] = math.max(layer.data[i] - self.utiloffset,0)
			i = i + 1
		end
	end
	self.collisionLayer = l
	self:processExits()
end

function Map:processExits()
	local exits = {}
	
	exits.left = {}
	for y=0,self.height-1 do
		if self:tileType(0,y) ~= "solid" then
			exits.left[math.floor(y/10)] = true
		end
	end
		
	exits.right = {}
	for y=0,self.height-1 do
		if self:tileType(self.width - 1,y) ~= "solid" then
			exits.right[math.floor(y/10)] = true
		end
	end
	
	exits.top = {}
	for x=0,self.width-1 do
		if self:tileType(x,0) ~= "solid" then
			print(self.cell.x, self.cell.y, self:tileType(x,0))
			exits.top[math.floor(x/20)] = true
		end
	end
	
	exits.bottom = {}
	for x=0,self.width-1 do
		if self:tileType(x,self.height - 1) ~= "solid" then
			exits.bottom[math.floor(x/20)] = true
		end
	end
	self.exits = exits
end

function Map:checkCollisions()
	local collisions = {}
	for i,v in pairs(self.objects) do
		for ii,vv in pairs(self.objects) do
			if v ~= vv and v.solid and vv.solid then
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
	local toDraw = {}
	for i,v in pairs(self.objects) do
		table.insert(toDraw,v)
	end
	table.sort(toDraw, function(a,b)
			return a.id < b.id
		end)
	for i,v in ripairs(toDraw) do
		v:draw()
	end	

end

function Map:draw(lowerX, lowerY, upperX, upperY)
	lowerX = lowerX or 0
	lowerY = lowerY or 0
	upperX = upperX or self.width - 1
	upperY = upperY or self.height - 1
	love.graphics.setBackgroundColor(self.backgroundColor)
	love.graphics.clear()
	for _,layer in ipairs(self.layers) do -- TODO should probs do this in a sprite batch
		if layer.type == "tilelayer" then
			love.graphics.setColor(255,255,255)
			for x=lowerX, upperX do
				for y=lowerY, upperY do
					local tile = layer.data[x][y]
					local flippedHoriz = bit32.band(tile, FLIPPED_HORIZONTALLY_FLAG) == -2147483648 -- lua numbers are signed so using the sign bit is a problem
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
