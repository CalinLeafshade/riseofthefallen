
require("state")

MainState = State("Main")

function MainState:update(dt, onTop)
	if onTop then 
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
		if Input:isNew("pause") then
			stateManager:push(PauseState)
		end
		if Input:isNew("attack") then
			player:attack()
		end
		if Input:isNew("map") then
			stateManager:push(MapState)
		end
		world:update(dt)
		savestate:update(dt)
	end
	HealthGUI:update(dt)
	if MessageGUI.time and love.timer.getTime() - MessageGUI.time > 5 then
		MessageGUI.time = nil
		MessageGUI.message = nil
	end
	
end

function MainState:draw(onTop)
	world:draw()
	love.graphics.setColor(255,255,255)
	HealthGUI:draw()
	if onTop then
		MessageGUI:draw()
	end
end

require("gui.gui")

MessageGUI = GUI(0,155, 200, 20)

local font = love.graphics.newFont("fonts/betterpixels.ttf", 16)

function MessageGUI:draw( ... )
	if self.message then
		local w = font:getWidth(self.message)
		self.width = w + 10
		self.x = 320 - self.width - 5
		GUI.draw(self)
		love.graphics.setFont(font)
		love.graphics.print(self.message, self.x + 5, self.y + 3)
	end
end

function display(message)
	MessageGUI.message = message
	MessageGUI.time = love.timer.getTime()
end