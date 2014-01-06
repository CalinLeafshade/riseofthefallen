
Logger = 
{
	messages = {},
	font = love.graphics.newFont(14),
	dirty = true
}

function Logger:update(dt)
	local time = love.timer.getTime()
	for i,v in pairs(self.messages) do
		if time - v.time > 5 then
			self.messages[i] = nil
			self.dirty = true
		end
	end
end

function Logger:rebuildText()
	self.dirty = false
	local m = {}
	for i,v in pairs(self.messages) do
		table.insert(m, {time = v.time, text = (v.showToken and i or "") .. v.text})
	end
	table.sort(m,function(a,b) return a.time < b.time end)
	local t = ""
	for i,v in ipairs(m) do
		t = t .. v.text .. "\n"
	end
	self.text = t
end

function Logger:draw()
	love.graphics.setFont(self.font)
	if self.dirty then
		self:rebuildText()
	end
	love.graphics.setColor(0,0,0)
	love.graphics.print(self.text or "", 5,5)
	love.graphics.setColor(255,255,255)
	love.graphics.print(self.text or "", 4,4)
end

function Logger:add(token, ...)
	self.dirty = true
	local showToken = true
	if not token then
		token = tostring({})
		showToken = false
	end
	local t = ""
	for i,v in ipairs({...}) do
		t = t .. tostring(v) .. ", "
	end
	self.messages[token] = {time = love.timer.getTime(), showToken = showToken, text = t}
end

function log(...) -- quick alias function
	Logger:add(...)
end



