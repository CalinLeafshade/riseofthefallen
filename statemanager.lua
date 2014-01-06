
StateManager = Class("StateManager")

function StateManager:initialize()
	self.stack = {}
end

function StateManager:push(s)
	local current = self:current()
	if current then
		current:blur()
	end
	table.insert(self.stack,1,s)
	s:focus()
end

function StateManager:pop()
	local s = table.remove(self.stack,1)
	s:blur()
	local current = self:current()
	if current then
		current:focus()
	end
end

function StateManager:exchange(s)
	table.remove(s,1):blur()
	table.insert(self.stack,1,s)
	s:focus()
end

function StateManager:current()
	return self.stack[1]
end

function StateManager:update(dt)
	for i,v in ipairs(self.stack) do
		v:update(dt, i == 1)
	end
end

function StateManager:clear()
	self.stack = {}
end

function StateManager:draw()
	local toDraw = {}
	for i,v in ipairs(self.stack) do
		table.insert(toDraw,1,v) -- reverse the order for draw
		if v.opaque then
			break
		end
	end
	for i,v in ipairs(toDraw) do
		v:draw(i == #toDraw)
	end
end	

