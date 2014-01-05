
require('state')

MapState = State("Map")

MapState.opaque = false -- allow drawing to fall through

function MapState:update(dt, onTop)
	if not onTop then return end
	if Input:isNew("map") then
		stateManager:pop()
	end
end

function MapState:draw()
	love.graphics.setColor(0,0,0,100)
	love.graphics.rectangle("fill",0,0,320,180)
	love.graphics.setColor(255,255,255)
	world:drawMiniMap()
end