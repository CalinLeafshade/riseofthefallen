-- World

Camera = require('hump.camera')

World = Class("World")

function World:loadMaps()
	local files = love.filesystem.getDirectoryItems(self.mapDir)
	local minX,maxX,minY,maxY = math.huge,-math.huge,math.huge,-math.huge
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
			minX = math.min(minX,m.cell.x)
			minY = math.min(minY,m.cell.y)
			maxX = math.max(maxX,m.cell.x + m.width / 20)
			maxY = math.max(maxY,m.cell.y + m.height / 10)
		end
	end
	self.dimensions = { minX, maxX, minY, maxY }
	
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
	local m = player.map
	local newMap,xx,yy = self:getMapAt(x,y)
	if m and newMap then
		local x,y = player:getCenter()
		local cx,cy = m.cell.x,m.cell.y
		local pCellX, pCellY = player:getCell() --cx + math.floor(x / 320), cy + math.floor(y / 160)
		x,y = x % 320, y % 160
		player:setCenter(x,y)
	end
	if newMap then
		print(xx,yy)
		self.currentMap = newMap
		player.x = player.x + (320 * xx)
		player.y = player.y + (160 * yy)
		self.camera:setBounds(0,0,newMap.width * 16, newMap.height * 16)
		self.camera:lookAt(player:getCenter())
		newMap:enter()
		self.loadedNewMap = true
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

local function drawMap(m, cellWidth, cellHeight)
	
	for i,v in ipairs(m:getCells()) do
		if savestate:isVisited(v[1],v[2]) then
			local x,y = v[1] * cellWidth, v[2] * cellHeight
			love.graphics.setLineWidth(1)
			love.graphics.setLineStyle("rough")
			love.graphics.setColor(0,0,128)
			love.graphics.rectangle("fill",x + 0.5,y + 0.5, cellWidth, cellHeight)
			love.graphics.setColor(255,255,255)
			local dirs = {}
			if v[1] == m.cell.x then
				love.graphics.line(x, y, x, y + cellHeight)
				dirs.left = true
			end
			if v[1] == m.cell.x + ((m.width / 20) - 1) then
				love.graphics.line(x + cellWidth, y, x + cellWidth, y + cellHeight)
				dirs.right = true
			end
			if v[2] == m.cell.y then
				love.graphics.line(x - 1, y, x + cellWidth, y)
				dirs.top = true
			end
			if v[2] == m.cell.y + ((m.height / 10) - 1) then
				love.graphics.line(x - 1, y + cellHeight, x + cellWidth, y + cellHeight)
				dirs.bottom = true
			end
			love.graphics.setColor(0,0,128)
			for dir in pairs(dirs) do
				local i
				if dir == "left" or dir == "right" then
					i = (v[2] - m.cell.y)
				else
					i = (v[1] - m.cell.x)
				end
				if m.exits[dir][i] then
					local xx = x
					local yy = y + 1
					local xx2 = xx
					local yy2 = yy + 2
					if dir == "right" then
						xx = xx + cellWidth
						xx2 = xx
					elseif dir == "top" then
						yy = y
						yy2 = yy
						xx = x + 1
						xx2 = xx + 2
					elseif dir == "bottom" then
						yy = y + cellHeight
						yy2 = yy
						xx = x + 1
						xx2 = xx + 2
					end
					love.graphics.line(xx,yy,xx2,yy2)
				end
			end
				
			if player.map == m then
				love.graphics.setColor(255,255,255, (math.sin(love.timer.getTime() * 10) + 1) * 127)
				love.graphics.rectangle("fill",x + 0.5,y + 0.5, cellWidth, cellHeight)
			end
		end
	end
end

function World:drawMiniMap()
	local cellWidth = 5
	local cellHeight = 5

	local cx = (self.dimensions[1] + self.dimensions[2]) / 2
	local cy = (self.dimensions[3] + self.dimensions[4]) / 2
	print(cx,cy)
	love.graphics.push()
	love.graphics.translate(-round(cx * cellWidth) + 160,-round(cy * cellHeight) + 90)
	for _,map in ipairs(self.maps) do
		drawMap(map, cellWidth, cellHeight)
	end
	love.graphics.pop()
end

function World:update(dt)
	if self.loadedNewMap then
		self.loadedNewMap = false
		return -- dont update if we've just loaded a new map. dt might be big due to loading.
	end
	self.camera:lookAt(player:getCenter())
	if self.currentMap then
		self.currentMap:update(dt)
	end
	log("Camera:", self.camera:pos())
end

function World:draw()
	if self.currentMap then
		love.graphics.setColor(255,255,255)
		local oldCanvas = love.graphics.getCanvas()
		love.graphics.setCanvas(self.canvas)
		love.graphics.clear()
		self.camera:attach()
		self.currentMap:draw()
		self.camera:detach()
		love.graphics.setCanvas(oldCanvas)
		love.graphics.setColor(255,255,255)
		love.graphics.draw(self.canvas,0,0)
	end
end
