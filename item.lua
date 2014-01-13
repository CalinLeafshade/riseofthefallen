
require('mapobject')

itemTileset = Tileset("gfx/itemtileset.png",16,16)

MapItem = Class("MapItem", MapObject)

function MapItem:initialize(itemDefinition,x,y)
	MapObject.initialize(self,x,y)
	self.item = itemDefinition
end

function MapItem:collide(with)
	if with == player then
		player:pickUp(self.item)
		self:remove()
	end
end

function MapItem:getWidth()
	return 16
end

function MapItem:getHeight()
	return 16
end

function MapItem:draw()
	self.item:draw(round(self.x),round(self.y))
end

Items = {}
-- this is a definition class and does not refer to actual items. item storage is done in the player class
Item = Class("Item")

function Item:initialize(name, tileID, def)
	self.name = name
	Items[name] = self
	self.tileID = tileID or 1
	for i,v in pairs(def or {}) do
		self[i] = v
	end
	table.insert(Items, self)
end

function Item:spawn(map,cx,cy)
	print("Spawning " .. self.name)
	local px,py = cx - 8, cy - 8
	map:attachObject(MapItem(self,px,py))
end

function Item:draw(x,y)
	love.graphics.setColor(255,255,255)
	itemTileset:draw(self.tileID, x,y)
end

function Item:isEquippable(slot)
	if not slot then
		return self.canEquip ~= nil
	else
		return self.canEquip[slot]
	end
end

function Item:isUseable( ... )
	return self.use ~= nil
end

--now load items
local itemDefs = love.filesystem.getDirectoryItems("items")

for i,v in ipairs(itemDefs) do
	love.filesystem.load("items/" .. v)()
	print("loaded " .. v)
end