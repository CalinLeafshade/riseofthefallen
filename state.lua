
require('datadumper')
require('player')

State = Class("State")

function State.static.loadFromSlot(slot)
	local data = love.filesystem.load("save" .. slot .. ".lua")()
	return State(data.player.x, data.player.y, data.cell.x, data.cell.y)
end

function State:initialize(startX, startY, startCellX, startCellY)
	
	self.visited = {}
	self.player = Player(startX, startY)
	self.mapSize = {0,0,0,0}
	player = self.player
	world:changeMap(startCellX, startCellY)
end

function State:setVisited(x,y)
	self.mapSize[1] = math.min(self.mapSize[1], x)
	self.mapSize[2] = math.max(self.mapSize[2], x)
	self.mapSize[3] = math.min(self.mapSize[3], y)
	self.mapSize[4] = math.max(self.mapSize[4], y)
	self.visited[x] = self.visited[x] or {}
	self.visited[x][y] = true
end

function State:isVisited(x,y)
	return self.visited[x] and self.visited[x][y]
end

function State:update(dt)
	local x,y = player:getCell()
	self:setVisited(x,y)
end

function State:save(slot)
	local data = 
	{
		cell = player.map.cell,
		player = { x = player.x, y = player.y }
	}
	data = DataDumper(data)
	love.filesystem.write("save" .. slot .. ".lua",data)
	log(nil,"Saved!")
end

