
require("hurtableobject")

Enemy = Class("Enemy", HurtableObject)

function Enemy:initialize(x,y,props,hp)
	HurtableObject.initialize(self,x,y,props,hp)
end

function Enemy:wake()
	
end

function Enemy:getDrop()
	if not self.drops then return end
	table.sort(self.drops, function (a,b)
		return a[1] < b[1]
	end)
	
	local total = 0
	local rand = math.random(100)
	for i,v in ipairs(self.drops) do
		total = total + v[1]
		if rand < total then
			return Items[v[2]]
		end
	end
end

function Enemy:die( ... )
	local x1,y1,x2,y2 = self:bbox()
	local p = math.abs((x2 - x1) * (y2 - y1))
	local cx,cy = self:getCenter()
	local w,h = self:getSize()
	for i=1,p / 10 do
		Smoke(cx + math.random(-w/2,w/2) * (math.random() * math.random()),cy + math.random(-h/ 2,h/2) * (math.random() * math.random()))
	end
	local d = self:getDrop()
	if d then
		d:spawn(self.map, cx,cy)
	end
	MapObject.die(self)
end

Enemies = {}

local enemyDefs = love.filesystem.getDirectoryItems("enemies")

for i,v in ipairs(enemyDefs) do
	love.filesystem.load("enemies/" .. v)()
	print("loaded " .. v)
end