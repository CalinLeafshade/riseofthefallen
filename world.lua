-- World

Camera = require('hump.camera')

World = Class("World")

function World:loadMaps()
	local files = love.filesystem.getDirectoryItems(self.mapDir)
	for i,v in ipairs(files) do
		if string.endsWith(v, ".lua") then
			local m = Map("maps/" .. v)
			print("Loaded " .. (m.name or "a map"))
			local cells = m:getCells()
			for i,v in ipairs(cells) do
				local x,y = v[1],v[2]
				self.cells[x] = self.cells[x] or {}
				self.cells[x][y] = m
			end
			table.insert(self.maps, m)
		end
	end
end

function World:initialize(mapDir)
	self.maps = {}
	self.cells = {}
	self.mapDir = mapDir
	self.camera = Camera()
	self.canvas = love.graphics.newCanvas(320,160)
	self:loadMaps()
end

function World:changeMap(x,y)
	print("Changing to " .. x .. ", " .. y)
	local m = self.currentMap
	local newMap,xx,yy = self:getMapAt(x,y)
	if m and newMap then
		local x,y = Player:getCenter()
		local cx,cy = m.cell.x,m.cell.y
		local pCellX, pCellY = Player:getCell() --cx + math.floor(x / 320), cy + math.floor(y / 160)
		x,y = x % 320, y % 160
		Player:setCenter(x,y)
	end
	if newMap then
		print(xx,yy)
		self.currentMap = newMap
		Player.x = Player.x + (320 * xx)
		Player.y = Player.y + (160 * yy)
		self.camera:setBounds(0,0,newMap.width * 16, newMap.height * 16)
		self.camera:lookAt(Player:getCenter())
		newMap:enter()
	end
end

function World:getMapAt(x,y)
	if self.cells[x] then
		local m = self.cells[x][y]
		if m then 
			return m, x - m.cell.x, y - m.cell.y
		else
			return nil
		end
	else
		return nil
	end
end

function World:update(dt)
	self.camera:lookAt(Player:getPosition())
	if self.currentMap then
		self.currentMap:update(dt)
	end
end

function World:draw()
	if self.currentMap then
		local oldCanvas = love.graphics.getCanvas()
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear()
		self.camera:attach()
		self.currentMap:draw()
		self.camera:detach()
		love.graphics.setCanvas(oldCanvas)
		love.graphics.draw(self.canvas,0,0)
	end
end
