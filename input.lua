
Input = 
{
	device = "both", -- keyboard, joypad or both
	keys = 
	{
		left = "left",
		right = "right",
		down = "down",
		up = "up",
		jump = "z",
		attack = "x",
		use = "up",
		map = "m",
		pause = "escape",
		select = "return"
	},
	buttons = 
	{
		jump = 1,
		attack = 2,
		map = 3,
		use = 4
	},
	deadzone = 0.5,
	last = {}
}

function Input:isDown(k)
	local val = false
	if self.device == "keys" or self.device == "both" and self.keys[k] then
		val = love.keyboard.isDown(self.keys[k])
	end
	if self.device == "joypad" or self.device == "both" and not val then
		local joypad = love.joystick.getJoysticks()[1]
		if joypad then
			if k == "left" then
				val = joypad:getAxis(1) < -self.deadzone
			elseif k == "right" then
				val = joypad:getAxis(1) > self.deadzone
			elseif k == "down" then
				val = joypad:getAxis(0) > self.deadzone
			elseif self.buttons[k] then
				val = joypad:isDown(self.buttons[k])
			end
		end
	end
	return val
end

function Input:isNew(k)
	return self:isDown(k) and not self.last[k]
end

function Input:update()
	for i,v in pairs(self.keys) do
		self.last[i] = love.keyboard.isDown(v)
	end
	local joypad = love.joystick.getJoysticks()[1]
	if joypad then
		for i,v in pairs(self.buttons) do
			self.last[i] = self.last[i] or joypad:isDown(v)
		end
	end
end

