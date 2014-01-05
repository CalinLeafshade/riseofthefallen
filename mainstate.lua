
require("state")

MainState = State("Main")

function MainState:update(dt, onTop)
	if not onTop then return end
	player.ax = 0
	if Input:isDown("left") then
		player.ax = player.onGround and -30 or -10
	elseif Input:isDown("right") then
		player.ax = player.onGround and 30 or 10
	end
	if Input:isNew("jump") then
		if Input:isDown("down") then
			player:drop()
		else
			player:jump()
		end
	end
	if Input:isNew("use") then
		player:interact()
	end
	if Input:isNew("attack") then
		player:attack()
	end
	if Input:isNew("map") then
		stateManager:push(MapState)
	end
	world:update(dt)
	savestate:update(dt)
	GUI:update(dt)
end

function MainState:draw(onTop)
	world:draw()
	love.graphics.setColor(255,255,255)
	GUI:draw()
end