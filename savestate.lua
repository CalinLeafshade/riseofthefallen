
require('lib.datadumper')
require('player')

SaveState = Class("SaveState")



function SaveState.static.enumerate()
	local slots = {}
	local files = love.filesystem.getDirectoryItems("")
	for i,v in ipairs(files) do
		if v:match("save%d%.lua") then
			local slot = v:match("%d")
			table.insert(slots, tonumber(slot))
		end
	end
	return slots
end

function SaveState.static.loadFromSlot(slot)
	local data = love.filesystem.load("save" .. slot .. ".lua")()
	return SaveState(data.player.x, data.player.y, data.cell.x, data.cell.y)
end

function SaveState:initialize(startX, startY, startCellX, startCellY)
	self.time = 0
	self.visited = {}
	self.player = Player(startX, startY)
	self.mapSize = {0,0,0,0}
	player = self.player
	world:changeMap(startCellX, startCellY)
end

function SaveState:setVisited(x,y)
	self.mapSize[1] = math.min(self.mapSize[1], x)
	self.mapSize[2] = math.max(self.mapSize[2], x)
	self.mapSize[3] = math.min(self.mapSize[3], y)
	self.mapSize[4] = math.max(self.mapSize[4], y)
	self.visited[x] = self.visited[x] or {}
	self.visited[x][y] = true
end

function SaveState:isVisited(x,y)
	return self.visited[x] and self.visited[x][y]
end

function SaveState:update(dt)
	local x,y = player:getCell()
	self.time = self.time + dt
	self:setVisited(x,y)
end

function SaveState:save(slot)
	local data = 
	{
		cell = player.map.cell,
		player = { x = player.x, y = player.y }
	}
	data = DataDumper(data)
	love.filesystem.write("save" .. slot .. ".lua",data)
	log(nil,"Saved!")
end

