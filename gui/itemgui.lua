
require('gui.gui')

ItemGUI = Class("ItemGui", GUI)

ItemGUI.selected = 1
ItemGUI.scroll = 0

local function defaultFilter(item)
	return true
end

function ItemGUI:onItemChange( ... )
	-- body
end

function ItemGUI:onItemSelect( ... )
	-- body
end

function ItemGUI:rows( ... )
	return (self.height - 10) / 15
end

function ItemGUI:setFilter(filter)
	assert(type(filter) == "function", "filter should be a function")
	self.filter = filter
	self.selected = 1
end

function ItemGUI:receiveInput(input)
	if #self.items == 0 then return end
	local s = self.selected
	if input == "right" or input == "left" then
		if self.selected % 2 == 1 and self.selected < #self.items then
			self.selected = self.selected + 1
		elseif self.selected % 2 == 0 and self.selected > 1 then
			self.selected = self.selected - 1
		end
	elseif input == "down" then
		self.selected = clamp(self.selected + 2, 1, #self.items)
		if math.ceil(self.selected / 2) > self.scroll + self:rows() then
			self.scroll = self.scroll + 1
		end
	elseif input == "up" then
		self.selected = clamp(self.selected - 2, 1, #self.items)
		if math.ceil(self.selected / 2) < self.scroll + 1 then 
			self.scroll = self.scroll - 1
		end
	elseif input == "select" then
		self:onItemSelect(self.items[self.selected].item)
	end
	if self.selected ~= s then
		self:onItemChange(self.items[self.selected].item)
	end
end

function ItemGUI:blur( ... )
	self:onItemChange()
end

function ItemGUI:focus( ... )
	self.selected = 1
	self:update()
	if #self.items > 0 then
		self:onItemChange(self.items[self.selected].item)
	else
		self:onItemChange()
	end
end

function ItemGUI:update( dt )
	GUI.update(self, dt)
	self.items = {}
	for i,v in ipairs(Items) do
		if player.items[v] and (self.filter or defaultFilter)(v) then
			table.insert(self.items, { count = player.items[v], item = v})
		end
	end
	table.sort(self.items, function (a,b)
		return a.item.name < b.item.name
	end)
end

function ItemGUI:draw()
	GUI.draw(self)
	if self.items and #self.items > 0 then
		local x, y = self.x + 10, self.y + 4
		local filter = self.filter or defaultFilter
		for i=self.scroll * 2 + 1, (self.scroll * 2) + math.min(#self.items, ((self.height - 10) / 15) * 2) do
			local v = self.items[i]
			local c = self.selected == i and Color.White or Color.Grey
			c = filter(v.item) and c or Color.DarkGrey
			love.graphics.setColor(c)
			if self.selected == i and self.isActive then 
				self:drawSelector(x + 8, y + Fonts.betterPixels:getHeight() / 2)
			end
			v.item:draw(x + 8,y)
			love.graphics.print(v.item.name, x + 25, y + 2)
			love.graphics.print(v.count, (x + self.width / 2) - 20 , y + 2)
			if x == self.x + 10 then
				x = self.width / 2 + 5
			else
				y = y + 16
				x = self.x + 10
			end
		end
	else
		love.graphics.printf("No suitable items",self.x,self.y + self.height / 2 - Fonts.betterPixels:getHeight() / 2,self.width,"center")
	end
end